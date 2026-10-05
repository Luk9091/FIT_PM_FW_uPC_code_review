#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "leds.h"
#include "config.h"
#include "usart.h"
#include "fixPoint.h"
#include "adt7311.h"
#include "cdce62005.h"


int main(){
    system_clock_config();
    system_gpio_config();
    system_usart_config();


    // check power
    system_interrupt_config();
    ADT7311_faults_clear();
    // adt7311_8bits_write(ADT7311_CONFIG_REG_ADDR, 0x50);
    adt7311_8bits_write(ADT7311_CONFIG_REG_ADDR, ADT7311_CONFIG_REG_MODE_SPS | ADT7311_CONFIG_REG_COMPARATOR_MODE);
    adt7311_16bits_write(ADT7311_T_CRIT_SETPOINT_REG_ADDR, adt7311_celsiusToThreshold(70)); // by default: 70
    adt7311_16bits_write(ADT7311_T_HIGH_SETPOINT_REG_ADDR, adt7311_celsiusToThreshold(60)); // by default: 60
    // adt7311_16bits_write(ADT7311_T_HYST_SETPOINT_REG_ADDR, adt7311_celsiusToThreshold(0)); // by default: 5 NOTE: This value is set by default after restart
    // EEPROM read
    sei();


    // Tests
    uint8_t adt7311_status = adt7311_8bits_read(0x00);
    cli_send_msg("Read data from ADT7311: 0x");
    cli_send_hex_16bits(adt7311_status);
    cli_send_newLine();

    uint8_t adt7311_ID = adt7311_8bits_read(0x03);
    cli_send_msg("ID ADT7311: 0x");
    cli_send_hex_16bits(adt7311_ID);
    cli_send_newLine();

    uint16_t high_temp = adt7311_16bits_read(0x06);
    cli_send_msg("High temperature limit: ");
    cli_send_uint16(high_temp);
    cli_send_newLine();
    uint16_t crit_temp = adt7311_16bits_read(0x04);
    cli_send_msg("Critical temperature limit: ");
    cli_send_uint16(crit_temp);
    cli_send_newLine();

    bool belowLow;
    bool aboveHigh;
    bool aboveCrit;

    while(1){
        uFixPoint_t temperature = adt7311_read_temperatureWithFlags(&belowLow, &aboveHigh, &aboveCrit);
        // uFixPoint_t temperature = adt7311_read_16bits_temperature();
        cli_send_msg("Temperature: ");
        cli_send_unumber(temperature, 4);
        // cli_send_number(temperature, 4);
        cli_send_msg("C | ");
        cli_send_hex_16bits(temperature);
        if (belowLow){
            cli_send_msg(" | LOW");
        }
        if (aboveHigh) {
            cli_send_msg(" | HIGH");
        }
        if (aboveHigh & aboveCrit) {
            cli_send_msg(" | CRIT");
        }
        cli_send_newLine();

        LED_toggle(LED_SYSTEM_FAIL);
        _delay_ms(250);
    }

    return 0;
}
