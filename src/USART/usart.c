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

inline static void usart_send_char(char c){
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

void cli_send_newLine(){
    cli_send_buffer('\r');
    cli_send_buffer('\n');
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

void cli_send_int16(int16_t value){
    char buffer[7]; // MAX: 65 535
    itoa(value, buffer, 10);
    cli_send_msg(buffer);
}

void cli_send_uint16(uint16_t value){
    char buffer[7]; // MAX: 65 535
    utoa(value, buffer, 10);
    cli_send_msg(buffer);
}

void cli_send_number(fixPoint_t value, const uint8_t round){
    int8_t integer = FixPoint_getInteger(value);
    uint16_t rawFraction = FixPoint_getFraction(value);
    bool signedValue = integer < 0;
    if (signedValue){
        integer = integer + 1;
    }

    char integerBuffer[5];
    char fractionBuffer[round + 1];
    if (signedValue && integer == 0){
        integerBuffer[0] = '-';
        integerBuffer[1] = '0';
        integerBuffer[2] = '\0';
    } else {
        itoa(integer, integerBuffer, 10);
    }

    uint8_t i = 0;
    for (i = 0; i < round; i++){
        rawFraction = rawFraction * 10;
        uint8_t digit = (rawFraction / 256);
        fractionBuffer[i] = '0' + digit;
        rawFraction &= 0x00FF;
    }
    fractionBuffer[i] = '\0';

    cli_send_msg(integerBuffer);
    cli_send_buffer('.');
    cli_send_msg(fractionBuffer);
}

// Blocking send
void cli_send_msg_blocking(const char *msg){
    while(*msg){
        usart_send_char(*msg++);
    }
}

void cli_send_number_blocking(int8_t value){
    char tmp[16];

    itoa(value, tmp, 10);
    uint8_t i = 0;
    while(tmp[i]){
        usart_send_char(tmp[i]);
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

bool cli_get_hex(uint16_t *value){
    for (uint8_t i = 0; i < 4; i++){
        char c = cli_get_next_char();
        if (c >= '0' && c <= '9'){
            *value = (*value << 4) | (c - '0');
        } else if (c >= 'A' && c <= 'F'){
            *value = (*value << 4) | (c - 'A' + 10);
        } else {
            return false;
        }
    }

    return true;
}

bool cli_get_integer(int16_t *value){
    bool isNegativ = false;
    uint8_t counter = 0;
    *value = 0;
    while(true){
        char c = cli_get_next_char();
        if (counter == 0 && c == '-'){
            isNegativ = true;
        } else if (c >= '0' && c <= '9') {
            *value = *value*10 + (c - '0');
        } else {
            break;
        }
        counter++;
    }
    if (isNegativ){
        *value = -(*value);
    }

    if (counter < 1) return false;
    if (isNegativ && counter < 2) return false;
    return true;
}
