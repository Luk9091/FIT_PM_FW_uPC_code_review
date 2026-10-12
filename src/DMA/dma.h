#ifndef __DMA_H__
#define __DMA_H__

#include <avr/io.h>

uint8_t DMA_CH1_buffor[8]; // I dont know what exactly this is.
                        // Suppose this is data buffer

static inline void DMA_reset(){
    DMA.CTRL = DMA_RESET_bm;
    while(DMA.CTRL & DMA_RESET_bm);
}

static inline void system_init_dma_config(){
    DMA_reset();
    DMA.CTRL = DMA_ENABLE_bm | DMA_PRIMODE_CH0123_gc;

    DMA.CH0.TRIGSRC = DMA_CH_TRIGSRC_SPID_gc;
    const uintptr_t CH0_address = (uintptr_t)&SPID.DATA;
    DMA.CH0.DESTADDR0 = (uint8_t)(CH0_address >>  0);
    DMA.CH0.DESTADDR1 = (uint8_t)(CH0_address >>  8);
    DMA.CH0.DESTADDR2 = (uint8_t)(0);
    DMA.CH0.ADDRCTRL = DMA_CH_SRCRELOAD_BLOCK_gc | DMA_CH_SRCDIR_INC_gc;

    DMA.CH1.TRIGSRC = DMA_CH_TRIGSRC_SPID_gc;
    const uintptr_t CH1_address = (uintptr_t)&(DMA_CH1_buffor[0]);
    DMA.CH1.DESTADDR0 = (uint8_t)(CH1_address >>  0);
    DMA.CH1.DESTADDR1 = (uint8_t)(CH1_address >>  8);
    DMA.CH1.DESTADDR2 = (uint8_t)(0);

    DMA.CH1.SRCADDR0 = (uint8_t)(CH0_address >>  0);
    DMA.CH1.SRCADDR1 = (uint8_t)(CH0_address >>  8);
    DMA.CH1.SRCADDR2 = (uint8_t)(0);

    DMA.CH1.REPCNT = 0;
    DMA.CH1.TRFCNT = 8;
    DMA.CH1.ADDRCTRL = DMA_CH_DESTRELOAD_BLOCK_gc | DMA_CH_DESTDIR_INC_gc;

    DMA.CH1.CTRLA = DMA_CH_ENABLE_bm | DMA_CH_REPEAT_bm | DMA_CH_SINGLE_bm;
    DMA.CH1.CTRLB = DMA_CH_TRNINTLVL_LO_gc;
}


#endif
