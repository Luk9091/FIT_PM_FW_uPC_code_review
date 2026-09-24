#ifndef __MY_FIXPOINT_H__
#define __MY_FIXPOINT_H__

#include <stdint.h>
#include <stdbool.h>

#define FIX_POINT_FRACTION_BITS 8
#define FIX_POINT_SCALE         (1 << FIX_POINT_FRACTION_BITS)

typedef int16_t fixPoint_t;

static inline fixPoint_t FixPoint_convert(bool isNegative, uint8_t integer, uint8_t fraction){
    fixPoint_t value = ((int16_t)integer << FIX_POINT_FRACTION_BITS) | fraction;
    return isNegative ? -value : value;
}

static inline int8_t FixPoint_getInteger(fixPoint_t value){
    return (int8_t)(value >> FIX_POINT_FRACTION_BITS);
}

static inline uint8_t FixPoint_getFraction(fixPoint_t value){
    if (value < 0){
        value = -value;
    }
    return (uint8_t)(value & 0xFF);
}

#endif
