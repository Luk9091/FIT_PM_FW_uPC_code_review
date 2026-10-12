#include <avr/io.h>

#define CPU_Z_bp 1
#define CPU_C_bp 0


.text

.global main
.type main, @function


dac_send_value:
    nop
    ret

DAC_multiply_with_top_limit:
    eor         R17,R17                         ; R17 = 0
    mul         R18,R20                         ; R18 = R18 * R20
    sbrc        R0,0x7                          ; if (!(R0 & 0x07))
    inc         R1                              ;   R1++
    mov         R16,R1                          ; R16 = R1
    mul         R19,R20                         ; R19 = R19 * R20
    add         R16,R0                          ; R16 = R16 + R0
    adc         R17,R1                          ; R17 = R1 + C
    mul         R18,R21                         ; R18 = R18 * R21
    add         R16,R0                          ; R16 + R0
    adc         R17,R1                          ; R17 + R1 + C
    mul         R19,R21                         ; R19 = R19 * R21
    and         R1,R1                           ;
    brbc        CPU_Z_bp, LAB_code_0010b7       ; if (R1 == 0) {
    add         R17,R0                          ;   if (R17 == 0)
    brbs        CPU_C_bp, LAB_code_0010b7       ;       return
    ret                                         ;
LAB_code_0010b7:                                ; } else {
    ser         R16                             ;   R16 = 0xFF
    ser         R17                             ;   R17 = 0xFF
    ret                                         ; }

DAC_multiplay_signed:                                               //
    eor         R17,R17                         ; R17 = 0                   //
    mul         R18,R20                         ; R18 = R18 * R20           //
    sbrc        R0,0x7                          ; if (!(R0 & 1<<7))         //
    inc         R1                              ;   R1++                    //
    mov         R16,R1                          ; R16 = R1                  //
    mul         R19,R20                         ; R19 = R19 * R20           //
    add         R16,R0                          ; R16 = R16 + R0            //
    adc         R17,R1                          ; R17 = R1 + C              //
    mulsu       R21,R18                         ; R21 = R21 * unsigned(R18) //
    add         R16,R0                          ; R16 = R16 + R0            //
    adc         R17,R1                          ; R17 = R17 + R1 + C        //
    mulsu       R21,R19                         ; R21 = R21 * unsigned(R19) //
    add         R17,R0                          ; R17 = R17 + R0            //
    ret


DAC_set_value_CFD_threshold:
    push        R18
    ldi         R18,0x0C                        ; decimal value / 256
    ldi         R19,0x02                        ; integer
    rcall       DAC_multiply_with_top_limit                         ;undefined FUN_code_0010a6(undefined2...
    ; ldi         ZL,0x63
    ; ldi         ZH,0x21
    eor         R20,R20
    add         R22,R22
    ; add         ZL,R22
    ; adc         ZH,R20                          ; DAC_threshold_offset[DAC_index]
    add         R22,R22
    ori         R22,0x3
    ldi         R20,0
    ldi         R21,0
    add         R16,R20                         ; add DAC_threshold_offset[DAC_index]
    adc         R17,R21
    com         R16                             ; negative value
    com         R17
    rcall       dac_send_value                  ; undefined3 FUN_code_001155(undefined...
    pop         R18
    ret

DAC_set_value_ADC_delay:
    push        R18
    ldi         R18,lo8(20000)
    ldi         R19,hi8(20000)                          ; R19:R18 = 20 000
    sub         R18,R20                                 ;
    sbc         R19,R21                                 ;
    movw        R20,R18                                 ; x = 20 000 - x
    ldi         R18,0x72                                ; decimal value / 256
    ldi         R19,0x02                                ; integer value
    rcall       DAC_multiply_with_top_limit             ;undefined FUN_code_0010a6(undefined2...
    add         R22,R22                                 ;
    add         R22,R22                                 ;
    rcall       dac_send_value                          ;undefined3 FUN_code_001155(undefined...
    pop         R18
    ret

DAC_set_value_CFD_zero:
    push        R18
    ldi         R18,0x88                                ; decimal value / 256
    ldi         R19,0x41                                ; integer value
    rcall       DAC_multiplay_signed                    ;undefined FUN_code_001098(void)
    ldi         R18,0x80
    eor         R17,R18
    add         R22,R22
    add         R22,R22
    ori         R22,0x2
    rcall       dac_send_value                          ;undefined3 FUN_code_001155(undefined...
    pop         R18
    ret

DAC_set_value_ADC_zero:
    push        R18
    ldi         R18,0x88                                ; decimal value / 256
    ldi         R19,0x41                                ; integer value
    rcall       DAC_multiplay_signed                    ;undefined FUN_code_001098(void)
    ; ldi         R18,0x80
    ; eor         R17,R18
    ; add         R22,R22
    ; add         R22,R22
    ; ori         R22,0x1
    rcall       dac_send_value                          ;undefined3 FUN_code_001155(undefined...
    pop         R18
    ret




main:
    ldi r16, hi8(RAMEND)
    out _SFR_IO_ADDR(SPH), r16
    ldi r16, lo8(RAMEND)
    out _SFR_IO_ADDR(SPL), r16

    ldi     R22, 0
    ldi     R27, 0
    ldi     R28, 0
    ldi     R29, 1
    ldi     R30, 0

cfd_threshold_loop:
    mov     R20, R27
    mov     R21, R28
    ; call    DAC_set_value_CFD_threshold
    ; call    DAC_set_value_ADC_delay
    call DAC_set_value_ADC_zero
    add     R27, R29
    adc     R28, R30
    brbc    0,cfd_threshold_loop

exit:
    rjmp exit
