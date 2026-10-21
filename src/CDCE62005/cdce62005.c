#include "cdce62005.h"
#include "cdce62005_regMap.h"

#include <avr/interrupt.h>

#include "timer.h"
#include "ths788.h"
#include "leds.h"
// #include "myError.h"

uint8_t errorStatus;

#define PLL_STATUS_LOCK_bm      (1 << 0)
#define PLL_STATUS_PRIACTIVE_bm (1 << 1)
#define PLL_STATUS_SECACTIVE_bm (1 << 2)
#define PLL_STATUS_AUXACTIVE_bm (1 << 3)
// this should be clear in deinit
static uint8_t PLL_oldStatus = 0;

static uint32_t CDCE62005_RESET_VALUE [10] = {
    // CDCE62005 is a main PLL module, with switch between three clock source
    // HDMI Clk -> External Clk (lemo connection) -> internal clock
    //
    // Data frame consists of 28 data bits and 8 address bits,
    // First transmit from LSB
    //           Address
    //           |

    0x00001808,
    0xEB070320,
    0xEB800321,
    0xEB060302,
    0xEB800303,
    0x68840334,
    0x40040F35,
    0xC0FE0186,
    0xBD42BBF7,
    0xC4FE0186,
};

static uint32_t CDCE62005_CLI_RST_VALUE[9] = {
    0x69070320,
    0x69800321,
    0x69060302,
    0x69800303,
    0x68840334,
    0x40040F35,
    0xC0EE0186,
    0xBC7837F7,
    0x0000001F,
};

ISR(PORTF_INT1_vect){
    uint8_t input = CDCE62005_CTRL_PORT.IN;
    bool PLL_lock = input & CDCE62005_PLL_LOCK_PIN_bm;
    bool PLL_sync = input & CDCE62005_PLL_SYNC_PIN_bm;

    if (PLL_lock == 1 && PLL_sync == 0){
        CDCE62005_send_control_settings(CDCE62005_merge_address_with_data(5, 0x040040FF));
        CDCE62005_sync(true);
    }
    uint8_t new_syncSource = (CDCE62005_readStatusRegister() >> (REG8_PRIACTIVITY_bp - 1)) & (PLL_STATUS_PRIACTIVE_bm | PLL_STATUS_SECACTIVE_bm | PLL_STATUS_AUXACTIVE_bm);
    uint8_t old_syncSource = PLL_oldStatus & 0xE;
    PLL_oldStatus = new_syncSource | PLL_lock;

    if (old_syncSource != new_syncSource){
        errorStatus = 0x20;
        if (new_syncSource & PLL_STATUS_PRIACTIVE_bm){
            LED_put(LED_CLK_IN, 1);
            GPIOR0 = 1 << 2;
        } else if (new_syncSource & PLL_STATUS_SECACTIVE_bm){
            GPIOR0 = 1 << 2;
        } else if (new_syncSource & PLL_STATUS_AUXACTIVE_bm){
            LED_put(LED_CLK_ERROR, 1);
            GPIOR0 = 1 << 2;
        }
    }
    if (PLL_lock) {
        R215A = 10;
        R2159 = 1;
    } else {
        FPGA_THSs_reset_loop();
        errorStatus = 2;
    }
}

static inline void CDC62005_send_raw_8bits(uint8_t data){
    SPIC.DATA = data;
    while(!(SPIC.STATUS & (1 << 7)));
}
static inline uint8_t CDCE62005_read_raw_8bits(){
    SPIC.DATA = 0;
    while(!(SPIC.STATUS & (1 << 7)));
    return SPIC.DATA;
}

void CDCE62005_send_control_settings(uint32_t data){
    CDCE62005_SPI_config();
    CDCE62005_chipSelect(true);
    CDC62005_send_raw_8bits(data >> 0);
    CDC62005_send_raw_8bits(data >> 8);
    CDC62005_send_raw_8bits(data >> 16);
    CDC62005_send_raw_8bits(data >> 24);
    CDCE62005_chipSelect(false);
}

uint32_t CDCE62005_read_register(uint8_t address){
    CDCE62005_send_control_settings(CDCE62005_merge_address_with_data(0x0E, address));
    CDCE62005_chipSelect(true);
    uint32_t data = 0;
    for (int i = 0; i < 4; i++){
        data |= (uint32_t)CDCE62005_read_raw_8bits() << (8 * i);
    }
    CDCE62005_chipSelect(false);
    return data;
}

void CDCE62005_control_reset(){
    for (int i = 0; i < 10; i++){
        cli();
        CDCE62005_send_control_settings(CDCE62005_RESET_VALUE[i]);
        sei();
    }

    PORTF.INTCTRL |= PORT_INT1LVL_MED_gc;
    THS788_reset(false);
}

void CDCE62005_restart(){
    if (cli_get_next_char() != '\r'){
        cli_send_syntaxError();
        return;
    }

    for (uint8_t i = 0; i < 9; i++){
        CDCE62005_send_control_settings(CDCE62005_CLI_RST_VALUE[i]);
    }

    cli_send_msg("OK\r\n");
}



bool CDCE62005_getLockTimeout(uint8_t timeout_ms){
    uint8_t time = 0;;
    bool lock;
    do{
        lock = CDCE62005_getLockStatus();
        if (time > timeout_ms){
            break;
        }
        _delay_ms(1);
        time++;
    }while(!lock);

    cli_send_msg("Lock value: ");
    cli_send_hex_digit(lock);
    cli_send_newLine();
    return lock;
}
