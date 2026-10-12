#ifndef __CONFIG_H__
#define __CONFIG_H__

#include <avr/io.h>
#include <stdbool.h>

#define POWER_PORT              PORTE
#define POWER_OK_PIN_bm         (1 << 1)
#define POWER_ENABLE_PIN_bm     (1 << 2)
#define POWER_1V2LDO_PG_PIN_bm  (1 << 3)

#define ADC_PLL_POWER_DOWN_PORT     (PORTC)
#define ADC_PLL_POWER_DOWN_PIN_bm   (1 << 3)

#define CPLD_EVENT_IN_PORT          (PORTC)
#define CPLD_EVENT_IN_PIN_bm        (1 << 4)

void system_clock_config();
void system_gpio_config();
void system_usart_config();
void system_timer_0_config();
void system_eeprom_config();
void system_dma_config();
void system_interrupt_config();
void system_init();

static inline bool system_isPowerOk(){
    return POWER_PORT.IN & POWER_OK_PIN_bm;
}
static inline bool system_is1V2LDO_ok(){
    return POWER_PORT.IN & POWER_1V2LDO_PG_PIN_bm;
}

static inline void system_powerEnable(bool enable){
    if (enable) {
        POWER_PORT.OUTSET = POWER_ENABLE_PIN_bm;
    } else {
        POWER_PORT.OUTCLR = POWER_ENABLE_PIN_bm;
    }
}

static inline void ADC_PLL_powerDown(bool powerDown){
    if (powerDown){
        ADC_PLL_POWER_DOWN_PORT.OUTCLR = ADC_PLL_POWER_DOWN_PIN_bm;
    } else {
        ADC_PLL_POWER_DOWN_PORT.OUTSET = ADC_PLL_POWER_DOWN_PIN_bm;
    }
}

static inline void CPLD_eventIn(bool active){
    if (active){
        CPLD_EVENT_IN_PORT.OUTSET = CPLD_EVENT_IN_PIN_bm;
    } else {
        CPLD_EVENT_IN_PORT.OUTCLR = CPLD_EVENT_IN_PIN_bm;
    }
}

void system_init();

#endif
