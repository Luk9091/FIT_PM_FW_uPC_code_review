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

    // check power
    system_interrupt_config();
    sei();

    while(1){
        LED_toggle(LED_SYSTEM_FAIL);
        cli_send_msg("Hello world\n\r");

        char c = cli_get_next_char();
        char str[] = {c, '\n', '\r', 0};
        cli_send_msg("Recv char: ");
        cli_send_msg(str);
    }

    return 0;
}
