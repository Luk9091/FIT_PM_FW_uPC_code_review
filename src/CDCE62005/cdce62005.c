#include "cdce62005.h"

#include <avr/interrupt.h>

#include "ths788.h"

static uint32_t CDCE62005_RESET_VALUE [] = {
    // CDCE62005 is a main PLL module, with switch between three clock source
    // HDMI Clk -> External Clk (lemo connection) -> internal clock
    //
    // Data frame consists of 28 data bits and 8 address bits,
    // First transmit from LSB
    //           Address
    //           |
    0x00001808, // 1 PLL SPI DATA              0x2916          |  0x00
    //  Disable sleep mode
    //  Exit to synchronization state
    0xEB070320, // 2                           0x291A          |  0x0E
    //  Pre-Divider by 2
    //  Select the signal driving: VCO_core
    //  Coarse phase adjust:
    0x210380EB, // 3                           0x291E          |  0x02
    0x020306EB, // 4                           0x2922          |  0x00
    0x030380EB, // 5                           0x2926          |  0x00
    0x34038468, // 6                           0x292A          |  0x03
    0x350F0440, // 7                           0x292E          |  0x03
    0x8601FEC0, // 8                           0x2932          |  0x08
    0xF7BB42BD, // 9                           0x2936          |  0x0F
    0x8601FEC4, // 10 End PLL SPI DATA         0x293A          |  0x08
};

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
        data = data << 8 | CDCE62005_read_raw_8bits();
    }
    data = data >> 4;
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
    // THS788_reset(false);
}
