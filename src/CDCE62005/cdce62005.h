#ifndef __CDCE62005_H__
#define __CDCE62005_H__

#include <stdbool.h>
#include <avr/io.h>
#include <util/delay.h>
#include "usart.h"

#define CDCE62005_CTRL_PORT             (PORTF)
#define CDCE62005_SPI_CS_PIN_bm         (1 << 4)
#define CDCE62005_PLL_SYNC_PIN_bm       (1 << 5)
#define CDCE62005_PLL_LOCK_PIN_bm       (1 << 6)

#define CDCE62005_PLL_SPI               (SPIC)
#define CDCE62005_PLL_SPI_MOSI_PIN_bm   (1 << 5)
#define CDCE62005_PLL_SPI_MISO_PIN_bm   (1 << 6)
#define CDCE62005_PLL_SPI_CLK_PIN_bm    (1 << 7)

#define CDCE62005_REG8_NSYNC_BIT_bp     (8)

void CDCE62005_send_control_settings(uint32_t data);
uint32_t CDCE62005_read_register(uint8_t address);
void CDCE62005_control_reset();
bool CDCE62005_getLockTimeout(uint8_t timeout_ms);

static inline uint32_t CDCE62005_merge_address_with_data(uint8_t address, uint32_t data){
    return (data << 4) | address & 0x0F;
}

static inline uint32_t CDCE62005_readStatusRegister(){
    return CDCE62005_read_register(8);
}

static inline void CDCE62005_chipSelect(bool enable){
    if (enable) {
        PORTF.OUTCLR = CDCE62005_SPI_CS_PIN_bm;
    } else {
        PORTF.OUTSET = CDCE62005_SPI_CS_PIN_bm;
    }
}

static inline void CDCE62005_sync(bool synchronization){
    if (synchronization) {
        PORTF.OUTSET = CDCE62005_PLL_SYNC_PIN_bm;
    } else {
        PORTF.OUTCLR = CDCE62005_PLL_SYNC_PIN_bm;
    }
}

static inline bool CDCE62005_getLockStatus(){
    return PORTF.IN & CDCE62005_PLL_LOCK_PIN_bm;
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

#endif
