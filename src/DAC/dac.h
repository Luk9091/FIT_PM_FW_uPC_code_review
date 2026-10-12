#ifndef __DAC_H__
#define __DAC_H__

#include <avr/io.h>
#include <stdint.h>
#include <stdbool.h>

#include "fixPoint.h"


#define DAC_SYNC_PORT       (PORTC)
#define DAC_SYNC_A_PIN_bp   (0)
#define DAC_SYNC_A_PIN_bm   (1 << 0)
#define DAC_SYNC_B_PIN_bm   (1 << 1)
#define DAC_SYNC_C_PIN_bm   (1 << 2)

#define DAC_SPI             (SPIC)
#define DAC_SPI_MOSI_PIN_bm (1 << 5)
#define DAC_SPI_CLK_PIN_bm  (1 << 7)

typedef enum {
    DAC_CHANNEL_ADC_DELAY     = 0,
    DAC_CHANNEL_ADC_OFFSET    = 1,
    DAC_CHANNEL_CFD_ZERO      = 2,
    DAC_CHANNEL_CFD_THRESHOLD = 3
} DAC_CHANNEL_t;

static inline void DAC_chipSelect_disableAll(){
    DAC_SYNC_PORT.OUTSET = DAC_SYNC_A_PIN_bm | DAC_SYNC_B_PIN_bm | DAC_SYNC_C_PIN_bm;
}

// DAC send value,
// @param index in range from 0 to 11
void DAC_sendValue(uint8_t index, DAC_CHANNEL_t channel , uint16_t value);

void DAC_setValue_CFD_threshold(uint8_t index, uint16_t CFD_threshold);
void DAC_setValue_ADC_delay(uint8_t index, uint16_t ADC_delay);
void DAC_setValue_CFD_zero(uint8_t index, int16_t CFD_zero);
void DAC_setValue_ADC_zero(uint8_t index, int16_t ADC_zero);



#endif
