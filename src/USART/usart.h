#ifndef __MY_USART_H__
#define __MY_USART_H__

#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <stdbool.h>

#define USART_PORT          PORTF
#define USART_RTS_PIN_bm    (1 << 0)
#define USART_CTS_PIN_bm    (1 << 1)
#define USART_RXD_PIN_bm    (1 << 2)
#define USART_TXD_PIN_bm    (1 << 3)


#define DRE_REQUEST_IRQ_LEVEL USART_DREINTLVL_MED_gc

static inline void usart_ready_to_receive(bool ready) {
    if (ready) {
        USART_PORT.OUTCLR = USART_RTS_PIN_bm;
    } else {
        USART_PORT.OUTSET = USART_RTS_PIN_bm;
    }
}

static inline void usart_txd_irq_enable(bool enable){
    if (enable){
        USARTF0.CTRLA |= DRE_REQUEST_IRQ_LEVEL;
    } else {
        USARTF0.CTRLA &= ~USART_DREINTLVL_gm;
    }
}


void cli_send_msg(const char *msg);
void cli_send_msg_blocking(const char *msg);
void cli_send_number_blocking(int8_t value);

#endif
