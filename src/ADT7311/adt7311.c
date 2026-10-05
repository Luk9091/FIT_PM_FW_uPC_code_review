#include "adt7311.h"

static inline void ADT7311_data_line(bool level){
    if (level){
        TEMPSENS_PORT.OUTSET = TEMPSENS_DIN_bm;
    } else {
        TEMPSENS_PORT.OUTCLR = TEMPSENS_DIN_bm;
    }
}
static inline void ADT7311_clock_line(bool level){
    if (level){
        TEMPSENS_PORT.OUTSET = TEMPSENS_CLK_bm;
    } else {
        TEMPSENS_PORT.OUTCLR = TEMPSENS_CLK_bm;
    }
}

static inline void ADT7311_chipSelect_line(bool enable){
    if (enable){
        TEMPSENS_PORT.OUTCLR = TEMPSENS_CS_bm;
    } else {
        TEMPSENS_PORT.OUTSET = TEMPSENS_CS_bm;
    }
}

static inline bool ADT7311_read_line(){
    return TEMPSENS_PORT.IN & TEMPSENS_DOUT_bm;
}

static uint8_t ADT7311_byte_readWrite(uint8_t value){
    uint8_t readData = 0;
    for (uint8_t i = 0; i < 8; i++){
        ADT7311_data_line(value & (1 << 7));
        ADT7311_clock_line(false);
        value = value << 1;
        readData = readData << 1 | ADT7311_read_line();
        ADT7311_clock_line(true);
    }

    return readData;
}

void ADT7311_faults_clear(){
    ADT7311_chipSelect_line(true);
    ADT7311_byte_readWrite(0xFF);
    ADT7311_byte_readWrite(0xFF);
    ADT7311_byte_readWrite(0xFF);
    ADT7311_byte_readWrite(0xFF);
    ADT7311_chipSelect_line(false);
}

uint16_t ADT7311_16bits_readWrite(uint8_t address, bool read, uint16_t data){
    ADT7311_chipSelect_line(true);
    ADT7311_byte_readWrite((read << 6) | (address << 3));
    uint16_t receive =
        ((uint16_t)ADT7311_byte_readWrite(data >> 8) << 8)
        |          ADT7311_byte_readWrite(data);
    ADT7311_chipSelect_line(false);
    return receive;
}

uint8_t ADT7311_8bits_readWrite(uint8_t address, bool read, uint8_t data){
    ADT7311_chipSelect_line(true);
    ADT7311_byte_readWrite((read << 6) | (address << 3));
    uint8_t receive = ADT7311_byte_readWrite(data);
    ADT7311_chipSelect_line(false);
    return receive;
}
