#ifndef __CIRCULAR_BUFFER_H__
#define __CIRCULAR_BUFFER_H__

#include <stdint.h>
#include <stdbool.h>

typedef struct{
    uint8_t head;
    uint8_t tail;
    const uint8_t size;
    char * const data;
} CircularBuffer_t;

static inline bool CircularBuffer_isFull(CircularBuffer_t *buffer){
    return (buffer->head + 1) % buffer->size == buffer->tail;
}
static inline bool CircularBuffer_isEmpty(CircularBuffer_t *buffer){
    return buffer->head == buffer->tail;
}

static inline int CircularBuffer_push(CircularBuffer_t *buffer, char c){
    if (CircularBuffer_isFull(buffer)) return -1;

    buffer->data[buffer->head] = c;
    buffer->head = (buffer->head + 1) % buffer->size;
    return 0;
}

static inline int CircularBuffer_pop(CircularBuffer_t *buffer, char * c){
    if (CircularBuffer_isEmpty(buffer)){
        return -1;
    }

    *c = buffer->data[buffer->tail];
    buffer->tail = (buffer->tail + 1) % buffer->size;
    return 0;
}



#endif
