#ifndef __FPGA_COMMUNICATION_H__
#define __FPGA_COMMUNICATION_H__

#include <stdint.h>
#include <stdbool.h>
#include <avr/io.h>

#define FPGA_SPI_PORT PORTD
#define FPGA_SPI    SPIC

#define FPGA_SPI_CS_PIN_bm      (1 << 0)
#define FPGA_SPI_HSEL_PIN_bm    (1 << 4)
#define FPGA_SPI_HMOSI_PIN_bm   (1 << 5)
#define FPGA_SPI_HMISO_PIN_bm   (1 << 6)
#define FPGA_SPI_HCLK_PIN_bm    (1 << 7)

#define FPGA_RESET_PORT    (PORTB)
#define FPGA_RESET_PIN_bm  (1 << 7)

static inline void FPGA_SPI_config(){
    // SPIC.CTRL = 0xD1;
    // SPIC.CTRL = 0b1101'0001;
    SPIC.CTRL =
        1 << SPI_CLK2X_bp   | // double frequency
        1 << SPI_ENABLE_bp  | // enable
        0 << SPI_DORD_bp    | // MSB first
        1 << SPI_MASTER_bp  | // Master mode
        0 << SPI_MODE_gp    | // Sample: Rising, Setup: Falling
        1 << SPI_PRESCALER_gp;// CLK/16 -> 32MHz/8 = 4MHz
}

static inline void FPGA_HSPI_config(){
    // SPID.CTRL = 0x44;
    // SPID.CTRL = 0b0100 0100;
    SPID.CTRL =
        0 << SPI_CLK2X_bp   | // no double frequency
        1 << SPI_ENABLE_bp  | // enable
        0 << SPI_DORD_bp    | // MSB first
        0 << SPI_MASTER_bp  | // Slave mode
        1 << SPI_MODE_gp    | // Setup: Rising, Sample: Falling
        0 << SPI_PRESCALER_gp;// CLK/16 -> 32MHz/8 = 4MHz

}

static void FPGA_raw_send_8bit(uint8_t data) {
    SPIC.DATA = data;
    while(!(SPIC.STATUS & 1 << 7));
}

static inline void FPGA_send_address(uint16_t address){
    address = address << 6;
    FPGA_raw_send_8bit(address > 8);
    FPGA_raw_send_8bit(address);
}

static inline void FPGA_SPI_DATA_chipSelect(bool enable){
    if (enable) {
        FPGA_SPI_PORT.OUTCLR = FPGA_SPI_CS_PIN_bm;
    } else {
        FPGA_SPI_PORT.OUTSET = FPGA_SPI_CS_PIN_bm;
    }
}

static inline void FPGA_DATA_send(uint16_t address, uint32_t data){
    FPGA_SPI_config();
    FPGA_SPI_DATA_chipSelect(true);
    FPGA_send_address(address);

    for (int i = 4; i --> 0;){
        FPGA_raw_send_8bit(data >> 8*i);
    }
    FPGA_SPI_DATA_chipSelect(false);
}

static inline void FPGA_reset(bool reset){
    if (reset) {
        FPGA_RESET_PORT.OUTSET = FPGA_RESET_PIN_bm;
    } else {
        FPGA_RESET_PORT.OUTCLR = FPGA_RESET_PIN_bm;
    }
}


void FPGA_send_mcu_timestamp(uint32_t timestamp);

#endif
