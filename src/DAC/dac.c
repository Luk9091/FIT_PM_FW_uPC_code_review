#include "dac.h"

#include <avr/interrupt.h>

#include <fixPoint.h>

#define DAC_THRESHOLD_INTEGER   2
#define DAC_THRESHOLD_FRACTRION 12 // /256

#define DAC_DELAY_COEFFICIENT_INTEGER   2
#define DAC_DELAY_COEFFICIENT_FRACTRION 114 // /256
#define DAC_DELAY_OFFSET                20000

#define DAC_ADC_ZERO_INTEGER    65
#define DAC_ADC_ZERO_FRACTION   136 // /256

#define DAC_CFD_ZERO_INTEGER    65
#define DAC_CFD_ZERO_FRACTION   136 // /256

static uint16_t DAC_threshold_offset[12] = {0};


static inline void DAC_chipSelect_enableAll(){
    DAC_SYNC_PORT.OUTCLR = DAC_SYNC_A_PIN_bm | DAC_SYNC_B_PIN_bm | DAC_SYNC_C_PIN_bm;
}

static inline void DAC_chipSelect(uint8_t index, bool enable){
    if (enable){
        DAC_SYNC_PORT.OUTCLR = 1 << (DAC_SYNC_A_PIN_bp + (index / 4));
    } else {
        DAC_SYNC_PORT.OUTSET = 1 << (DAC_SYNC_A_PIN_bp + (index / 4));
    }
}

static inline void DAC_spi_config(){
    // DAC_SPI.CTRL = 0xD5;
    // DAC_SPI.CTRL = 0b1101 0101
    DAC_SPI.CTRL =
        1 << SPI_CLK2X_bp   | // double frequency
        1 << SPI_ENABLE_bp  | // enable
        0 << SPI_DORD_bp    | // MSB first
        1 << SPI_MASTER_bp  | // Master mode
        1 << SPI_MODE_gp    | // Setup: Rising, Sample: Falling
        1 << SPI_PRESCALER_gp;// CLK/16 -> 32MHz/8 = 4MHz
}

static inline void DAC_rawSend(uint8_t value){
    DAC_SPI.DATA = value;
    while(!(DAC_SPI.STATUS & 1 << 7));
}

void DAC_sendValue(uint8_t index, DAC_CHANNEL_t channel, uint16_t value){
    cli();
    DAC_spi_config();
    DAC_chipSelect(index, true);
    DAC_rawSend(((index % 4) << 6) | (channel << 1) | 0x10);
    DAC_rawSend(value >> 8);
    DAC_rawSend(value >> 0);
    DAC_chipSelect(index, false);
    sei();
}

void DAC_setValue_CFD_threshold(uint8_t index, uint16_t CFD_threshold){
    uFixPoint_t coefficient = uFixPoint_converter(DAC_THRESHOLD_INTEGER, DAC_THRESHOLD_FRACTRION);
    uint16_t dac_cfd_threshold_value = ~(uFixPoint_multiplay_int16_with_limit(coefficient, CFD_threshold) + DAC_threshold_offset[index]);
    DAC_sendValue(index, DAC_CHANNEL_CFD_THRESHOLD, dac_cfd_threshold_value);
}

void DAC_setValue_ADC_delay(uint8_t index, uint16_t ADC_delay){
    uFixPoint_t coefficient = uFixPoint_converter(DAC_DELAY_COEFFICIENT_INTEGER, DAC_DELAY_COEFFICIENT_FRACTRION);
    ADC_delay = DAC_DELAY_OFFSET - ADC_delay;
    uint16_t dac_adc_delay_value = uFixPoint_multiplay_int16_with_limit(coefficient, ADC_delay);
    DAC_sendValue(index, DAC_CHANNEL_ADC_DELAY, dac_adc_delay_value);
}

void DAC_setValue_CFD_zero(uint8_t index, int16_t CFD_zero){
    uFixPoint_t coefficient = uFixPoint_converter(DAC_CFD_ZERO_INTEGER, DAC_CFD_ZERO_FRACTION);
    uint16_t dac_cfd_zero_value = uFixPoint_multiplay_int16(coefficient, CFD_zero) ^ 0x8000;

    DAC_sendValue(index, DAC_CHANNEL_CFD_ZERO, dac_cfd_zero_value);
}

void DAC_setValue_ADC_zero(uint8_t index, int16_t ADC_zero){
    uFixPoint_t coefficient = uFixPoint_converter(DAC_ADC_ZERO_INTEGER, DAC_ADC_ZERO_FRACTION);
    uint16_t dac_adc_zero_value = uFixPoint_multiplay_int16(coefficient, ADC_zero) ^ 0x8000;

    DAC_sendValue(index, DAC_CHANNEL_CFD_ZERO, dac_adc_zero_value);
}


