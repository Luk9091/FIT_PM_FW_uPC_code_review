#ifndef __FPGA_COMMUNICATION_TIMESPAMP_H__
#define __FPGA_COMMUNICATION_TIMESPAMP_H__

#include <stdint.h>

// Time     Bits     Range  ;
// second    0..5    0 .. 59;
// minute    6..11   0 .. 59;
//   hour   12..16   0 .. 23;
//   year   17..22   0 .. 63;
// month    23..26   1 .. 12;
//   day    27..31   1 .. 31;
typedef uint32_t timestamp_t;

// static const inline timestamp_t TIMESTAMP_convert(
//     uint8_t year, uint8_t month,  uint8_t day,
//     uint8_t hour, uint8_t minute, uint8_t second
// ) {
//     timestamp_t timestamp =
//         (timestamp_t)(second % 60) << 0  |
//         (timestamp_t)(minute % 60) << 6  |
//         (timestamp_t)(hour   % 24) << 12 |
//         (timestamp_t)(year   % 64) << 17 |
//         (timestamp_t)(month  % 13) << 23 |
//         (timestamp_t)(day    % 32) << 27 ;
//     return timestamp;
// }

#define TIMESTAMP_CONVERT( \
    YEAR, MONTH,DAY, \
    HOUR, MINUTE, SECOND \
) ( \
    (timestamp_t)(SECOND % 60) << 0  | \
    (timestamp_t)(MINUTE % 60) << 6  | \
    (timestamp_t)(HOUR   % 24) << 12 | \
    (timestamp_t)(YEAR   % 64) << 17 | \
    (timestamp_t)(MONTH  % 13) << 23 | \
    (timestamp_t)(DAY    % 32) << 27   \
)

#endif
