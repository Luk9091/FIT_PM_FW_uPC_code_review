#ifndef __LEDS_H__
#define __LEDS_H__

#include <avr/io.h>
#include <stdbool.h>

#define LED_PORT                PORTA

#define LED_SYSTEM_FAIL_bp      0
#define LED_CLK_IN_PIN_bp       5
#define LED_CLK_ERROR_PIN_bp    6
#define LED_MODUL_READY_PIN_bp  7

#define LED_SYSTEM_FAIL_bm      (1 << LED_SYSTEM_FAIL_bp)
#define LED_CLK_IN_PIN_bm       (1 << LED_CLK_IN_PIN_bp)
#define LED_CLK_ERROR_PIN_bm    (1 << LED_CLK_ERROR_PIN_bp)
#define LED_MODUL_READY_PIN_bm  (1 << LED_MODUL_READY_PIN_bp)

typedef enum LEDs{
    LED_SYSTEM_FAIL = LED_SYSTEM_FAIL_bp,
    LED_CLK_IN = LED_CLK_IN_PIN_bp,
    LED_CLK_ERROR = LED_CLK_ERROR_PIN_bp,
    LED_MODUL_READY = LED_MODUL_READY_PIN_bp
} LEDs_t;

static inline void LED_put(LEDs_t led, bool state){
    if (state){
        LED_PORT.OUTCLR = 1 << led;
    } else {
        LED_PORT.OUTSET = 1 << led;
    }
}


#endif
