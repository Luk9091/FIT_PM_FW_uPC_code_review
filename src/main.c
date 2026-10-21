#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "leds.h"
#include "config.h"
#include "usart.h"
#include "fixPoint.h"
#include "adt7311.h"
#include "cdce62005.h"
#include "errorCodes.h"
#include "dac.h"
#include "timer.h"


int main(){
    // while(1);
    system_clock_config();
    system_gpio_config();
    system_usart_config();
    // Timer 0 config
    // EEPROM controller
    usart_set_allowToTransmit(usart_isAllowToTransmit());

    // check power
    system_interrupt_config();
    ADT7311_faults_clear();
    // adt7311_8bits_write(ADT7311_CONFIG_REG_ADDR, 0x50);
    adt7311_8bits_write(ADT7311_CONFIG_REG_ADDR, ADT7311_CONFIG_REG_MODE_SPS | ADT7311_CONFIG_REG_COMPARATOR_MODE);
    adt7311_16bits_write(ADT7311_T_CRIT_SETPOINT_REG_ADDR, adt7311_celsiusToThreshold(50)); // by default: 70
    adt7311_16bits_write(ADT7311_T_HIGH_SETPOINT_REG_ADDR, adt7311_celsiusToThreshold(40)); // by default: 60
    // adt7311_16bits_write(ADT7311_T_HYST_SETPOINT_REG_ADDR, adt7311_celsiusToThreshold(0)); // by default: 5 NOTE: This value is set by default after restart
    // EEPROM read

    cli_send_msg("\033c");
    system_init();
    do {
        cli_send_msg("Try run PLL\r\n");
        system_powerEnable(false);
        _delay_ms(10);
        system_powerEnable(true);
        _delay_ms(100);
        CDCE62005_sync(true);

        CDCE62005_control_reset();
        sei();
    } while(!CDCE62005_getLockTimeout(250));
    // CDCE62005_send_control_settings(0x40040FF5);
    // CDCE62005_sync(true);
    cli_send_msg("Successful LOCK\r\n");

    while(1){
        LED_toggle(LED_SYSTEM_FAIL);
        _delay_ms(250);
    }

    return 0;
}
