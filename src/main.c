#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "leds.h"
#include "config.h"
#include "usart.h"
#include "fixPoint.h"


int main(){
    system_clock_config();
    system_gpio_config();
    system_usart_config();

    // check power
    system_interrupt_config();
    sei();


    while(1){
        // uint16_t hexValue;
        // if (cli_get_hex(&hexValue)){
        //     cli_send_msg("Successful read: ");
        //     cli_send_hex_16bits(hexValue);
        // } else {
        //     cli_send_msg("Invalid value!");
        // }

        int16_t value;
        if (cli_get_integer(&value)){
            cli_send_msg("Successful read: ");
            cli_send_int16(value);
            cli_send_msg(" | ");
            cli_send_uint16(value);
        } else {
            cli_send_msg("Invalid value!");
        }
        cli_send_newLine();
        LED_toggle(LED_SYSTEM_FAIL);
        _delay_ms(250);
    }

    return 0;
}
