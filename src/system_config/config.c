#include "config.h"
#include "pinout.h"

#include <avr/io.h>
#include <avr/xmega.h>
#include <avr/eeprom.h>

#include "clksys_driver.h"
// #include "usart_driver.h"
#include "usart.h"

// #define F_CPU 32000000UL
#define BSEL    131
#define BSCALE   -3

void system_clock_config(){
    CLKSYS_XOSC_Config(OSC_FRQRANGE_12TO16_gc, false, OSC_XOSCSEL_XTAL_16KCLK_gc);
    CLKSYS_Enable(OSC_RC2MEN_bm | OSC_XOSCEN_bm);
    while (!CLKSYS_IsReady(OSC_XOSCRDY_bm));

    CLKSYS_PLL_Config(OSC_PLLSRC_XOSC_gc, 2);
    CLKSYS_Enable(OSC_PLLEN_bm);
    while (!CLKSYS_IsReady(OSC_PLLRDY_bm));

    CPU_CCP = CCP_IOREG_gc;
    CLK_CTRL = CLK_SCLKSEL_PLL_gc;
    CLKSYS_Disable(OSC_RC2MEN_bm);
}


static inline void system_port_a_config(){
    PORTA_DIRSET = (0b1111 << 4) | (0b1011);
    PORTA_OUTSET = (0b1111 << 4) | (0b0011);

    PORTA_PIN2CTRL = PORT_OPC_PULLUP_gc;

    PORTA_PIN1CTRL = PORT_SRLEN_bm;
    PORTA_PIN3CTRL = PORT_SRLEN_bm;
    PORTA_PIN4CTRL = PORT_SRLEN_bm;
}

static inline void system_port_b_config(){
    PORTB_PIN2CTRL = PORT_ISC_FALLING_gc;

    PORTB_INT0MASK = 0x40;
}

static inline void system_port_c_config(){
    PORTC_PIN3CTRL = PORT_SRLEN_bm;
    PORTC_PIN4CTRL = PORT_OPC_WIREDORPULL_gc;
}

static inline void system_port_d_config(){
    PORTD_PIN1CTRL = PORT_OPC_WIREDAND_gc;
    PORTD_PIN2CTRL = PORT_OPC_WIREDAND_gc;

    PORTD_OUTCLR = 0x04;
    PORTD_OUTSET = 0x02;
    PORTD_DIRSET = 0x06;

    PORTD_INT0MASK = 0x08;
}

static inline void system_port_e_config(){
    PORTE_DIRSET = 0x04;

    PORTE_PIN0CTRL = PORT_ISC_RISING_gc;
    PORTE_PIN2CTRL = PORT_SRLEN_bm;

    PORTE_INT0MASK = 0x0A;
    PORTE_INT1MASK = 0x01;
}

static inline void system_port_f_config(){
    PORTF_DIRSET = 0x09;
    PORTF_PIN7CTRL = PORT_OPC_PULLDOWN_gc;

    PORTF_INT0MASK = MCU_CONSOLE_CTS_bm;
    PORTF_INT1MASK = 0x40;
}

void system_gpio_config(){
    system_port_a_config();
    system_port_b_config();
    system_port_c_config();
    system_port_d_config();
    system_port_e_config();
    system_port_f_config();
    return;
}

void system_usart_config(){
    usart_ready_to_receive(false);

    PORTF.DIRSET = USART_RTS_PIN_bm | USART_TXD_PIN_bm;
    USARTF0.CTRLC =
        USART_CMODE_ASYNCHRONOUS_gc |
        USART_PMODE_DISABLED_gc     |
        USART_CHSIZE_8BIT_gc;

    USARTF0.BAUDCTRLB = 0xD0;
    USARTF0.BAUDCTRLA = 0x83;
    // USART_Baudrate_Set(&USARTF0, 131, -3); // set baudrate: 115200

    USARTF0.CTRLB = USART_RXEN_bm | USART_TXEN_bm;
    USARTF0.CTRLA = USART_RXCINTLVL_MED_gc;
    usart_txd_irq_enable(false);
}

const static inline uint16_t freq_to_timer_top(const uint16_t freq_hz, const uint16_t PRESCALER){
    return F_CPU/(freq_hz * PRESCALER);
}

void system_timer_0_config() {
    TCC0_CTRLA      = TC_CLKSEL_DIV256_gc;
    TCC0_PER        = freq_to_timer_top(1e3, 256);
    TCC0_CTRLB      = TC_WGMODE_NORMAL_gc;
    TCC0_CTRLE      = TC_BYTEM_NORMAL_gc;
    TCC0_INTCTRLA   = TC_OVFINTLVL_LO_gc;
}

void system_eeprom_config(){
    NVM_CTRLB = NVM_EEMAPEN_bm; // Enable EEPROM
}
