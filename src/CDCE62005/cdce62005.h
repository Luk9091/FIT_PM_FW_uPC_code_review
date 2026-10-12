#ifndef __CDCE62005_H__
#define __CDCE62005_H__

#include <stdbool.h>
#include <avr/io.h>

#define CDCE62005_SPI_CS_PIN_bm         (1 << 4)
#define CDCE62005_PLL_SYNC_PIN_bm       (1 << 5)
#define CDCE62005_PLL_LOCK_PIN_bm       (1 << 6)

#define CDCE62005_PLL_SPI               (SPIC)
#define CDCE62005_PLL_SPI_MOSI_PIN_bm   (1 << 5)
#define CDCE62005_PLL_SPI_MISO_PIN_bm   (1 << 6)
#define CDCE62005_PLL_SPI_CLK_PIN_bm    (1 << 7)

#define CDCE62005_REG8_NSYNC_BIT_bp     (8)

static inline uint32_t CDCE62005_merge_address_with_data(uint8_t address, uint32_t data){
    return (data << 4) | address & 0x0F;
}

static inline void CDC62005_send_raw_8bits(uint8_t data){
    SPIC.DATA = data;
    while(!(SPIC.STATUS & (1 << 7)));
}
static inline uint8_t CDCE62005_read_raw_8bits(){
    SPIC.DATA = 0;
    while(!(SPIC.STATUS & (1 << 7)));
    return SPIC_DATA;
}

static inline void CDCE62005_chipSelect(bool enable){
    if (enable) {
        PORTF.OUTCLR = CDCE62005_SPI_CS_PIN_bm;
    } else {
        PORTF.OUTSET = CDCE62005_SPI_CS_PIN_bm;
    }
}

static inline void CDCE62005_SPI_config(){
    // SPIC.CTRL = 0xF1;
    // SPIC.CTRL = 0b1111'0001;
    SPIC.CTRL =
        1 << SPI_CLK2X_bp   | // double frequency
        1 << SPI_ENABLE_bp  | // enable
        1 << SPI_DORD_bp    | // LSB first
        1 << SPI_MASTER_bp  | // Master mode
        0 << SPI_MODE_gp    | // Sample: Rising, Setup: Falling
        1 << SPI_PRESCALER_gp;// CLK/16 -> 32MHz/8 = 4MHz
}

void CDCE62005_send_control_settings(uint32_t data);
uint32_t CDCE62005_read_register(uint8_t address);
void CDCE62005_control_reset();

#endif
