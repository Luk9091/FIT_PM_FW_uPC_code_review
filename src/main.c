#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "leds.h"
#include "config.h"
#include "usart.h"


int main(){
    system_clock_config();
    system_gpio_config();
    system_usart_config();

    PMIC.CTRL |= PMIC_MEDLVLEN_bm | PMIC_LOLVLEN_bm;
    sei();

    while(1){
        LED_toggle(LED_SYSTEM_FAIL);
        cli_send_msg("Hello world\n\r");
        _delay_ms(250);
    }
}
