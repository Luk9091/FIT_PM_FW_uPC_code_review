#include "usart.h"

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdlib.h>


#include "circularBuffer.h"
#include "pinout.h"

#define TX_BUFFER_SIZE 64
#define RX_BUFFER_SIZE 64

static char TX_buffer[TX_BUFFER_SIZE];
static char RX_buffer[RX_BUFFER_SIZE];

typedef struct {
    CircularBuffer_t TX;
    CircularBuffer_t RX;
} USART_BUFFER_t;

static USART_BUFFER_t buffers = {
    .TX = {0, 0, TX_BUFFER_SIZE, TX_buffer, 0},
    .RX = {0, 0, RX_BUFFER_SIZE, RX_buffer, 0},
};

volatile static bool usart_isAbleToTransmit = 1; // FIX: Default to true; assume the PC is ready to receive data right after reset.


// --------------------------------------------------
//                  Transmit
// --------------------------------------------------

ISR(USARTF0_DRE_vect) {
    if (usart_isAbleToTransmit == 0 || CircularBuffer_isEmpty(&buffers.TX)){
        usart_txd_irq_enable(false);
        return;
    }

    char c;
    CircularBuffer_pop(&buffers.TX, &c);
    USARTF0.DATA = c;
}

ISR(PORTF_INT0_vect){
    if ((PORTF.IN & MCU_CONSOLE_CTS_bm) == 0){
        usart_isAbleToTransmit = 0;
        return;
    }

    char c;
    if (CircularBuffer_pop(&buffers.TX, &c) == 0){
        if(USARTF0.STATUS & USART_DREIF_bm){
            USARTF0.DATA = c;
        }
        usart_txd_irq_enable(true);
    }
    usart_isAbleToTransmit = 1;
}

inline static void cli_send_char(char c){
    while((USARTF0.STATUS & USART_DREIF_bm) == 0);
    USARTF0.DATA = c;
#ifdef DEBUG
    _delay_ms(10);
#endif
}

static void cli_send_buffer(char c){
    while(CircularBuffer_isFull(&buffers.TX)){
        _delay_us(1);
    };
    cli();
    volatile bool status = USARTF0.STATUS & USART_DREIF_bm;
    if (
        CircularBuffer_isEmpty(&buffers.TX)
        && usart_isAbleToTransmit
        && status
    ){
        USARTF0.DATA = c;
    } else {
        CircularBuffer_push(&buffers.TX, c);
        usart_txd_irq_enable(true);
    }
    sei();
}

void cli_send_msg(const char *msg){
    while(*msg){
        cli_send_buffer(*msg++);
    }
}

void cli_send_hex_digit(uint8_t value){
    value = value & 0x0F;
    if (value > 9){
        value += 'A' - 10;
    } else {
        value += '0';
    }
    cli_send_buffer(value);
}

void cli_send_hex_16bits(uint16_t value){
    for (int i = 4; i --> 0;){
        cli_send_hex_digit(value >> 4 * i);
    }
}

void cli_send_msg_blocking(const char *msg){
    while(*msg){
        cli_send_char(*msg++);
    }
}

void cli_send_number_blocking(int8_t value){
    char tmp[16];

    itoa(value, tmp, 10);
    uint8_t i = 0;
    while(tmp[i]){
        cli_send_char(tmp[i]);
        i++;
    }
}


// --------------------------------------------------
//                  Receive
// --------------------------------------------------
ISR(USARTF0_RXC_vect){
    char c = USARTF0.DATA;
    CircularBuffer_push(&buffers.RX, c);

    if (CircularBuffer_isFull(&buffers.RX)){
        usart_readyToReceive(false);
    }
}

char cli_get_next_byte(){
    char c;
    while(1){
        cli();
        if (CircularBuffer_pop(&buffers.RX, &c))
            break;
        sei();
    }
    if (
        !usart_isReadyToReceive()
        && CircularBuffer_getCapaticy(&buffers.RX) < 20
    ){
        usart_readyToReceive(true);
    }
    return c;
}

char cli_get_next_char(){
    char c = cli_get_next_byte();
    if (c >= 'a' && c <= 'z'){
        c = c - 'a' + 'A';
    }
    return c;
}
