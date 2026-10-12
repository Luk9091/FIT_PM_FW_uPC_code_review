#include "fixPoint.h"


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
