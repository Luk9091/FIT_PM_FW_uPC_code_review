#ifndef __ADT7311_H__
#define __ADT7311_H__

#include <avr/io.h>
#include <stdint.h>
#include <stdbool.h>

#include "fixPoint.h"

#include "adt7311_registerMap.h"


#define TEMPSENS_PORT       PORTA
#define TEMPSENS_CLK_bm     (1 << 1)
// Data out from the temperature sensor
#define TEMPSENS_DOUT_bm    (1 << 2)
// Data in to the temperature sensor
#define TEMPSENS_DIN_bm     (1 << 3)
#define TEMPSENS_CS_bm      (1 << 4)

void ADT7311_faults_clear();
// To read data from this sensor data should be 1
uint16_t ADT7311_16bits_readWrite(uint8_t address, bool read, uint16_t data);
uint8_t  ADT7311_8bits_readWrite(uint8_t address, bool read, uint8_t data);

static inline uint8_t adt7311_8bits_read(uint8_t address){
    return ADT7311_8bits_readWrite(address, true, 0xFF);
}
static inline uint8_t adt7311_8bits_write(uint8_t address, uint8_t data){
    return ADT7311_8bits_readWrite(address, false, data);
}

static inline uint16_t adt7311_16bits_read(uint8_t address){
    return ADT7311_16bits_readWrite(address, true, 0xFFFF);
}
static inline uint16_t adt7311_16bits_write(uint8_t address, uint16_t data){
    return ADT7311_16bits_readWrite(address, false, data);
}

static inline uFixPoint_t adt7311_read_13bits_temperature(){
    return (adt7311_16bits_read(ADT7311_TEMPERATURE_VALUE_REG_ADDR) & 0xFFF8) << 2;
}

static inline uFixPoint_t adt7311_read_16bits_temperature(){
    return (adt7311_16bits_read(ADT7311_TEMPERATURE_VALUE_REG_ADDR)) << 2;
}

static inline uFixPoint_t adt7311_read_temperatureWithFlags(bool *belowLOW, bool *aboveHIGH, bool *aboveCRIT){
    uint16_t data = adt7311_16bits_read(ADT7311_TEMPERATURE_VALUE_REG_ADDR);
    *belowLOW = data & 1 << 0;
    *aboveHIGH = data & 1 << 1;
    *aboveCRIT = data & 1 << 2;
    return (data & 0xFFF8) << 2;

}

static inline uFixPoint_t adt7311_raw13bits_to_celsius(uint16_t value){
    return (value & 0xFFF8) << 2;
}

static inline uint16_t adt7311_celsiusToThreshold(int16_t celsius){
    return celsius << 7;
}
#endif
