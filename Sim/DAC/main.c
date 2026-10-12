#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#define DAC_THRESHOLD_INTEGER   2
#define DAC_THRESHOLD_FRACTRION 12

#define DAC_DELAY_COEFFICIENT_INTEGER   2
#define DAC_DELAY_COEFFICIENT_FRACTRION 114 // /256
#define DAC_DELAY_OFFSET                20000

#define DAC_ADC_ZERO_INTEGER    65
#define DAC_ADC_ZERO_FRACTION   136 // /256

#define DAC_CFD_ZERO_INTEGER    65
#define DAC_CFD_ZERO_FRACTION   136 // /256



static int16_t DAC_threshold_offset[12] = {0};


void DAC_sendValue(uint8_t index, uint8_t channel, uint16_t value){
    static long long int i = 0;
    printf("%llu,%u\n", i, value);
    i++;
}

#define FIX_POINT_FRACTION_BITS 8
#define FIX_POINT_SCALE         (1 << FIX_POINT_FRACTION_BITS)

typedef int16_t fixPoint_t;
typedef uint16_t uFixPoint_t;

static inline fixPoint_t FixPoint_convert(bool isNegative, uint8_t integer, uint8_t fraction){
    fixPoint_t value = ((int16_t)integer << FIX_POINT_FRACTION_BITS) | fraction;
    return isNegative ? -value : value;
}

#define uFixPoint_converter(integer, fraction)  (\
    (uFixPoint_t)(integer << FIX_POINT_FRACTION_BITS | fraction) \
)

static inline int8_t FixPoint_getInteger(fixPoint_t value){
    return (int8_t)(value >> FIX_POINT_FRACTION_BITS);
}

static inline uint8_t FixPoint_getFraction(fixPoint_t value){
    if (value < 0){
        value = -value;
    }
    return (uint8_t)(value & 0xFF);
}

static inline uint8_t uFixPoint_getFraction(uFixPoint_t value){
    return (uint8_t)(value & 0xFF);
}

uint16_t uFixPoint_multiplay_int16(uFixPoint_t fix, int16_t integer){
    uint32_t result = ((uint32_t)fix * integer);
    if (result & 1 << 7){
        result = (result >> FIX_POINT_FRACTION_BITS) + 1;
    } else {
        result = result >> FIX_POINT_FRACTION_BITS;
    }
    return result;
}

int16_t uFixPoint_multiplay_int16_with_limit(uFixPoint_t fix, int16_t integer){
    uint32_t result = ((int32_t)integer * fix);
    if (result & 1 << 7){
        result = (result >> FIX_POINT_FRACTION_BITS) + 1;
    } else {
        result = result >> FIX_POINT_FRACTION_BITS;
    }

    if (result > 0xFFFF){
        return 0xFFFF;
    }
    return result;
}




void DAC_setValue_CFD_threshold(uint8_t index, uint16_t CFD_threshold){
    uFixPoint_t coefficient = uFixPoint_converter(DAC_THRESHOLD_INTEGER, DAC_THRESHOLD_FRACTRION);
    uint16_t dac_cfd_threshold_value = ~(uFixPoint_multiplay_int16_with_limit(coefficient, CFD_threshold) + DAC_threshold_offset[index]);
    DAC_sendValue(index, 0, dac_cfd_threshold_value);
}

void DAC_setValue_ADC_delay(uint8_t index, uint16_t ADC_delay){
    uFixPoint_t coefficient = uFixPoint_converter(DAC_DELAY_COEFFICIENT_INTEGER, DAC_DELAY_COEFFICIENT_FRACTRION);
    ADC_delay = DAC_DELAY_OFFSET - ADC_delay;
    uint16_t dac_adc_delay_value = uFixPoint_multiplay_int16_with_limit(coefficient, ADC_delay);
    DAC_sendValue(index, 0, dac_adc_delay_value);
}
void DAC_setValue_CFD_zero(uint8_t index, int16_t CFD_zero){
    uFixPoint_t coefficient = uFixPoint_converter(DAC_CFD_ZERO_INTEGER, DAC_CFD_ZERO_FRACTION);
    uint16_t dac_cfd_zero_value = uFixPoint_multiplay_int16(coefficient, CFD_zero) ^ 0x8000;
    DAC_sendValue(index, 0, dac_cfd_zero_value);
}




int main(){
    printf("index,R16:R17\n");
    uint16_t i = 0;
    for (uint32_t j = 0; j < 65536; j++){
        // DAC_setValue_CFD_threshold(0, i);
        // DAC_setValue_ADC_delay(0, i);
        DAC_setValue_CFD_zero(0, i);
        i++;
    }
}
