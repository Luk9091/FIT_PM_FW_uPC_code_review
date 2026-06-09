#include "ATxmega128A3Udef.inc"

#define UPDATE_ERROR_STATUS_REGISTER        GPIO_GPIOR0
#define UPDATE_CODE_SYS_FAIL                1 << 0
#define UPDATE_CODE_CLK                     1 << 1
#define UPDATE_CODE_UNNOWN_1                1 << 2  // unknown error code
#define UPDATE_CODE_UNNOWN_2                1 << 3  // unknown error code

#define SERIAL_RECV_MSG_LEN 0x2005
#define FPGA_COMMUNICATION_FLAG 0x2006 // WIPLAB_code_001449

#define SEND_MESSAGE_SIZE   0x2003
#define SEND_BUFFER_SIZE    0x2004
; *SEND_BUFFER_SIZE = 63
#define SEND_CURRENT_CHAR_INDEX   0x2002
; char SEND_buffer[SEND_BUFFER_SIZE]; // First address 0x2047

#define RECV_BUFFER_SIZE 63
; char RECV_buffer[RECV_BUFFER_SIZE] = *0x2007
; uint8_t RECV_CURRENT_CHAR_INDEX = *(0x2001)
; uint8_t RECV_MESSAGE_SIZE = *(0x2000)

#define POWER_NOK_bm        0x2157

; // Parameters:  Threshold, Shift, Zero offs, Delay
; float CHANNEL_PARAMETERS[CHANNEL_NUMBER][PARAMETER_NUMBER];
; float CHANNEL_PARAMETERS = *(0x2A68)

#define TRIGGER_WINDOW      0x222f
#define CFD_SAT_LVL_LOW     0x2230
#define CFD_SAT_LVL_HIGH    0x2231

.section .text

;************************************************************************************************
;*                                       INTERRUPT VECTOR                                       *
;************************************************************************************************

.org 0x0000
    rjmp main                               ; 0 RESET

.org (DMA_CH1_vect << 1)
    rjmp     DMA_CH1_vect_isr               ; 7 Channel 1 Interrupt

.org (TCC0_OVF_vect << 1)
    rjmp    TCC0_OVF_vect_isr               ; 14 Overflow Interrupt

.org (PORTB_INT0_vect << 1)
    rjmp     PORTB_INT0_vect_isr            ; 34 PORTB External Interrupt 0

.org (PORTE_INT0_vect << 1)
    rjmp     PORTE_INT0_vect_isr            ; 43 PORTE External Interrupt 0

.org (PORTE_INT1_vect << 1)
    rjmp     PORTE_INT1_vect_isr            ; 44 PORTE External Interrupt 1

.org (PORTD_INT0_vect << 1)
    rjmp     PORTD_INT0_vect_isr            ; 64 PORTD External Interrupt 0

.org (PORTF_INT0_vect << 1)
    rjmp    PORTF_INT0_vect_isr             ; 104 PORTF External Interrupt 0

.org (PORTF_INT1_vect << 1)
    rjmp     PORTF_INT1_vect_isr            ; 105 PORTF External Interrupt 1

.org (USARTF0_RXC_vect << 1)
    rjmp    USARTF0_RXC_vect_isr            ; 119 USARTF0_DATA Reception Complete Interrupt

.org (USARTF0_DRE_vect << 1)
    rjmp    USARTF0_DRE_vect_isr            ; 120 USARTF0_DATA Data Register Empty Interrupt



;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined4 FUN_code_0000f1()
.org (0x00f1 << 1)
DMA_CH1_vect_isr:
    push        ZH
    in          ZH,CPU_SREG
    push        R16
    push        R17
    push        R18
    push        YL
    push        YH
    push        ZL
    push        ZH
    ldi         R17,0xa
LAB_code_0000fb:
    lds         R16,PORTD_IN                    ;= ??
    sbrc        R16,0x4
    rjmp        LAB_code_000101
    dec         R17
    brbc        CPU_Z_bp, LAB_code_0000fb
LAB_code_000101:
    lds         R17,DMA_CH1_TRFCNT              ;= ??
    ldi         R16,0x11
    sts         DMA_CH1_CTRLB,R16               ;= ??
    ldi         ZL,0x76
    ldi         ZH,0x2b
    ldi         YL,0x39
    ldi         YH,0x24
    ldi         R16,0x8
    sub         R16,R17
    eor         R17,R17
    add         YL,R16
    adc         YH,R17
    ld          R16,Y+
    cpi         R16,0xaa
    brbs        CPU_Z_bp, LAB_code_000116
LAB_code_000112:
    lpm         R17,Z+
    cp          R16,R17
    brbs        CPU_Z_bp, LAB_code_000130
    rjmp        LAB_code_00022c
LAB_code_000116:
    cpi         R17,0x7
    brbs        CPU_Z_bp, LAB_code_000120
    inc         R17
    cpi         YL,0x41
    brbc        CPU_Z_bp, LAB_code_00011c
    sbiw        Y,0x8
LAB_code_00011c:
    ld          R16,Y+
    cpi         R16,0xaa
    brbs        CPU_Z_bp, LAB_code_000116
    rjmp        LAB_code_00022c
LAB_code_000120:
    cli
    rcall       FUN_code_0005b4                         ;undefined FUN_code_0005b4(void)
    bset        CPU_I_bp
    ldi         R16,0x3
    sts         0x2441,R16                   ;= ??
    pop         ZH
    pop         ZL
    pop         YH
    pop         YL
    pop         R18
    pop         R17
    pop         R16
    out         CPU_SREG,ZH
    pop         ZH
    rjmp        PORTF_INT1_vect_isr                         ;undefined FUN_code_000570(void)
LAB_code_000130:
    cpi         YL,0x41
    brbc        CPU_Z_bp, LAB_code_000133
    sbiw        Y,0x8
LAB_code_000133:
    ld          R16,Y+
    cpi         ZL,0x7e
    brbc        CPU_Z_bp, LAB_code_000112
    eor         R16,R16
    sts         DMA_CH1_CTRLA,R16               ;= ??
    bset        CPU_I_bp
    push        R0
    push        R1
    push        R2
    push        R10
    push        R19
    push        R20
    push        R21
    push        R22
    push        R23
    push        R24
    push        R25
    push        XL
    push        XH
    call        take_control_over_flash_chip                        ;undefined FUN_code_000b32(void)
    call        flash_chip_get_RDID                         ;undefined FUN_code_000c20(void)
    ldi         YL,0x39
    ldi         YH,0x24
    sts         DMA_CH0_SRCADDR0,YL            ;= ??
    sts         DMA_CH0_SRCADDR1,YH            ;= ??
    eor         R20,R20
    sts         DMA_CH0_SRCADDR2,R20            ;= ??
    st          Y+,R18
    st          Y+,R19
    st          Y+,R16
    st          Y,R20
    ldi         R16,0x4
    sts         DMA_CH0_TRFCNT,R16              ;= ??
    eor         R16,R16
    sts         0x0115,R16                ;= ??
    ldi         R16,0x94
    sts         DMA_CH0_CTRLA,R16               ;= ??
LAB_code_000161:
    lds         R16,DMA_CH0_CTRLB               ;= ??
    sbrs        R16,0x4
    rjmp        LAB_code_000161
    ldi         R16,0x10
    sts         DMA_CH0_CTRLB,R16               ;= ??
    ldi         XL,0x39
    ldi         XH,0x24
    sts         DMA_CH1_DESTADDR0,XL           ;= ??
    sts         DMA_CH1_DESTADDR1,XH           ;= ??
    eor         R20,R20
    sts         DMA_CH1_DESTADDR2,R20           ;= ??
    ldi         R16,0x8
    sts         DMA_CH1_TRFCNT,R16              ;= ??
    eor         R16,R16
    sts         0x0125,R16                ;= ??
LAB_code_000177:
    lds         R16,PORTD_IN                    ;= ??
    sbrs        R16,0x4
    rjmp        LAB_code_000177
    lds         R16,SPID_STATUS                 ;= ??
    lds         R16,SPID_DATA                   ;= ??
    ldi         R16,0x84
    sts         DMA_CH1_CTRLA,R16               ;= ??
LAB_code_000182:
    lds         R16,DMA_CH1_CTRLB               ;= ??
    sbrs        R16,0x4
    rjmp        LAB_code_000182
    ldi         R16,0x10
    sts         DMA_CH1_CTRLB,R16               ;= ??
    ld          YL,X+
    ld          YH,X+
    ld          ZL,X+
    adiw        X,0x1
    ld          R0,X+
    ld          R1,X+
    ld          R2,X
    movw        R20,Y
    mov         R22,ZL
    ldi         XL,0x39
    ldi         XH,0x24
    sts         DMA_CH0_SRCADDR0,XL            ;= ??
    sts         DMA_CH0_SRCADDR1,XH            ;= ??
    eor         R16,R16
    st          X+,R16
    st          X+,R16
    st          X+,R16
    st          X,R16
    sts         DMA_CH0_SRCADDR2,R16            ;= ??
    ldi         R16,0x4
    sts         DMA_CH0_TRFCNT,R16              ;= ??
    eor         R16,R16
    sts         0x0115,R16                ;= ??
    sts         DMA_CH0_REPCNT,R16              ;= ??
LAB_code_0001a7:
    lds         R16,PORTD_IN                    ;= ??
    sbrs        R16,0x4
    rjmp        LAB_code_0001a7
    ldi         R16,0xb4
    sts         DMA_CH0_CTRLA,R16               ;= ??
    eor         R16,R16
    ldi         XL,0x35
    ldi         XH,0x24
    st          X+,R16
    st          X+,R16
    st          X+,R16
    st          X,R16
LAB_code_0001b5:
    call        FUN_code_000b88                         ;undefined FUN_code_000b88(void)
LAB_code_0001b7:
    movw        R16,R0
    mov         R18,R2
    sub         R16,R20
    sbc         R17,R21
    sbc         R18,R22
    subi        R16,0xff
    sbci        R17,0xff
    sbci        R18,0xff
    and         R18,R18
    brbc        CPU_Z_bp, LAB_code_0001c7
    ldi         R18,0x1
    cp          R16,R18
    cpc         R17,R18
    brbc        CPU_C_bp, LAB_code_0001c7
    ldi         ZH,0x1
    rjmp        LAB_code_0001ca
LAB_code_0001c7:
    eor         R16,R16
    ldi         R17,0x1
    eor         ZH,ZH
LAB_code_0001ca:
    ldi         XL,0x35
    ldi         XH,0x22
    lds         R18,0x2435                   ;= ??
    add         XH,R18
    ldi         R19,0x1
    eor         R18,R19
    sts         0x2435,R18                   ;= ??
    sts         DMA_CH1_DESTADDR0,XL           ;= ??
    sts         DMA_CH1_DESTADDR1,XH           ;= ??
    eor         R20,R20
    sts         DMA_CH1_DESTADDR2,R20           ;= ??
    sts         DMA_CH1_TRFCNT,R16              ;= ??
    sts         0x0125,R17                ;= ??
    rcall       WAIT_UNTIL_DMA_FINISH_TRANSFER                         ;undefined FUN_code_000236(void)
    ldi         R16,0x84
    sts         DMA_CH1_CTRLA,R16               ;= ??
LAB_code_0001e2:
    lds         R16,DMA_CH1_CTRLB               ;= ??
    sbrs        R16,0x4
    rjmp        LAB_code_0001e2
    ldi         R16,0x10
    sts         DMA_CH1_CTRLB,R16               ;= ??
    and         ZH,ZH
    brbs        CPU_Z_bp, LAB_code_000204
LAB_code_0001eb:
    lds         R18,PORTD_IN                    ;= ??
    sbrs        R18,0x4
    rjmp        LAB_code_0001eb
    eor         R16,R16
    sts         DMA_CH0_CTRLA,R16               ;= ??
    ldi         XL,0x39
    ldi         XH,0x24
    sts         DMA_CH0_SRCADDR0,XL            ;= ??
    sts         DMA_CH0_SRCADDR1,XH            ;= ??
    eor         R16,R16
    sts         DMA_CH0_SRCADDR2,R16            ;= ??
    ldi         R16,0x8
    sts         DMA_CH0_TRFCNT,R16              ;= ??
    eor         R16,R16
    sts         0x0115,R16                ;= ??
    ldi         R16,0xb4
    sts         DMA_CH0_CTRLA,R16               ;= ??
LAB_code_000204:
    call        FUN_code_000b9d                         ;undefined FUN_code_000b9d(void)
    call        FUN_code_000b59                         ;undefined FUN_code_000b59(void)
    brbs        CPU_C_bp, LAB_code_00020f
    and         R21,R21
    brbs        CPU_Z_bp,LAB_code_00020c
    rjmp        LAB_code_0001b7
LAB_code_00020c:
    call        FUN_code_000b9d                         ;undefined FUN_code_000b9d(void)
    rjmp        LAB_code_0001b5
LAB_code_00020f:
    call        FUN_code_000b9d                         ;undefined FUN_code_000b9d(void)
    call        FUN_code_000bb9                         ;undefined FUN_code_000bb9(undefined2...
    ldi         XL,0x3d
    ldi         XH,0x24
    st          X+,R18
    st          X+,R19
    st          X+,R16
    st          X+,R17
    rcall       WAIT_UNTIL_DMA_FINISH_TRANSFER                         ;undefined FUN_code_000236(void)
    eor         R16,R16
    sts         DMA_CTRL,R16                         ;= ??
    call        FUN_code_000b3f                         ;undefined FUN_code_000b3f(void)
    pop         XH
    pop         XL
    pop         R25
    pop         R24
    pop         R23
    pop         R22
    pop         R21
    pop         R20
    pop         R19
    pop         R10
    pop         R2
    pop         R1
    pop         R0
LAB_code_00022c:
    pop         ZH
    pop         ZL
    pop         YH
    pop         YL
    pop         R18
    pop         R17
    pop         R16
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000236(void)
.org (0x0236 << 1)
WAIT_UNTIL_DMA_FINISH_TRANSFER:
    ldi         R16,0x80
    ldi         R17,0x10
WAIT_UNTIL_SELECT_HDMI_SPI:
    bset        CPU_I_bp
    cli
    lds         R18,PORTD_IN                    ; wait unitl select from HDMI SPI
    sbrs        R18,4                           ;
    rjmp        WAIT_UNTIL_SELECT_HDMI_SPI
    sts         0x243c,R16
    sts         DMA_CH0_CTRLB,R17               ; Clear flag to enable dma
    bset        CPU_I_bp
WAIT_FOR_FINISH_DMA_TRANSFER:
    lds         R16,DMA_CH0_CTRLB
    sbrs        R16,0x4
    rjmp        WAIT_FOR_FINISH_DMA_TRANSFER
    eor         R16,R16
    sts         0x243c,R16
WAIT_UNTIL_RELESE_SELECT_HDMI_SPI:
    lds         R18,PORTD_IN
    sbrs        R18,0x4
    rjmp        WAIT_UNTIL_RELESE_SELECT_HDMI_SPI
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;ulonglong FUN_code_00024f()
.org (0x024f << 1)
TCC0_OVF_vect_isr:
    push        ZH
    in          ZH,CPU_SREG
    push        ZH
    push        ZL
    push        YH
    push        YL
    push        R25
    push        R24
    push        R23
    push        R22
    push        R21
    push        R20
    push        R19
    push        R18
    push        R17
    push        R16
    push        R1
    push        R0
    ldi         ZL,0x59
    ldi         ZH,0x21
    ld          R16,Z
    and         R16,R16
    brbc        CPU_Z_bp, LAB_code_000267
    rjmp        LAB_code_00031b
LAB_code_000267:
    dec         R16
    brbc        CPU_Z_bp, LAB_code_00026a
    rjmp        LAB_code_0002d5
LAB_code_00026a:
    dec         R16
    brbs        CPU_Z_bp, LAB_code_0002ab
    dec         R16
    brbs        CPU_Z_bp, LAB_code_000298
    dec         R16
    brbs        CPU_Z_bp, LAB_code_00028c
    ldi         R18,0x7f
    cli
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    andi        R16,0xf
    cpi         R16,0xf
    brbs        CPU_Z_bp, LAB_code_00027c
    ldd         R17,Z+0x1
    dec         R17
    brbs        CPU_Z_bp, LAB_code_0002b8
    rjmp        LAB_code_00031a
LAB_code_00027c:
    rcall       fpga_settings_reset                         ;undefined FUN_code_0004c5(void)
    ldi         R16,0x2
    sts         PORTE_INTFLAGS,R16
    ldi         R16,0x9
    sts         PORTE_INTCTRL,R16
    ldi         R18,0x7f
    ldi         R16,0x0
    ldi         R17,0x8
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    ldi         R16,0x80
    rjmp        LAB_code_0002c0
LAB_code_00028c:
    lds         R16,PORTD_IN                ;= ??
    sbrs        R16,0x3
    rjmp        LAB_code_00031b
    ldi         R16,0x80
    sts         PORTB_OUTSET,R16
    ldi         R16,0x5
    st          Z,R16
    ldi         R16,0xfa
    std         Z+0x1,R16
    rjmp        LAB_code_00031b
LAB_code_000298:
    eor         R20,R20
    eor         R19,R19
    cli
LAB_code_00029b:
    ldi         R16,0x4
LAB_code_00029c:
    call        ths788_read                         ;undefined5 FUN_code_001104(undefined...
    or          R20,R17
    subi        R16,0xe0
    cpi         R16,0xc4
    brbc        CPU_Z_bp, LAB_code_00029c
    inc         R19
    cpi         R19,0x3
    brbc        CPU_Z_bp, LAB_code_00029b
    bset        CPU_I_bp
    andi        R20,0x1
    brbc        CPU_Z_bp, LAB_code_0002b8
    ldi         R16,0x4
    st          Z,R16
    rjmp        LAB_code_00031b
LAB_code_0002ab:
    ldi         R16,0x82
    eor         R19,R19
LAB_code_0002ad:
    cli
    call        ths788_read                         ;undefined5 FUN_code_001104(undefined...
    bset        CPU_I_bp
    andi        R17,0xf
    cpi         R17,0x1
    brbc        CPU_Z_bp, LAB_code_0002b8
    inc         R19
    cpi         R19,0x3
    brbc        CPU_Z_bp, LAB_code_0002ad
    rjmp        LAB_code_0002c5
LAB_code_0002b8:
    cli
    lds         R16,0x2157               ;= ??
    ori         R16,0x80
    sts         0x2157,R16
    bset        CPU_I_bp
    ldi         R16,0x40
LAB_code_0002c0:
    sts         PORTA_OUTCLR,R16
    eor         R16,R16
    st          Z,R16
    rjmp        LAB_code_00031b
LAB_code_0002c5:
    eor         R16,R16
    ldi         R17,0x3
    eor         R18,R18
    ldi         R19,0x7
    cli
    call        ths788_write                         ;undefined5 FUN_code_0010ba(undefined...
    ldi         R16,0x1
    eor         R17,R17
    eor         R18,R18
    call        ths788_write                         ;undefined5 FUN_code_0010ba(undefined...
    bset        CPU_I_bp
    ldi         R16,0x3
    st          Z,R16
    rjmp        LAB_code_00031b
LAB_code_0002d5:
    ldd         R17,Z+0x1
    dec         R17
    brbs        CPU_Z_bp, LAB_code_0002d9
    rjmp        LAB_code_00031a
LAB_code_0002d9:
    ldi         R16,0x2
    st          Z,R16
    ldi         R16,0x20
    sts         PORTF_OUTCLR,R16            ;= ??
    sts         PORTF_OUTSET,R16            ;= ??
    sts         PORTB_OUTSET,R16            ;= ??
    ldi         R16,0x8
    sts         PORTC_OUTSET,R16            ;= ??
    lds         R16,PORTB_IN                ;= ??
    sbrc        R16,0x6
    rjmp        LAB_code_0002f7
    cli
    lds         R16,0x2157               ;= ??
    ori         R16,0x40
    sts         0x2157,R16               ;= ??
    ldi         R16,0x40
    sts         PORTA_OUTCLR,R16            ;= ??
    ldi         R16,0x4
    sts         PORTE_OUTCLR,R16            ;= ??
    bset        CPU_I_bp
    rjmp        LAB_code_00031b
LAB_code_0002f7:
    ldi         R16,0x1
    sts         PORTB_INTFLAGS,R16
    ldi         R16,0x2
    sts         PORTB_INTCTRL,R16
    ldi         R16,0x80
    ldi         R17,0x0
    ldi         R18,0xa6
    ldi         R19,0x3
    cli
    call        ths788_write                         ;undefined5 FUN_code_0010ba(undefined...
    ldi         R16,0x81
    ldi         R17,0x2
    eor         R18,R18
    call        ths788_write                         ;undefined5 FUN_code_0010ba(undefined...
    ldi         R16,0xc
    ldi         YL,0x7b
    ldi         YH,0x21
    eor         R19,R19
LAB_code_00030d:
    ld          R17,Y+
    eor         R18,R18
    call        ths788_write                         ;undefined5 FUN_code_0010ba(undefined...
    subi        R16,0xe0
    cpi         R16,0x8c
    brbc        CPU_Z_bp, LAB_code_00030d
    ldi         R16,0xc
    inc         R19
    cpi         R19,0x3
    brbc        CPU_Z_bp, LAB_code_00030d
    bset        CPU_I_bp
    rjmp        LAB_code_00031b
LAB_code_00031a:
    std         Z+0x1,R17
LAB_code_00031b:
    adiw        Z,0x2
    ld          R16,Z
    ldd         R24,Z+0x1
    ldd         R25,Z+0x2
    and         R16,R16
    brbc        CPU_Z_bp, LAB_code_000322
    rjmp        LAB_code_000398
LAB_code_000322:
    cpi         R16,0x1
    brbc        CPU_Z_bp, LAB_code_00033d
    sbiw        R24,0x1
    brbc        CPU_Z_bp, LAB_code_000357
    lds         R16,0x2234               ;= ??
    and         R16,R16
    brbs        CPU_Z_bp, LAB_code_000359
    cli
    lds         R16,0x2157               ;= ??
    andi        R16,0x7
    cpi         R16,0x1
    brbc        CPU_Z_bp, LAB_code_000339
    ldi         R16,0x4
    sts         PORTE_OUTSET,R16
    bset        CPU_I_bp
    ldi         R24,0xe8
    ldi         R25,0x3
    ldi         R16,0x2
    st          Z,R16
    rjmp        LAB_code_000357
LAB_code_000339:
    bset        CPU_I_bp
    eor         R16,R16
    st          Z,R16
    rjmp        LAB_code_000357
LAB_code_00033d:
    cpi         R16,0x2
    brbc        CPU_Z_bp, LAB_code_00035a
    sbiw        R24,0x1
    brbc        CPU_Z_bp, LAB_code_000357
    lds         R16,0x2157               ;= ??
    sbrc        R16,0x3
    rjmp        LAB_code_00034f
    ldi         R16,0x4
    cli
    sts         PORTE_OUTCLR,R16
LAB_code_000349:
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x1                ; UPDATE CLK
    rcall       set_status_and_vd8_led                         ;undefined FUN_code_00063f(void)
    bset        CPU_I_bp
    eor         R16,R16
    st          Z,R16
    rjmp        LAB_code_000357
LAB_code_00034f:
    ldi         R24,0xe8
    ldi         R25,0x3
    ldi         R16,0x3
    sts         0x2442,R16
    rcall       system_init                         ;undefined FUN_code_000688(void)
    ldi         R16,0x3
    st          Z,R16
LAB_code_000357:
    std         Z+0x1,R24
    std         Z+0x2,R25
LAB_code_000359:
    rjmp        LAB_code_000398
LAB_code_00035a:
    cpi         R16,0x3
    brbc        CPU_Z_bp, LAB_code_00036c
    sbiw        R24,0x1
    brbc        CPU_Z_bp, LAB_code_000357
    rcall       CDCE62005_control_rst                         ;undefined FUN_code_0006ee(void)
    ldi         R16,0x4
    sts         PORTD_OUTSET,R16
    ldi         R16,0x2
    sts         PORTD_OUTCLR,R16
    sts         PORTD_OUTSET,R16
    ldi         R16,0x4
    st          Z,R16
    ldi         R24,0x88
    ldi         R25,0x13
    rjmp        LAB_code_000357
LAB_code_00036c:
    cpi         R16,0x4
    brbc        CPU_Z_bp, LAB_code_000381
    lds         R16,PORTD_IN                ;= ??
    sbrs        R16,0x3
    rjmp        LAB_code_00037d
    ldi         R16,0x5
    st          Z,R16
    cli
    lds         R16,0x2157               ;= ??
    ori         R16,0x10
    sts         0x2157,R16
    bset        CPU_I_bp
    rcall       FUN_code_0004ef                         ;uint6 FUN_code_0004ef(undefined2 par...
    rjmp        LAB_code_000383
LAB_code_00037d:
    sbiw        R24,0x1
    brbc        CPU_Z_bp, LAB_code_000357
    cli
    rjmp        LAB_code_000349
LAB_code_000381:
    cpi         R16,0x5
    brbc        CPU_Z_bp, LAB_code_000398
LAB_code_000383:
    lds         R16,PORTB_OUT               ;= ??
    sbrs        R16,0x7
    rjmp        LAB_code_000398
    ldi         R16,0x1
    sts         PORTD_INTFLAGS,R16          ;= ??
    ldi         R16,0x2
    sts         PORTD_INTCTRL,R16           ;= ??
    lds         R16,0x2159               ;= ??
    and         R16,R16
    brbc        CPU_Z_bp, LAB_code_000398
    eor         R16,R16
    st          Z,R16
    cli
    call        fpga_send_mcu_timestamp                         ;undefined FUN_code_001298(void)
    bset        CPU_I_bp
    rcall       fpga_settings_init                         ;undefined FUN_code_000472(void)
LAB_code_000398:
    ldd         R24,Z+0x3
    ldd         R25,Z+0x4
    ldi         R16,0x1
    cpi         R24,0xf4
    cpc         R25,R16
    brbc        CPU_Z_bp, LAB_code_0003aa
    cli
    sbis        UPDATE_ERROR_STATUS_REGISTER,0  ;
    rjmp        LAB_code_0003a4     ;   if (UPDATE_ERROR_STATUS_REGISTER  & 1 << 0 ) { // if SYS_FAIL
    ldi         R16,0x1             ;
    sts         PORTA_OUTTGL,R16    ;
LAB_code_0003a4:                    ;   }
    sbis        UPDATE_ERROR_STATUS_REGISTER,2  ;
    rjmp        LAB_code_0003a9     ;   if (UPDATE_ERROR_STATUS_REGISTER & 1 << 1) { // if CLOCK IN
    ldi         R16,0x20            ;
    sts         PORTA_OUTTGL,R16    ;
LAB_code_0003a9:                    ;   }
    bset        CPU_I_bp
LAB_code_0003aa:
    sbiw        R24,0x1
    brbs        CPU_Z_bp, LAB_code_0003af
    std         Z+0x3,R24
    std         Z+0x4,R25
    rjmp        LAB_code_00045f
LAB_code_0003af:
    cli
    sbis        UPDATE_ERROR_STATUS_REGISTER,0x0
    rjmp        LAB_code_0003b5
    ldi         R16,0x1
    sts         PORTA_OUTTGL,R16
LAB_code_0003b5:
    sbis        UPDATE_ERROR_STATUS_REGISTER,0x2
    rjmp        LAB_code_0003ba
    ldi            R16,0x20
    sts         PORTA_OUTTGL,R16
LAB_code_0003ba:
    bset        CPU_I_bp
    ldi         R24,0xe8
    ldi         R25,0x3
    std         Z+0x3,R24
    std         Z+0x4,R25
    ldi         R16,0x50
    ser         R17
    ser         R18
    call        adt7311_16bit_rw                         ;undefined FUN_code_0012df(void)
    eor         R17,R17
    sbrs        R20,0x2
    rjmp        LAB_code_0003c9
    ldi         R17,0x6
    rjmp        LAB_code_0003d0
LAB_code_0003c9:
    sbrs        R20,0x1
    rjmp        LAB_code_0003cd
    ldi         R17,0x4
    rjmp        LAB_code_0003d0
LAB_code_0003cd:
    sbrs        R20,0x0
    rjmp        LAB_code_0003d0
    ldi         R17,0x2
LAB_code_0003d0:
    cli
    lds         R16,0x2157               ;= ??
    mov         R18,R16
    andi        R18,0x6
    eor         R18,R17
    brbs        CPU_Z_bp, LAB_code_0003e7
    andi        R16,0xf9
    or          R16,R17
    sts         0x2157,R16
    sbic        UPDATE_ERROR_STATUS_REGISTER,0x1
    rjmp        LAB_code_0003e6
    cpi         R17,0x6
    brbc        CPU_Z_bp, LAB_code_0003e1
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x1
    rjmp        LAB_code_0003e5
LAB_code_0003e1:
    and         R17,R17
    brbs        CPU_Z_bp, LAB_code_0003e5
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x0
    rjmp        LAB_code_0003e6
LAB_code_0003e5:
    rcall       set_status_and_vd8_led                         ;undefined FUN_code_00063f(void)
LAB_code_0003e6:
    bset        CPU_I_bp
LAB_code_0003e7:
    andi        R20,0xf8
    ldi         R18,0x14
    mul         R20,R18
    mov         R16,R1
    eor         R17,R17
    mulsu       R21,R18
    add         R16,R0
    adc         R17,R1
    ldd         R18,Z+0x5
    ldd         R19,Z+0x6
    std         Z+0x5,R16
    std         Z+0x6,R17
    lds         R20,PORTE_INTCTRL           ;= ??
    sbrs        R20,0x3
    rjmp        LAB_code_00045f
    cp          R16,R18
    cpc         R17,R19
    brbs        CPU_Z_bp, LAB_code_0003ff
    ldi         R18,0xbc
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
LAB_code_0003ff:
    sbic        UPDATE_ERROR_STATUS_REGISTER,0x3
    rjmp        LAB_code_00045f
    ldi         R18,0x7d
    cli
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    movw        Z,R16
    or          R16,R17
    brbc        CPU_Z_bp, LAB_code_00040a
    rjmp        LAB_code_00045f
LAB_code_00040a:
    eor         R23,R23
LAB_code_00040b:
    lsr         ZH
    ror         ZL
    brbs        CPU_C_bp, LAB_code_00040f
    rjmp        LAB_code_00045b
LAB_code_00040f:
    mov         R18,R23
    add         R18,R18
    subi        R18,0xf3
    cli
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    movw        R20,R16
    inc         R18
    cli
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    cp          R16,R20
    cpc           R17,R21
    brbc        CPU_C_bp, LAB_code_000422
    movw        R24,R16
    movw        R16,R20
    movw        R20,R24
LAB_code_000422:
    and         R17,R17
    brbc        CPU_Z_bp, LAB_code_00042b
    cpi         R16,0x97
    brbc        CPU_C_bp, LAB_code_00042b
    cpi         R20,0x1e
    brbc        CPU_C_bp, LAB_code_00045b
    ldi         R16,0x1e
    sub         R16,R20
    rjmp        LAB_code_000434
LAB_code_00042b:
    and         R21,R21
    brbs        CPU_Z_bp, LAB_code_00042f
    cpi         R20,0x1e
    brbs        CPU_C_bp, LAB_code_00045b
LAB_code_00042f:
    movw        R20,R16
    ldi         R16,0x96
    eor         R17,R17
    sub         R16,R20
    sbc         R17,R21
LAB_code_000434:
    mov         R20,R23
    ldi         YL,0xcf
    ldi         YH,0x21
    add         R20,R20
    add         R20,R20
    mov         R18,R20
    add         R20,R20
    subi        R20,0xfc
    eor         R21,R21
    add         YL,R20
    adc         YH,R21
    ld          R20,Y
    ldd         R21,Y+0x1
    add         R20,R16
    adc         R21,R17
    ldi         R24,0x1
    cpi         R20,0xf5
    cpc         R21,R24
    brbc        CPU_S_bp,LAB_code_00044e
    ldi         R24,0xfe
    cpi         R21,0xc
    cpc         R21,R24
    brbc        CPU_S_bp,LAB_code_000450
    ldi         R20,0xc
    ldi         R21,0xfe
    rjmp        LAB_code_000450
LAB_code_00044e:
    ldi         R20,0xf4
    ldi         R21,0x1
LAB_code_000450:
    st          Y,R20
    std         Y+0x1,R21
    movw        R16,R20
    subi        R18,0x7e
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    mov         R22,R23
    call        dac_set_value                         ;undefined3 FUN_code_001082(void)
LAB_code_00045b:
    inc         R23
    cpi         R23,0xc
    brbs        CPU_Z_bp, LAB_code_00045f
    rjmp        LAB_code_00040b
LAB_code_00045f:
    pop         R0
    pop         R1
    pop         R16
    pop         R17
    pop         R18
    pop         R19
    pop         R20
    pop         R21
    pop         R22
    pop         R23
    pop         R24
    pop         R25
    pop         YL
    pop         YH
    pop         ZL
    pop         ZH
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000472(void)
.org (0x0472 << 1)
fpga_settings_init:
    push        R18
    push        R17
    push        R16
    push        YH
    push        ZL
    ldi         R18,0x7c
    eor         R16,R16
    eor         R17,R17
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    lds         R16,TRIGGER_WINDOW
    eor         R17,R17
    eor         R18,R18
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    ldi         YL,0xb7
    ldi         YH,0x21
LAB_code_000488:
    ld          R16,Y+
    ld          R17,Y+
    inc         R18
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    cpi         R18,0xc
    brbc        CPU_Z_bp, LAB_code_000488
    ldi         R18,0x24
    ldi         YL,0x87
    ldi         YH,0x21
LAB_code_000494:
    ld          R16,Y+
    ld          R17,Y+
    inc         R18
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    cpi         R18,0x3c
    brbc        CPU_Z_bp, LAB_code_000494
    inc         R18
    lds         R16,CFD_SAT_LVL_LOW
    lds         R17,CFD_SAT_LVL_HIGH
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    lds         R16,0x2160                   ;= ??
    lds         R17,0x2161                   ;= ??
    ldi         R18,0xbc
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    lds         R16,0x2232                   ;= ??
    lds         R17,0x2233                   ;= ??
    ldi         R18,0xbd
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    ldi         R18,0x7c
    ser         R16
    ldi         R17,0xf
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    pop         ZL
    pop         YH
    pop         R16
    pop         R17
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0004c5(void)
.org (0x04c5 << 1)
fpga_settings_reset:
    push        R16
    push        R17
    push        R18
    push        YL
    push        YH
    ldi         R18,0x80
    ldi         YL,0xcf
    ldi         YH,0x21
LAB_code_0004cd:
    ld          R16,Y+
    ld          R17,Y+
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    inc         R18
    cpi         R18,0xb0
    brbc        CPU_Z_bp, LAB_code_0004cd
    ldi         YL,0x63
    ldi         YH,0x21
LAB_code_0004d8:
    ld          R16,Y+
    ld          R17,Y+
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    inc         R18
    cpi         R18,0xbc
    brbc        CPU_Z_bp, LAB_code_0004d8
    lds         R16,0x2441                   ;= ??
    eor         R17,R17
    ldi         R18,0xbe
    cli
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    pop         YH
    pop         YL
    pop         R18
    pop         R17
    pop         R16
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;uint6 FUN_code_0004ef()
.org (0x04ef << 1)
FUN_code_0004ef:
    push        ZH
    push        ZL
    push        YH
    push        YL
    push        R23
    push        R22
    push        R21
    push        R20
    push        R19
    push        R18
    push        R17
    push        R16
    push        R1
    push        R0
    eor         R23,R23
    ldi         YL,0xcf
    ldi         YH,0x21
LAB_code_000500:
    ld          R20,Y+
    ld          R21,Y+
    mov         R22,R23
    call        dac_set_value_3                         ;undefined4 FUN_code_001053(undefined...
    ld          R20,Y+
    ld          R21,Y+
    mov         R22,R23
    call        dac_set_value_2                         ;undefined3 FUN_code_001076(void)
    ld          R20,Y+
    ld          R21,Y+
    mov         R22,R23
    call        dac_set_value                         ;undefined3 FUN_code_001082(void)
    ld          R20,Y+
    ld          R21,Y+
    mov         R22,R23
    call        dac_set_value_3                         ;undefined4 FUN_code_001068(undefined...
    inc         R23
    cpi         R23,0xc
    brbc        CPU_Z_bp, LAB_code_000500
    pop         R0
    pop         R1
    pop         R16
    pop         R17
    pop         R18
    pop         R19
    pop         R20
    pop         R21
    pop         R22
    pop         R23
    pop         YL
    pop         YH
    pop         ZL
    pop         ZH
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000526(void)
.org (0x0526 << 1)
PORTD_INT0_vect_isr:    ; fpga_done
    push        ZH
    in          ZH,CPU_SREG
    push        R16
    lds         R16,PORTD_IN                    ;= ??
    bst         R16,0x3
    cli
    lds         R16,0x2157                   ;= ??
    bld         R16,0x4
    sts         0x2157,R16                   ;= ??
    bset        CPU_I_bp
    brbc        CPU_T_bp,LAB_code_000539
    cli
    ldi         R16,0x5
    rcall       FPGA_reset                         ;undefined FUN_code_00054e(void)
    bset        CPU_I_bp
    rjmp        LAB_code_00054a
LAB_code_000539:
    ldi         R16,0x1
    sts         PORTE_INTCTRL,R16               ;= ??
    eor         R16,R16
    sts         0x2158,R16                   ;= ??
    lds         R16,0x2157                   ;= ??
    andi        R16,0x7f
    sts         0x2157,R16                   ;= ??
    ldi         R16,0xc0
    sts         PORTA_OUTSET,R16                ;= ??
    ldi         R16,0x1
    sts         0x2441,R16                   ;= ??
LAB_code_00054a:
    pop         R16
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
.org (0x054e << 1)
; Note
; R16 - (probably) reason_to_reset
FPGA_reset:
    sts         0x215b,R16                      ;= ??
    ldi         R16,0x80
    sts         PORTB_OUTCLR,R16                ; Reset FPGA
    lds         R16,0x2159                      ;= ??
    and         R16,R16
    brbs        CPU_Z_bp, LAB_code_00055a
    cpi         R16,0x5
    brbs        CPU_Z_bp, LAB_code_00055a
    ret
LAB_code_00055a:
    ldi         R16,0x4
    sts         0x2159,R16                   ;= ??
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_00055e(void)
.org (0x055e << 1)
PORTB_INT0_vect_isr:        ; ths788_ot_alarm
    push        ZH
    in          ZH,CPU_SREG
    push        R16
    lds         R16,0x2157                   ;= ??
    ori         R16,0x60
    sts         0x2157,R16                   ;= ??
    ldi         R16,0x40
    sts         PORTA_OUTCLR,R16                ;= ??
    ldi         R16,0x4
    sts         PORTE_OUTCLR,R16                ;= ??
    pop         R16
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000570(void)
.org (0x0570 << 1)
PORTF_INT1_vect_isr:
    push        ZH
    in          ZH,CPU_SREG
    push        R16
    push        R17
    push        R18
    push        R19
    lds         R16,PORTF_IN                    ;= ??
    bst         R16,0x6
    brbc        CPU_T_bp,LAB_code_000585
    sbrc        R16,0x5
    rjmp        LAB_code_000585
    ldi         R16,0xf5
    ldi         R17,0xf
    ldi         R18,0x4
    ldi         R19,0x40
    call        CDCE62005_send_control_settings ; Address = 5, Data = 0x40'04'0F'F
    ldi         R16,0x20
    sts         PORTF_OUTSET,R16                ;= ??
LAB_code_000585:
    call        CDCE62005_read_status_register                         ;undefined FUN_code_001267(void)
    swap        R19
    andi        R19,0xe
    bld         R19,0x0
    lds         R16,0x2162                   ;= ??
    andi        R16,0xe
    sts         0x2162,R19                   ;= ??
    eor         R16,R19
    brbs        CPU_Z_bp, LAB_code_0005a1
    ldi         R16,0x20
    sbrs        R19,0x1
    rjmp        LAB_code_000598
    sts         PORTA_OUTCLR,R16                ;= ??
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x2
    rjmp        LAB_code_0005a1
LAB_code_000598:
    sbrs        R19,0x2
    rjmp        LAB_code_00059b
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x2
LAB_code_00059b:
    sbrs        R19,0x3
    rjmp        LAB_code_0005a1
    ldi         R16,0x20
    sts         PORTA_OUTSET,R16                ;= ??
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x2
LAB_code_0005a1:
    brbc        CPU_T_bp,LAB_code_0005a9
    ldi         R16,0xa
    sts         0x215a,R16                   ;= ??
    ldi         R16,0x1
    sts         0x2159,R16                   ;= ??
    rjmp        LAB_code_0005ad
LAB_code_0005a9:
    rcall       FUN_code_0005b4                         ;undefined FUN_code_0005b4(void)
    ldi         R16,0x2
    sts         0x2441,R16                   ;= ??
LAB_code_0005ad:
    pop         R19
    pop         R18
    pop         R17
    pop         R16
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0005b4(void)
.org (0x05b4 << 1)
FUN_code_0005b4:
    ldi         R16,0x1
    sts         PORTE_INTCTRL,R16               ;= ??
    ldi         R16,0x8
    sts         PORTC_OUTCLR,R16                ;= ??
    ldi         R16,0xa0
    sts         PORTB_OUTCLR,R16                ;= ??
    ldi         R16,0xc0
    sts         PORTA_OUTSET,R16                ;= ??
    eor         R16,R16
    sts         0x2158,R16                   ;= ??
    sts         0x2159,R16                   ;= ??
    lds         R16,0x2157                   ;= ??
    andi        R16,0x7f
    sts         0x2157,R16                   ;= ??
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0005cb(void)
.org (0x05cb << 1)
PORTE_INT0_vect_isr:        ; ps_change_detected
    push        ZH
    in          ZH,CPU_SREG
    cli
    push        R16
    push        R17
    push        R18
    eor         R17,R17
    lds         R16,PORTE_IN                    ;= ??
    bst         R16,0x1
    bld         R17,0x0
    bst         R16,0x3
    bld         R17,0x3
    bst         R16,0x2
    lds         R16,0x2157                   ;= ??
    mov         R18,R16
    andi        R16,0xf6
    or          R16,R17
    sts         0x2157,R16                   ;= ??
    eor         R18,R17
    sbrs        R18,0x0
    rjmp        LAB_code_0005f6
    sbrc        R17,0x0
    rjmp        LAB_code_0005eb
    ldi         R16,0x4
    sts         PORTE_OUTCLR,R16                ;= ??
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x1
    rcall       system_deinit                         ;undefined FUN_code_00064b(void)
    rjmp        LAB_code_00060e
LAB_code_0005eb:
    ldi         R17,0xd0
    ldi         R18,0x7
LAB_code_0005ed:
    ldi         R16,0x1
    sts         0x215b,R16                   ;= ??
    sts         0x215c,R17                   ;= ??
    sts         0x215d,R18                   ;= ??
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x1
    rjmp        LAB_code_00060e
LAB_code_0005f6:
    sbrs        R18,0x3
    rjmp        LAB_code_00060f
    sbrc        R17,0x3
    rjmp        LAB_code_00060f
    lds         R16,0x215b                   ;= ??
    cpi         R16,0x2
    brbc        CPU_Z_bp, LAB_code_00060b
    lds         R16,0x2442                   ;= ??
    and         R16,R16
    brbs        CPU_Z_bp, LAB_code_00060b
    dec         R16
    sts         0x2442,R16                   ;= ??
    ldi         R16,0x4
    sts         PORTE_OUTCLR,R16                ;= ??
    ldi         R17,0x88
    ldi         R18,0x13
    rjmp        LAB_code_0005ed
LAB_code_00060b:
    rcall       system_deinit                         ;undefined FUN_code_00064b(void)
    brbc        CPU_T_bp,LAB_code_00060f
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x1
LAB_code_00060e:
    rcall       set_status_and_vd8_led                         ;undefined FUN_code_00063f(void)
LAB_code_00060f:
    pop         R18
    pop         R17
    pop         R16
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000615()
.org (0x0615 << 1)
PORTE_INT1_vect_isr:           ; fpga_comm_request
    push        R31
    in          R31,CPU_SREG    ; copy SREG
    push        R16
    push        R17
    push        R18
    ldi         R18,0x7f
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    sbrs        R17,0x1
    rjmp        LAB_code_000624
    lds         R18,0x2006               ;= ??
    ori         R18,0x1
    sts         0x2006,R18
LAB_code_000624:
    swap        R16
    andi        R16,0xf
    swap        R17
    andi        R17,0x10
    or          R17,R16
    lds         R16,0x2158               ;= ??
    andi        R16,0xfe
    or          R16,R17
    sts         0x2158,R16
    andi        R17,0x1c
    brbs        CPU_Z_bp, LAB_code_000639
    lds         R16,0x2157               ;= ??
    ori         R16,0x80
    sts         0x2157,R16
    ldi         R16,0x40
    sts         PORTA_OUTCLR,R16
LAB_code_000639:
    pop         R18
    pop         R17
    pop         R16
    out         CPU_SREG,R31
    pop         R31
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_00063f(void)
.org (0x063f << 1)
set_status_and_vd8_led:
    sbic        UPDATE_ERROR_STATUS_REGISTER,0x1                ;
    rjmp        LAB_code_000646                                 ; if (!clock) {
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x0                ;   UPDATE_ERROR_STATUS_REGISTER |= 1 << 0
    ldi         R16,0x1                                         ;
    sts         PORTA_OUTSET,R16                                ;   disable LED_SYS_FAIL
    ret                                                         ;   return;
LAB_code_000646:                                                ; } else {
    ldi         R16,0x1                                         ;
    sts         PORTA_OUTCLR,R16                                ;   enable LED_SYS_FAIL
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x0                ;   UPDATE_ERROR_STATUS_REGISTER |= 1 << 0
    ret                                                         ; }
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_00064b(void)
.org (0x064b << 1)
system_deinit:
    eor         R16,R16
    sts         0x215C,R16                   ;= ??
    sts         0x215D,R16                   ;= ??
    sts         0x215B,R16                   ;= ??
    sts         0x2159,R16                   ;= ??
    sts         0x2441,R16                   ;= ??
    sts         0x2006,R16                   ;= ??
    sts         0x2162,R16                   ;= ??
    ldi         R16,0x1
    sts         PORTE_INTCTRL,R16               ;= ??
    ldi         R16,0x2
    sts         PORTF_INTCTRL,R16               ;= ??
    ldi         R16,0x0
    sts         PORTB_INTCTRL,R16               ;= ??
    sts         PORTD_INTCTRL,R16               ;= ??
    ldi         R16,0xbf
    sts         PORTB_DIRCLR,R16                ;= ??
    eor         R16,R16
    sts         SPIC_CTRL,R16                        ;= ??
    ser         R16
    sts         PORTC_DIRCLR,R16                ;= ??
    ldi         R16,0x41
    sts         PORTD_DIRCLR,R16                ;= ??
    ldi         R16,0x4
    sts         PORTD_OUTCLR,R16                ;= ??
    ldi         R16,0x20
    sts         PORTF_OUTCLR,R16                ;= ??
    ldi         R16,0x20
    sts         PORTF_DIRCLR,R16                ;= ??
    lds         R16,0x2157                   ;= ??
    andi        R16,0xef
    sts         0x2157,R16                   ;= ??
    ldi         R16,0xa0
    sts         PORTA_OUTSET,R16                ;= ??
    eor         R16,R16
    sts         SPID_CTRL,R16                        ;= ??
    sts         DMA_CTRL,R16                         ;= ??
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000688(void)
.org (0x0688 << 1)
system_init:
                                                    ; PORTS
    ldi         R16,0xbc
    sts         PORTB_OUT,R16
    ldi         R16,0xbf
    sts         PORTB_DIRSET,R16
    ldi         R16,0x7
    sts         PORTC_OUT,R16
    ldi         R16,0xbf
    sts         PORTC_DIRSET,R16
    ldi         R16,0x1
    sts         PORTD_OUTSET,R16
    ldi         R16,0x41
    sts         PORTD_DIRSET,R16
    ldi         R16,0x10
    sts         PORTF_OUTSET,R16
    ldi         R16,0x30
    sts         PORTF_DIRSET,R16

    ldi         R16,0xD1
    sts         SPIC_CTRL,R16                       ;
    ldi         R16,0x40
    sts         DMA_CTRL,R16                        ; DMA reset
LAB_code_0006a6:
    lds         R16,DMA_CTRL                         ;= ??
    sbrc        R16,0x6
    rjmp        LAB_code_0006a6
    ldi         R16,0x44
    sts         SPID_CTRL,R16                        ;= ??
    ldi         R16,0x83
    sts         DMA_CTRL,R16                         ;= ??
    ldi         R16,0x6a
    sts         DMA_CH0_TRIGSRC,R16             ;= ??
    ldi         R16,0xc3
    sts         DMA_CH0_DESTADDR0,R16           ;= ??
    ldi         R16,0x9
    sts         DMA_CH0_DESTADDR1,R16           ;= ??
    eor         R16,R16
    sts         DMA_CH0_DESTADDR2,R16           ;= ??
    ldi         R16,0x50
    sts         DMA_CH0_ADDRCTRL,R16            ;= ??
    ldi         R16,0x6a
    sts         DMA_CH1_TRIGSRC,R16             ;= ??
    ldi         R16,0x39
    sts         DMA_CH1_DESTADDR0,R16           ;= ??
    ldi         R16,0x24
    sts         DMA_CH1_DESTADDR1,R16           ;= ??
    eor         R16,R16
    sts         DMA_CH1_DESTADDR2,R16           ;= ??
    ldi         R16,0xc3
    sts         DMA_CH1_SRCADDR0,R16            ;= ??
    ldi         R16,0x9
    sts         DMA_CH1_SRCADDR1,R16            ;= ??
    eor         R16,R16
    sts         DMA_CH1_SRCADDR2,R16            ;= ??
    sts         DMA_CH1_REPCNT,R16              ;= ??
    ldi         R16,0x8
    sts         DMA_CH1_TRFCNT,R16              ;= ??
    eor         R16,R16
    sts         0x0125,R16                ;= ??
    ldi         R16,0x5
    sts         DMA_CH1_ADDRCTRL,R16            ;= ??
    ldi         R16,0xa4
    sts         DMA_CH1_CTRLA,R16               ;= ??
    ldi         R16,0x1
    sts         DMA_CH1_CTRLB,R16               ;= ??
    ldi         R16,0x8
    ldi         R17,0x10
    eor         R18,R18
    eor         R19,R19
    cli
    call        CDCE62005_send_control_settings ; Address = 0x8; Data = 0x00'00'10'0 ???? NOTE RESERVED should be 0
    bset        CPU_I_bp
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0006ee(void)
.org (0x06ee << 1)
CDCE62005_control_rst:
    push        R16
    push        R17
    push        R18
    push        R19
    push        R20
    push        ZL
    push        ZH
    ldi         ZL,0x16
    ldi         ZH,0x29                                     ; Z = 0x2916
    ldi         R20,10
CDCE62005_CTRL_RST_for_loop:                                ; data[10] = [
    lpm         R16,Z+                                      ;   0x00001808, 0xEB070320, 0x210380EB, 0x020306EB, 0x030380EB,
    lpm         R17,Z+                                      ;   0x34038468, 0x350F0440, 0x8601FEC0, 0xF7BB42BD, 0x8601FEC4
    lpm         R18,Z+                                      ; ];
    lpm         R19,Z+                                      ; for (int i = 0; i < 10; i++){
    cli                                                     ;   Disable IRQ
    call        CDCE62005_send_control_settings             ;   CDCE62005_send_control_settings(address = data[i] & 0x0F, data = data[i] >> 4);
    bset        CPU_I_bp                                    ;   Enable IRQ
    dec         R20                                         ;
    brbc        CPU_Z_bp, CDCE62005_CTRL_RST_for_loop       ; }
    ldi         R16,0xa                                     ;
    sts         PORTF_INTCTRL,R16                           ; Enable IRQ with Med
    ldi         R16,0x20
    sts         PORTB_OUTCLR,R16                            ; THS release reset
    pop         ZH
    pop         ZL
    pop         R20
    pop         R19
    pop         R18
    pop         R17
    pop         R16
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000710(void)
.org (0x0710 << 1)
PORTF_INT0_vect_isr:
    push        R31
    in          R31,CPU_SREG
    push        ZH
    push        ZL
    push        R29
    push        R18
    push        R17
    push        R16
    ldi         ZL,0x04
    ldi         ZH,0x20                         ; Z = 0x2004
    eor         R29,R29                         ;
    lds         R16,PORTF_IN                    ; Read Console CTS
    sbrc        R16,0x1                         ; if (Console_CTS == 0)
    rjmp        LAB_code_00073a                 ;   return
    inc         R29                             ; R29 = 1
    ld          R17,-Z                          ; R17 = *(0x2003)
    ld          R16,-Z                          ; R16 = *(0x2002)
    cp          R16,R17
    brbs        CPU_Z_bp, LAB_code_000739
    lds         R18,USARTF0_STATUS              ;= ??
    sbrs        R18,0x5
    rjmp        LAB_code_000734
    eor         R17,R17
    inc         R16
    ldi         ZL,0x47
    ldi         ZH,0x20
    add         ZL,R16
    adc         ZH,R17
    ld          R17,Z
    sts         USARTF0_DATA,R17                     ;= ??
    ldi         ZL,0x02
    ldi         ZH,0x20                         ; Z = 0x2002
    st          Z,R16                           ;
LAB_code_000734:
    lds         R18,USARTF0_CTRLA               ;= ??
    ori         R18,0x2
    sts         USARTF0_CTRLA,R18               ;= ??
LAB_code_000739:
    adiw        Z,0x2
LAB_code_00073a:
    st          Z,R29
    pop         R16
    pop         R17
    pop         R18
    pop         R29
    pop         ZL
    pop         ZH
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000744(void)
; Send character via interrupt
.org (0x0744 << 1)
; NOTE: I guess

; // Global:
; uint8_t *SEND_MESSAGE_SIZE  = *(0x2003);
; uint8_t *SEND_BUFFER_SIZE   = *(0x2004);
; uint8_t *SEND_CURRENT_CHAR_INDEX  = *(0x2002);

; char SEND_buffer[SEND_BUFFER_SIZE]; // First address 0x2047
;
; ISR(USARTF0_DRE_vect){
;   if (SEND_MESSAGE_SIZE == 0 || SEND_CURRENT_CHAR_INDEX == SEND_BUFFER_SIZE) {
;       disable_this_interrupt();
;       return;
;   }
;
;   char c = SEND_buffer[SEND_CURRENT_CHAR_INDEX];
;   transmit_char(c);
;   SEND_CURRENT_CHAR_INDEX++;
; }
USARTF0_DRE_vect_isr:
    push        ZH
    in          ZH,CPU_SREG
    push        ZH
    push        ZL
    push        R19
    push        R18
    push        R17
    push        R16
    ldi         ZL,0x2
    ldi         ZH,0x20                     ; Z = 0x2002
    ld          R16,Z+                      ; R16 = *(0x2002), Z++
    ld          R17,Z+                      ; R17 = *(0x2003), Z++
    ld          R18,Z                       ; R18 = *(0x2004)
    and         R18,R18
    brbs        CPU_Z_bp, LAB_code_000755   ; if (
    cp          R16,R17                     ;       *(0x2004) == 0
    brbc        CPU_Z_bp, LAB_code_00075b   ;   ||  *(0x2002) == *(0x2003)
LAB_code_000755:                            ; ) {
    lds         R19,USARTF0_CTRLA           ; Disable interrupts from DRE
    andi        R19,0xfc                    ;
    sts         USARTF0_CTRLA,R19           ;
    rjmp        LAB_code_000767             ; return
LAB_code_00075b:                            ; }
    inc         R16                         ; R16++
    eor         R17,R17                     ; R17 = 0
    ldi         ZL,0x47
    ldi         ZH,0x20                     ; Z = 0x2047
    add         ZL,R16                      ; Z += R16
    adc         ZH,R17
    ld          R17,Z                       ; R17 = char
    sts         USARTF0_DATA,R17            ; Send char from 0x2047
    ldi         ZL,0x2
    ldi         ZH,0x20                     ; Z = 0x2002
    st          Z,R16                       ; *0x2002 = R16
LAB_code_000767:
    pop         R16
    pop         R17
    pop         R18
    pop         R19
    pop         ZL
    pop         ZH
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000770(void)
; NOTE: I gueess

; uint8_t RECV_CURRENT_CHAR_INDEX = *(0x2001)
; uint8_t RECV_MESSAGE_SIZE = *(0x2000)
; char *RECV_buffer = *0x2007
;
; ISR(USARTF0_RXC_vect){
;   if (RECV_CURRENT_CHAR_INDEX == RECV_MESSAGE_SIZE) {
;       set_ready_to_receive(false);
;       SERIAL_RECV_MSG_LEN |= 0x80;
;   }
;   if (USARTF0_STATUS & 1 << 4) { // if error
;       return
;   }
;   char c = USARTF0_DATA
;   RECV_buffor[RECV_CURRENT_CHAR_INDEX] = c;
;   if (c != 'r')
;       SERIAL_RECV_MSG_LEN++;
; }
.org (0x770 << 1)
USARTF0_RXC_vect_isr:
    push        ZH
    in          ZH,CPU_SREG
    push        ZH
    push        ZL
    push        R19
    push        R18
    push        R17
    push        R16
    ldi         ZL,0x00
    ldi         ZH,0x20                         ; Z = 2000
    ld          R16,Z+                          ; R16 = *(0x2000), Z++; // RECV_MESSAGE_SIZE
    ld          R17,Z                           ; R17 = *(0x2001)       // RECV_CURRENT_CHAR_INDEX
    inc         R17                             ; R17++                 // RECV_CURRENT_CHAR_INDEX++
    andi        R17,0x3f                        ; R17 & 0b0111'1111
    mov         R18,R17                         ;
    subi        R18,0xec                        ;
    andi        R18,0x3f                        ; R18 = (R17 - 0xEC) && 0b0111'1111
    cp          R18,R16                         ; if (RECV_CURRENT_CHAR_INDEX == RECV_MESSAGE_SIZE){
    brbc        CPU_Z_bp, LAB_code_00078b       ;
    ldi         R18,0x1                         ; Initialize receive transaction
    sts         PORTF_OUTSET,R18                ; Unready to receive new data
    lds         R18,SERIAL_RECV_MSG_LEN         ;
    ori         R18,0x80                        ;
    sts         SERIAL_RECV_MSG_LEN,R18         ; }
LAB_code_00078b:
    lds         R19,USARTF0_STATUS              ;
    lds         R18,USARTF0_DATA                ; char c = USARTF0_DATA;
    sbrc        R19,0x4                         ;
    rjmp        LAB_code_0007a1                 ; if (USARTF0_STATUS && 1<<4) {
    cp          R16,R17                         ; if (R16 == R17)
    brbs        CPU_Z_bp, LAB_code_0007a1       ;   return
    st          Z,R17                           ;
    ldi         ZL,0x07                         ;
    ldi         ZH,0x20                         ;
    eor         R16,R16                         ;
    add         ZL,R17                          ;
    adc         ZH,R16                          ;
    st          Z,R18                           ; RECV_buffor[RECV_CURRENT_CHAR_INDEX] = c;
    cpi         R18,'\r'                        ; if (c == '\r') return;
    brbc        CPU_Z_bp, LAB_code_0007a1       ;
    lds         R16,SERIAL_RECV_MSG_LEN         ;
    inc         R16                             ; SERIAL_RECV_MSG_LEN++;
    sts         SERIAL_RECV_MSG_LEN,R16         ; }
LAB_code_0007a1:
    pop         R16
    pop         R17
    pop         R18
    pop         R19
    pop         ZL
    pop         ZH
    out         CPU_SREG,ZH
    pop         ZH
    reti
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0007aa(void)

.org (0x07aa << 1)
main:
    ldi         R16,0xCB                        ; Oscillator control register
    sts         OSC_XOSCCTRL,R16                ; FREQRANGE = 11 - 12MHz - 16MHz
                                                ; XTAL = 1011 - long start-up time

    ldi         R16,0x09                        ; inside PLL configuration
    sts         OSC_CTRL,R16                    ; PLLEN = 0 - PLL disable
                                                ; XOSCEN = 1 - Select ext oscillator
                                                ; 2MHz = 1 - enable internal 2MHz oscillator

wait_until_ext_osc_ok:                          ; while (OSC_STATUS & (1 << 3)); // wait for external oscillator
    lds         R17,OSC_STATUS
    sbrs        R17,3
    rjmp        wait_until_ext_osc_ok

    ldi         R16,0xc2                        ; PLL configure
    sts         OSC_PLLCTRL,R16                 ; Select ext clock src, mul freq 2x
    ldi         R16,0x19                        ; Enable PLL
    sts         OSC_CTRL,R16

wait_unitl_pll_run:                             ; while (OSC_STATUS & (1 << 4)) // wait for PLL
    lds         R17,OSC_STATUS
    sbrs        R17,0x4
    rjmp        wait_unitl_pll_run

    ldi         R17,0xD8
    ldi         R16,0x4
    sts         CPU_CCP,R17                     ; Enable next instruction
    sts         CLK_CTRL,R16                    ; Select PLL as system clock
    ldi         R16,0x18
    sts         OSC_CTRL,R16                    ; Disable 2MHz internal oscillator

    ; Set stack pointer
    ser         R25                             ; R25 = 0xFF
    out         CPU_SPL,R25
    ldi         R25,0x3f
    out         CPU_SPH,R25

    ; GPIO configuration
    ; Configure port A
    ldi         R16,0xfb
    sts         PORTA_DIRSET,R16                ; DDRA = 0xFB
    ldi         R16,0xf3
    sts         PORTA_OUTSET,R16                ; PORTA = 0xF3
    ldi         R16,0x18
    sts         PORTA_PIN2CTRL,R16              ; Enable Pull-up
    ldi         R16,0x80
    sts         PORTA_PIN1CTRL,R16              ; Limit slew rate
    sts         PORTA_PIN3CTRL,R16              ; Limit slew rate
    sts         PORTA_PIN4CTRL,R16              ; Limit slew rate
    ; Configure port B
    ldi         R16,0x2
    sts         PORTB_PIN6CTRL,R16              ; Enable Pull-down
    ; Configure port C
    ldi         R16,0x80
    sts         PORTC_PIN3CTRL,R16              ; Limit slew rate
    ldi         R16,0x30
    sts         PORTC_PIN4CTRL,R16              ; Invert pin
    ;Configure port D
    ldi         R16,0x28
    sts         PORTD_PIN1CTRL,R16              ; Open drain (Wired AND)
    sts         PORTD_PIN2CTRL,R16              ; Open drain (Wired AND)
    ldi         R16,0x4
    sts         PORTD_OUTCLR,R16                ; clear 4 bit in port D
    ldi         R16,0x2
    sts         PORTD_OUTSET,R16                ; set 2 bit in port D
    ldi         R16,0x6
    sts         PORTD_DIRSET,R16                ; DDRD = 0x06
    ldi         R16,0x0
    sts         PORTD_PIN3CTRL,R16              ; WARNING: WHY? This should be 0 after restart? This no make sens
    ; Configure port E
    ldi         R16,0x4
    sts         PORTE_DIRSET,R16                ; DDRE = 0x04
    ldi         R16,0x1
    sts         PORTE_PIN0CTRL,R16              ; Sense on Rising Edge
    ldi         R16,0x0
    sts         PORTE_PIN1CTRL,R16              ; push pull, Sense on Both Edge WARNING: this no make sens
    ldi         R16,0x80
    sts         PORTE_PIN2CTRL,R16              ; Limit slew rate
    ldi         R16,0x0
    sts         PORTE_PIN3CTRL,R16              ; push pull, Sense on Both Edge WARNING: this no make sens
    ldi         R16,0xa
    sts         PORTE_INT0MASK,R16              ; Enable 0 interrupt at 3, 1 pin at PORTE
    ldi         R16,0x1
    sts         PORTE_INT1MASK,R16              ; Enable 1 interrupt at 0 pin at PORTE
    ; Configure port F
    ldi         R16,0x9
    sts         PORTF_DIRSET,R16                ; DDRF = 0x09
    ldi         R16,0x0
    sts         PORTF_PIN1CTRL,R16              ; push pull, sense on Both edge  WARNING: this no make sens
    ldi         R16,0x0
    sts         PORTF_PIN6CTRL,R16              ; push pull, sense on Both edge  WARNING: this no make sens
    ldi         R16,0x10
    sts         PORTF_PIN7CTRL,R16              ; Pull-down
    ; Enable interrupt
    ldi         R16,0x40
    sts         PORTB_INT0MASK,R16              ; Enable interrupt PORT B at 6
    ldi         R16,0x8
    sts         PORTD_INT0MASK,R16              ; Enable interrupt PORT D at 6
    ldi         R16,0x2
    sts         PORTF_INT0MASK,R16              ; Enable interrupt PORT F at 6
    ldi         R16,0x40
    sts         PORTF_INT1MASK,R16              ; Enable interrupt PORT F at 6

    ; USART configuration
    ldi         R16,0x1
    sts         PORTF_OUTSET,R16                ; Unready to receive data

    ldi         R16,0xd0                        ; USART baud rate
    sts         USARTF0_BAUDCTRLB,R16           ; BSCALE = -3 BSEL = 0x83 CLK2X as default = 0
    ldi         R16,0x83                        ; BAUD RATE = 115200
    sts         USARTF0_BAUDCTRLA,R16           ;
    ldi         R16,0x3
    sts         USARTF0_CTRLC,R16               ; 8 bit mode
    ldi         R16,0x18
    sts         USARTF0_CTRLB,R16               ; Enable Rx and Tx pin
    ldi         R16,0x20
    sts         USARTF0_CTRLA,R16               ; Medium level Rx interrupt

    ; Timer configuration
    ; Timer 0 set to tick at 1kHz
    ldi         R16,0x6
    sts         TCC0_CTRLA,R16                  ; Prescaler 256
    ldi         R16,0x7d
    sts         TCC0_PERL,R16                   ; Set count max
    ldi         R16,0x0                         ; Timer freq = 1kHz
    sts         TCC0_PERH,R16                   ;
    ldi         R16,0x0
    sts         TCC0_CTRLB,R16                  ; Normal mode counter WARNING: No make sens
    ldi         R16,0x0
    sts         TCC0_CTRLE,R16                  ; Single 16 bit timer at normal mode WARNING: No make sens
    ldi         R16,0x1
    sts         TCC0_INTCTRLA,R16               ; Low level interrupt

    ; EEPROM controller
    ldi         R16,0x8
    sts         NVM_CTRLB,R16                   ; Enable EEPROM
    eor         R25,R25                         ; R25 = 0

    ; Probably compiler code
    ldi         ZL,0x0
    ldi         ZH,0x20
    ldi         YL,0x43
    ldi         YH,0x24
clear_RAM:
    st          Z+,R25                          ; while (Z != Y) { // range *0x2000, *0x24
    cp          ZL,YL                           ;   *Z = 0;
    cpc         ZH,YH                           ;   Z++;
    brbc        CPU_Z_bp, clear_RAM             ; }
    ; Read board state / static variable
    ldi         R16,0x3
    sts         0x2442,R16                      ; static variable

    lds         R16,PORTF_IN                    ; NOTE serial is available
    sbrs        R16,0x1                         ; if (!PIN MCU_Console_CTS)
    inc         R25                             ; R25 = 1
    sts         0x2004,R25                      ; NOTE bool Serial_readyToSend = !PIN MCU_Console_CTS

    lds         R16,PORTE_IN                    ; NOTE Power in OK
    bst         R16,0x1                         ; T = PORTE & 0x02
    eor         R16,R16                         ; set R16 to 0
    bld         R16,0x0                         ; R16 b0 = PORTE_IN && 2 >> 1
    sts         0x2157,R16                      ; NOTE bool power_nok = PORTE && 2 >> 1

    brbs        CPU_T_bp,power_is_not_ok        ; if (!power_nok) { // if power is ok
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x1              ;   UPDATE_ERROR_STATUS_REGISTER |= 1 << 1 //
    ldi         R16,0x1                         ;
    sts         PORTA_OUTCLR,R16                ;   disable LED_SYS_FAIL
    rjmp        post_power_check                ;
power_is_not_ok:                                ; } else { // if power is NOT ok
    ldi         R16,0x1                         ; ???
    sts         0x215b,R16                      ; ???
    ldi         R16,0xd0                        ; ???
    sts         0x215c,R16                      ; ???
    ldi         R16,0x7                         ; ???
    sts         0x215d,R16                      ; ???
                                                ; }
post_power_check:
    ldi         R16,0xe8
    sts         0x215e,R16                      ;= ??
    ldi         R16,0x3
    sts         0x215f,R16                      ;= ??
    ldi         R16,0x1
    sts         PORTE_INTCTRL,R16               ; Enable interrupt LOW priority PORT E
    ldi         R16,0x2
    sts         PORTF_INTCTRL,R16               ; Enable interrupt MID priority PORT F
    ldi         R16,0x3
    sts         PMIC_CTRL,R16                   ; Enable interrupt level LOW and MID
    call        adt7311_faults_clr              ; Clear spi
    ldi         R16,0x8                         ; ADT7311 reg address: 0x01 | R/W = W
    ldi         R17,0x50                        ; Resolution 13 bit, mode = 1 SPS, Comparator mode
    call        adt7311_8bit_rw                 ; adt7311_8bit_rw(address: 0x08, data: 0x50)
    ldi         R16,0x20                        ; Address: 0x04 | critical over temperature limit
    ldi         R17,0x0                         ;
    ldi         R18,0x23                        ; 0x2300 >> 7 = 70 -- overheated limit at 70C
    call        adt7311_16bit_rw                ; adt7311_16bit_rw(address: 0x20, data: 0x23 << 8 | 0x00)
    ldi         R16,0x30                        ; address: 0x06 | over temperature limit
    ldi         R17,0x0
    ldi         R18,0x1e                        ; 0x1E00 >> 7 = 60 | overheated limit
    call        adt7311_16bit_rw                ; adt7311_16bit_rw(address: 0x30, data: 0x1E00)


    ldi         ZL,0x63                         ; Z = 0x2163
    ldi         ZH,0x21                         ; Y = 0x1000 // EEPROM address
    ldi         YL,0x0                          ;
    ldi         YH,0x10                         ;
    ldi         R17,0x22                        ;
COPY_FROM_EEPROM:                               ; Copy from EEPROM to RAM 210 bytes
    ld          R16,Y+                          ;
    st          Z+,R16                          ;
    cpi         ZL,0x35                         ;
    cpc         ZH,R17                          ;
    brbc        CPU_Z_bp, COPY_FROM_EEPROM      ; if Z != 0x2235 jump

    cbi         UPDATE_ERROR_STATUS_REGISTER,0x3              ; UPDATE_ERROR_STATUS_REGISTER |= 1 << 3
    bset        CPU_I_bp                        ; Enable interrupt

    ldi         ZL,0x62                         ;
    ldi         ZH,0x29                         ;
    call        cli_send_msg                    ; Send: "\r\nPMxx control interface ready\r\n"
    ldi         R16,0x1                         ;
    sts         PORTF_OUTCLR,R16                ; Release Console reset

LAB_code_0008a3:
    lds         R16,0x2006                      ;
    and         R16,R16                         ;
    brbs        CPU_Z_bp, LAB_code_0008a8       ; if 0x2006 == 0 goto fpga_data_exchange
    rcall       fpga_data_exchange              ;
LAB_code_0008a8:                                ;
    lds         R16,SERIAL_RECV_MSG_LEN         ;
    and         R16,R16                         ;
    brbs        CPU_Z_bp, LAB_code_0008a3       ; if (SERIAL_RECV_MSG_LEN != 0){
    rcall       cli_prompt_parse                ;   cli_prompt_parse()
    rjmp        LAB_code_0008a3                 ; }



;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0008ae(void)
.org (0x08ae << 1)
fpga_data_exchange:
    eor         R16,R16
    cli
    sts         0x2006,R16                   ;= ??
    lds         R16,PORTB_OUT                   ;= ??
    sbrc        R16,0x7
    rjmp        LAB_code_0008b8
LAB_code_0008b6:
    bset        CPU_I_bp
    ret
LAB_code_0008b8:
    call        FUN_code_0011e5                ;
    bset        CPU_I_bp
    ldi         R18,0x80
    ldi         YL,0xcf
    ldi         YH,0x21
LAB_code_0008be:
    lsr         R15
    ror         R14
    ror         R13
    ror         R12
    ror         R11
    ror         R10
    ror         R9
    ror         R8
    brbs        CPU_C_bp, LAB_code_0008c9
    adiw        Y,0x2
    rjmp        LAB_code_00096b
LAB_code_0008c9:
    cli
    lds         R20,PORTE_INTCTRL               ;= ??
    sbrs        R20,0x3
    rjmp        LAB_code_0008b6
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    cpi         R18,0xb0
    brbs        CPU_C_bp, LAB_code_0008d4
    rjmp        LAB_code_00094c
LAB_code_0008d4:
    mov         R19,R18
    andi        R19,0x3
    brbc        CPU_Z_bp, LAB_code_0008f5
    ldi         R24,0x75
    cpi         R16,0x31
    cpc         R17,R24
    brbc        CPU_C_bp, LAB_code_0008e2
    ldi         R24,0x1
    cpi         R16,0x2c
    cpc         R17,R24
    brbc        CPU_C_bp, LAB_code_0008ec
    ldi         R16,0x2c
    ldi         R17,0x1
    rjmp        LAB_code_0008e4
LAB_code_0008e2:
    ldi         R16,0x30
    ldi         R17,0x75
LAB_code_0008e4:
    cli
    lds         R20,PORTE_INTCTRL               ;= ??
    sbrs        R20,0x3
    rjmp        LAB_code_0008b6
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
LAB_code_0008ec:
    st          Y+,R16
    st          Y+,R17
    movw        R20,R16
    mov         R22,R18
    andi        R22,0x3f
    lsr         R22
    lsr         R22
    rcall       dac_set_value_3                         ;undefined4 FUN_code_001053(undefined...
    rjmp        LAB_code_00096b
LAB_code_0008f5:
    cpi         R19,0x1
    brbc        CPU_Z_bp, LAB_code_000915
    ldi         R24,0x1
    cpi         R16,0xf5
    cpc         R17,R24
    brbc        CPU_S_bp,LAB_code_000902
    ldi         R24,0xfe
    cpi         R16,0xc
    cpc         R17,R24
    brbc        CPU_S_bp,LAB_code_00090c
    ldi         R16,0xc
    ldi         R17,0xfe
    rjmp        LAB_code_000904
LAB_code_000902:
    ldi         R16,0xf4
    ldi         R17,0x1
LAB_code_000904:
    cli
    lds         R20,PORTE_INTCTRL               ;= ??
    sbrs        R20,0x3
    rjmp        LAB_code_0008b6
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
LAB_code_00090c:
    st          Y+,R16
    st          Y+,R17
    movw        R20,R16
    mov         R22,R18
    andi        R22,0x3f
    lsr         R22
    lsr         R22
    rcall       dac_set_value_2                         ;undefined3 FUN_code_001076(void)
    rjmp        LAB_code_00096b
LAB_code_000915:
    cpi         R19,0x2
    brbc        CPU_Z_bp, LAB_code_000935
    ldi         R24,0x1
    cpi         R16,0xf5
    cpc         R17,R24
    brbc        CPU_S_bp,LAB_code_000922
    ldi         R24,0xfe
    cpi         R16,0xc
    cpc         R17,R24
    brbc        CPU_S_bp,LAB_code_00092c
    ldi         R16,0xc
    ldi         R17,0xfe
    rjmp        LAB_code_000924
LAB_code_000922:
    ldi         R16,0xf4
    ldi         R17,0x1
LAB_code_000924:
    cli
    lds         R20,PORTE_INTCTRL               ;= ??
    sbrs        R20,0x3
    rjmp        LAB_code_0008b6
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
LAB_code_00092c:
    st          Y+,R16
    st          Y+,R17
    movw        R20,R16
    mov         R22,R18
    andi        R22,0x3f
    lsr         R22
    lsr         R22
    rcall       dac_set_value                         ;undefined3 FUN_code_001082(void)
    rjmp        LAB_code_00096b
LAB_code_000935:
    ldi         R24,0x4e
    cpi         R16,0x21
    cpc         R17,R24
    brbs        CPU_C_bp, LAB_code_00093b
    ldi         R16,0x20
    ldi         R17,0x4e
LAB_code_00093b:
    cli
    lds         R20,PORTE_INTCTRL               ;= ??
    sbrs        R20,0x3
    rjmp        LAB_code_0008b6
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    st          Y+,R16
    st          Y+,R17
    movw        R20,R16
    mov         R22,R18
    andi        R22,0x3f
    lsr         R22
    lsr         R22
    rcall       dac_set_value_3                         ;undefined4 FUN_code_001068(undefined...
    rjmp        LAB_code_00096b
LAB_code_00094c:
    ldi         R24,0xf
    cpi         R16,0xa1
    cpc         R17,R24
    brbs        CPU_C_bp, LAB_code_00095a
    ldi         R16,0xa0
    ldi         R17,0xf
    cli
    lds         R20,PORTE_INTCTRL               ;= ??
    sbrs        R20,0x3
    rjmp        LAB_code_0008b6
    call        fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
LAB_code_00095a:
    st          Y+,R16
    st          Y+,R17
    mov         R22,R18
    andi        R22,0xf
    mov         R23,R22
    ldi         ZL,0xcf
    ldi         ZH,0x21
    add         R23,R23
    add         R23,R23
    add         R23,R23
    eor         R24,R24
    add         ZL,R23
    adc         ZH,R24
    ld          R20,Z+
    ld          R21,Z
    rcall       dac_set_value_3                         ;undefined4 FUN_code_001053(undefined...
    rjmp        LAB_code_00096b
LAB_code_00096b:
    inc         R18
    cpi         R18,0xb0
    brbc        CPU_Z_bp, LAB_code_000971
    ldi         YL,0x63
    ldi         YH,0x21
    rjmp        LAB_code_0008be
LAB_code_000971:
    cpi         R18,0xbc
    brbs        CPU_Z_bp, LAB_code_000974
    rjmp        LAB_code_0008be
LAB_code_000974:
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000975(void)
.org (0x0975 << 1)
cli_prompt_parse:
    andi        R16,0x7f                                    ;
    sts         SERIAL_RECV_MSG_LEN,R16                     ;= ??
    call        cli_get_next_char                           ;
    cpi         R16,'C'
    brbc        CPU_Z_bp, LAB_code_000984
    call        cli_get_next_char
    cpi         R16,'A'
    brbc        CPU_Z_bp, LAB_code_000981
    rjmp        alarms_clear                         ;undefined FUN_code_000df2(void)
LAB_code_000981:
    cpi         R16,'P'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_11
    rjmp        LAB_code_000a3c
LAB_code_000984:
    cpi         R16,'O'
    brbc        CPU_Z_bp, LAB_code_00098e
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'N'
    brbc        CPU_Z_bp, LAB_code_00098b
    rjmp        LAB_code_0009eb
LAB_code_00098b:
    cpi         R16,'F'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_11
    rjmp        LAB_code_000a39
LAB_code_00098e:
    cpi         R16,'P'
    brbc        CPU_Z_bp, LAB_code_00099b
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'A'
    brbc        CPU_Z_bp, LAB_code_000995
    rjmp        LAB_code_000a82
LAB_code_000995:
    cpi         R16,'C'
    brbc        CPU_Z_bp, LAB_code_000998
    rjmp        cdce62005_rst                         ;undefined FUN_code_000d1f(void)
LAB_code_000998:
    cpi         R16,'F'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_11
    rjmp        fpga_firmware_update                         ;undefined FUN_code_000ad3(void)
LAB_code_00099b:
    cpi         R16,'R'
    brbc        CPU_Z_bp, LAB_code_0009b2
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'A'
    brbc        CPU_Z_bp, LAB_code_0009a2
    rjmp        cli_send_ch_mean_amplitude                         ;undefined FUN_code_000c47(void)
LAB_code_0009a2:
    cpi         R16,'C'
    brbc        CPU_Z_bp, LAB_code_0009a5
    rjmp        channels_read                         ;undefined FUN_code_000e31(void)
LAB_code_0009a5:
    cpi         R16,'S'
    brbc        CPU_Z_bp, LAB_code_0009a8
    rjmp        cli_send_system_status                         ;undefined FUN_code_000d32(void)
LAB_code_0009a8:
    cpi         R16,'F'
    brbc        CPU_Z_bp, LAB_code_0009ab
    rjmp        cli_send_channel_cdf_adc                         ;undefined FUN_code_000e79(void)
LAB_code_0009ab:
    cpi         R16,'T'
    brbc        CPU_Z_bp, LAB_code_0009ae
    rjmp        cli_send_tdc_data                         ;undefined FUN_code_000c88(void)
LAB_code_0009ae:
    cpi         R16,'Z'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_11
    rjmp        cli_send_adc_baseline_dispersion                         ;undefined FUN_code_000c5f(void)
RETURN_WITH_SYNTAX_ERROR_MSG_11:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
LAB_code_0009b2:
    cpi         R16,'S'
    brbc        CPU_Z_bp, LAB_code_0009db
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'C'
    brbc        CPU_Z_bp, LAB_code_0009c6
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'L'
    brbc        CPU_Z_bp, LAB_code_0009bd
    rjmp        fpga_set_threshold_calibration                         ;undefined FUN_code_000f3e(void)
LAB_code_0009bd:
    cpi         R16,'S'
    brbc        CPU_Z_bp, LAB_code_0009c0
    rjmp        FUN_code_000f70                         ;undefined FUN_code_000f70(void)
LAB_code_0009c0:
    cpi         R16,'T'
    brbc        CPU_Z_bp, LAB_code_0009c3
    rjmp        fpga_set_tdc_values                         ;undefined FUN_code_000f17(void)
LAB_code_0009c3:
    cpi         R16,'R'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_1
    rjmp        fpga_set_adc_range_corr                         ;undefined FUN_code_000edb(void)
LAB_code_0009c6:
    cpi         R16,'D'
    brbc        CPU_Z_bp, LAB_code_0009c9
    rjmp        fpga_set_ch_adc_delay                         ;undefined FUN_code_000f9d(void)
LAB_code_0009c9:
    cpi         R16,'L'
    brbc        CPU_Z_bp, LAB_code_0009cc
    rjmp        fpga_set_ch_cfd_threshold                         ;undefined FUN_code_000fc7(void)
LAB_code_0009cc:
    cpi         R16,'O'
    brbc        CPU_Z_bp, LAB_code_0009cf
    rjmp        fpga_set_adc_zero                         ;undefined FUN_code_000ff6(void)
LAB_code_0009cf:
    cpi         R16,'S'
    brbc        CPU_Z_bp, LAB_code_0009d2
    rjmp        fpga_set_trg_charge_lvls                         ;undefined FUN_code_000eb1(void)
LAB_code_0009d2:
    cpi         R16,'T'
    brbc        CPU_Z_bp, LAB_code_0009d5
    rjmp        fpga_set_trg_settings                         ;undefined FUN_code_000ec9(void)
LAB_code_0009d5:
    cpi         R16,'V'
    brbc        CPU_Z_bp, LAB_code_0009d8
    rjmp        LAB_code_000a6c
LAB_code_0009d8:
    cpi         R16,'Z'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_1
    rjmp        fpga_set_ch_cfd_zero                         ;undefined FUN_code_001027(void)
LAB_code_0009db:
    cpi         R16,'W'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_1
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'R'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_1
    rjmp        eeprom_settings_save                         ;undefined FUN_code_000cd7(void)
LAB_code_0009e2:
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
RETURN_WITH_SYNTAX_ERROR_MSG_1:
    cpi         R16,0xd
    brbc        CPU_Z_bp, LAB_code_0009e2
    ldi         ZL,0x88
    ldi         ZH,0x29                                 ; Send "Syntax error"
    call        cli_send_msg
    ret
LAB_code_0009eb:
    ldi         R20,0x1
LAB_code_0009ec:
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_1
    lds         R16,0x2234                   ;= ??
    cp          R16,R20
    brbc        CPU_Z_bp, LAB_code_0009f5
    rjmp        RETURN_WITH_OK_MSG_1
LAB_code_0009f5:
    sts         0x2234,R20                   ;= ??
    lds         R16,NVM_STATUS                  ;= ??
    sbrc        R16,0x7
    rjmp        LAB_code_0009f5
    ldi         R16,0x36
    sts         NVM_CMD,R16                     ;= ??
    ldi         R16,0x1
    ldi         R17,0xd8
    cli
    sts         CPU_CCP,R17                     ;= ??
    sts         NVM_CTRLA,R16                   ;= ??
    bset        CPU_I_bp
LAB_code_000a06:
    lds         R16,NVM_STATUS                  ;= ??
    sbrc        R16,0x7
    rjmp        LAB_code_000a06
    ldi         YL,0xd1
    ldi         YH,0x10
    st          Y,R20
    ldi         R16,0x35
    sts         NVM_CMD,R16                     ;= ??
    sts         NVM_ADDR0,YL                         ;= ??
    sts         NVM_ADDR1,YH                   ;= ??
    ldi         R16,0x1
    ldi         R17,0xd8
    cli
    sts         CPU_CCP,R17                     ;= ??
    sts         NVM_CTRLA,R16                   ;= ??
    bset        CPU_I_bp
LAB_code_000a1c:
    lds         R16,NVM_STATUS                  ;= ??
    sbrc        R16,0x7
    rjmp        LAB_code_000a1c
    and         R20,R20
    brbc        CPU_Z_bp, RETURN_WITH_OK_MSG_2
    ldi         R16,0x4
    sts         PORTE_OUTCLR,R16                ;= ??
LAB_code_000a25:
    lds         R16,0x2157                   ;= ??
    sbrc        R16,0x3
    rjmp        LAB_code_000a25
    cli
    ldi         R16,0x1
    sts         0x215b,R16                   ;= ??
    ldi         R16,0xd0
    sts         0x215c,R16                   ;= ??
    ldi         R16,0x7
    sts         0x215d,R16                   ;= ??
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x1
    ldi         R16,0x41
    sts         PORTA_OUTSET,R16                ;= ??
    bset        CPU_I_bp
RETURN_WITH_OK_MSG_2:
    rjmp        RETURN_WITH_OK_MSG_1
LAB_code_000a39:
    eor         R20,R20
    rjmp        LAB_code_0009ec
RETURN_WITH_SYNTAX_ERROR_MSG_12:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
LAB_code_000a3c:
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_12
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000a43
    ret
LAB_code_000a43:
    eor         R18,R18
    cli
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    sts         TRIGGER_WINDOW,R16                   ;= ??
    ldi         YL,0xb7
    ldi         YH,0x21
LAB_code_000a4c:
    inc         R18
    cli
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    st          Y+,R16
    st          Y+,R17
    cpi         R18,0xc
    brbc        CPU_Z_bp, LAB_code_000a4c
    ldi         R18,0x24
    ldi         YL,0x87
    ldi         YH,0x21
LAB_code_000a58:
    inc         R18
    cli
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    st          Y+,R16
    st          Y+,R17
    cpi         R18,0x3c
    brbc        CPU_Z_bp, LAB_code_000a58
    inc         R18
    cli
    call        fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    sts         CFD_SAT_LVL_LOW,R16                   ;= ??
    sts         CFD_SAT_LVL_HIGH,R17                   ;= ??
    rjmp        RETURN_WITH_OK_MSG_1
RETURN_WITH_SYNTAX_ERROR_MSG_3:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
LAB_code_000a6c:
    call        cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,' '
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_3
    call        cli_get_hex                         ;undefined FUN_code_001356(void)
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_3
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_3
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000a78
    ret
LAB_code_000a78:
    sts         0x2232,R20                   ;= ??
    sts         0x2233,R21                   ;= ??
    ldi         R18,0xbd
    movw        R16,R20
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    rjmp        RETURN_WITH_OK_MSG_1
LAB_code_000a82:
    rcall       unlock_programming                         ;undefined FUN_code_000abd(void)
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_3
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         ZL,R16
    mov         R20,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         ZH,R16
    mov         R21,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         R22,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         R3,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         R4,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         R5,R16
    cpi         R22,0x2
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_3
    cp          R3,ZL
    cpc         R4,ZH
    cpc         R5,R22
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_3
    cli
    sts         CPU_RAMPZ,R22
    rcall       system_deinit                         ;undefined FUN_code_00064b(void)
    eor         R16,R16
    sts         PORTE_INTCTRL,R16               ;= ??
    sts         TCC0_INTCTRLA,R16               ;= ??
    ldi         R16,0x4
    sts         PORTE_OUTCLR,R16                ;= ??
    ldi         R16,0x43
    ldi         R17,0xd8
    sts         CPU_CCP,R17                     ;= ??
    sts         PMIC_CTRL,R16                   ;= ??
    ldi         R16,0x26
    sts         NVM_CMD,R16                     ;= ??
    ldi         R16,0x1
    ldi         R17,0xd8
    cli
    sts         CPU_CCP,R17                     ;= ??
    sts         NVM_CTRLA,R16                   ;= ??
    bset        CPU_I_bp
    ret
    ;jmp         FUN_code_010184                    ;undefined FUN_code_010184(void)
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000abd(void)
; My guess:
; Check programming key
.org (0x0abd << 1)
unlock_programming:
    call        cli_get_next_char
    cpi         R16, '\r'
    brbc        CPU_Z_bp, unlock_programming_return
    ldi         ZL,0x76
    ldi         ZH,0x2b
                    ; Address low : 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D
                    ; Data under Z: 0x78, 0x56, 0x34, 0x12, 0x98, 0xBA, 0xDC, 0xFE
unlock_programming_loop:                            ; uint8_t *data = *(0x2B76);
    lpm         R17,Z+                              ; for (int i = 0; i < 9; i++){
    call        cli_get_next_byte                   ;   uint8_t byte = cli_get_next_byte();
    cp          R16,R17                             ;   if (byte != data[i]) return;
    brbc        CPU_Z_bp, unlock_programming_return ; }
    cpi         ZL,0x7e                             ;
    brbc        CPU_Z_bp, unlock_programming_loop   ;
    ldi         ZL,0x98                             ;
    ldi         ZH,0x29                             ;
    call        cli_send_msg                        ; Send: "OK\r\n"
    clc
    ret
unlock_programming_return:
    bset        CPU_C_bp
    ret
RETURN_WITH_SYNTAX_ERROR_MSG_4:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000ad3(void)
; TODO: here
.org (0x0ad3 << 1)
fpga_firmware_update:
    rcall       unlock_programming                          ; check programming key
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_4    ; if (store_key != read_key) return with Syntax Error
    eor         R16,R16                                     ; R16 = 0
    sts         DMA_CTRL,R16                                ; Disable DMA
    rcall       take_control_over_flash_chip                ; Disable FPGA Flash chip
    eor         R16,R16                                     ; R16 = 0
    ldi         XL,0x35
    ldi         XH,0x24
    st          X+,R16                                      ; *(0x2435) = 0
    st          X+,R16                                      ; *(0x2436) = 0
    st          X+,R16                                      ; *(0x2437) = 0
    st          X,R16                                       ; *(0x2438) = 0
    rcall       flash_chip_get_RDID
    eor         R17,R17
    call        cli_send_32bit_hex                          ; Send: 0x00(MEMORY CAPACITY)
    movw        R16,R18
    call        cli_send_32bit_hex                          ; Send: 0x00(manufacturer ID)
    call        cli_send_newline

    call        cli_get_next_byte                           ;undefined FUN_code_00141b(void)
    mov         YL,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         YH,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         ZL,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         R0,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         R1,R16
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    mov         R2,R16
    movw        R20,Y
    mov         R22,ZL
LAB_code_000afd:
    rcall       FUN_code_000b88                         ;undefined FUN_code_000b88(void)
LAB_code_000afe:
    mov         R17,R0
    mov         R18,R1
    mov         R19,R2
    ldi         R16,0x1
    call        cli_send_buf                         ;undefined FUN_code_001456(void)
    sub         R17,R20
    sbc         R18,R21
    sbc         R19,R22
    subi        R17,0xff
    sbci        R18,0xff
    sbci        R19,0xff
    or          R18,R19
    brbs        CPU_Z_bp, LAB_code_000b0d
    eor         R17,R17
LAB_code_000b0d:
    lds         R24,0x2435                   ;= ??
    lds         R25,0x2436                   ;= ??
LAB_code_000b11:
    ldi         XL,0x35
    ldi         XH,0x22
    add         XL,R24
    adc         XH,R25
    call        cli_get_next_byte                         ;undefined FUN_code_00141b(void)
    st          X,R16
    adiw        R24,0x1
    andi        R25,0x1
    dec         R17
    brbc        CPU_Z_bp, LAB_code_000b11
    sts         0x2435,R24                   ;= ??
    sts         0x2436,R25                   ;= ??
    rcall       FUN_code_000b9d                         ;undefined FUN_code_000b9d(void)
    rcall       FUN_code_000b59                         ;undefined FUN_code_000b59(void)
    brbs        CPU_C_bp, LAB_code_000b27
    and         R21,R21
    brbc        CPU_Z_bp, LAB_code_000afe
    rcall       FUN_code_000b9d                         ;undefined FUN_code_000b9d(void)
    rjmp        LAB_code_000afd
LAB_code_000b27:
    rcall       FUN_code_000b9d                         ;undefined FUN_code_000b9d(void)
    rcall       FUN_code_000bb9                         ;undefined FUN_code_000bb9(undefined2...
    call        cli_send_32bit_hex                         ;undefined FUN_code_00137c(void)
    movw        R16,R18
    call        cli_send_32bit_hex                         ;undefined FUN_code_00137c(void)
    call        cli_send_newline                         ;undefined FUN_code_00140f(void)
    rcall       FUN_code_000b3f                         ;undefined FUN_code_000b3f(void)
    rjmp        RETURN_WITH_OK_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000b32(void)
.org (0x0b32 << 1)
take_control_over_flash_chip:
    ldi         R16, 1 << 1
    sts         PORTD_OUTCLR,R16                ; Set low FPGA_PROGRAM_B
    ldi         R16, 1 << 4
    sts         PORTE_OUTSET,R16                ; Disable FPGA FLASH chip
    ldi         R16,0b1011 << 4
    sts         PORTE_DIRSET,R16                ;= ??
    ldi         R16,0x50
    sts         SPIE_CTRL,R16                   ; SPI Enable, Master mode, MSB first
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000b3f(void)
.org (0x0b3f << 1)
; TODO: back here
FUN_code_000b3f:
    cli                                         ; Disable IRQ
    eor         R16,R16                         ; R16 = 0
    sts         PORTD_INTCTRL,R16               ; Disable IRQ from port D
    sts         SPIE_CTRL,R16                   ; Disable SPI on port E
    ldi         R16,0xb0                        ;
    sts         PORTE_DIRCLR,R16                ;
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x1;
    ldi         R16,0x1                         ;
    sts         PORTA_OUTSET,R16                ;
    ldi         R16,0x2                         ;
    sts         PORTD_OUTSET,R16                ;
    ldi         R16,0x88                        ;
    sts         0x215c,R16                      ;
    ldi         R16,0x13                        ;
    sts         0x215d,R16                      ;
    ldi         R16,0x4                         ;
    rcall       FPGA_reset                         ;undefined FUN_code_00054e(void)
    bset        CPU_I_bp
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000b59(void)
.org (0x0b59 << 1)
FUN_code_000b59:
    rcall       FUN_code_000b8f                         ;undefined FUN_code_000b8f(void)
    ldi         R16,0x2
    rcall       FUN_code_000c04                         ;undefined FUN_code_000c04(undefined2...
    lds         R24,0x2437                   ;= ??
    lds         R25,0x2438                   ;= ??
LAB_code_000b60:
    ldi         XL,0x35
    ldi         XH,0x22
    add         XL,R24
    adc         XH,R25
    ld          R16,X
    adiw        R24,0x1
    andi        R25,0x1
    sts         SPIE_DATA,R16                   ;= ??
LAB_code_000b69:
    lds         R19,SPIE_STATUS                 ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000b69
    cp          R0,R20
    cpc         R1,R21
    cpc         R2,R22
    brbc        CPU_Z_bp, LAB_code_000b7a
    sts         0x2437,R24                   ;= ??
    sts         0x2438,R25                   ;= ??
    ldi         R16,0x10
    sts         PORTE_OUTSET,R16                ;= ??
    bset        CPU_C_bp
    ret
LAB_code_000b7a:
    subi        R20,0xff
    sbci        R21,0xff
    sbci        R22,0xff
    and         R20,R20
    brbc        CPU_Z_bp, LAB_code_000b60
    sts         0x2437,R24                   ;= ??
    sts         0x2438,R25                   ;= ??
    ldi         R16,0x10
    sts         PORTE_OUTSET,R16                ;= ??
    clc
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000b88(void)
.org (0x0b88 << 1)
FUN_code_000b88:
    rcall       FUN_code_000b8f                         ;undefined FUN_code_000b8f(void)
    ldi         R16,0xd8
    rcall       FUN_code_000c04                         ;undefined FUN_code_000c04(undefined2...
    ldi         R16,0x10
    sts         PORTE_OUTSET,R16                ;= ??
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000b8f(void)
.org (0x0b8f << 1)
FUN_code_000b8f:
    ldi         R16,0x10
    sts         PORTE_OUTCLR,R16                ;= ??
    ldi         R16,0x6
    sts         SPIE_DATA,R16                   ;= ??
LAB_code_000b95:
    lds         R19,SPIE_STATUS                 ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000b95
    ldi         R16,0x10
    sts         PORTE_OUTSET,R16                ;= ??
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000b9d(void)
.org (0x0b9d << 1)
FUN_code_000b9d:
    ldi         R24,0x40
    ldi         R25,0x6
LAB_code_000b9f:
    sbiw        R24,0x1
    brbc        CPU_Z_bp, LAB_code_000b9f
    ldi         R16,0x10
    sts         PORTE_OUTCLR,R16                ;= ??
    ldi         R16,0x5
    sts         SPIE_DATA,R16                   ;= ??
LAB_code_000ba7:
    lds         R19,SPIE_STATUS                 ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000ba7
    sts         SPIE_DATA,R24                   ;= ??
LAB_code_000bad:
    lds         R19,SPIE_STATUS                 ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000bad
    lds         R24,SPIE_DATA                   ;= ??
    ldi         R16,0x10
    sts         PORTE_OUTSET,R16                ;= ??
    sbrc        R24,0x0
    rjmp        FUN_code_000b9d
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000bb9()
.org (0x0bb9 << 1)
FUN_code_000bb9:
    ldi         R16,0x10
    sts         PORTE_OUTCLR,R16                ;= ??
    ldi         R16,0x3
    sts         SPIE_DATA,R16                   ;= ??
    eor         R10,R10
LAB_code_000bc0:
    lds         R19,SPIE_STATUS                 ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000bc0
    sts         SPIE_DATA,ZL                   ;= ??
LAB_code_000bc6:
    lds         R19,SPIE_STATUS                 ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000bc6
    sts         SPIE_DATA,YH                   ;= ??
LAB_code_000bcc:
    lds         R19,SPIE_STATUS                 ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000bcc
    sts         SPIE_DATA,YL                   ;= ??
    ser         R16
    ser         R17
    ser         R18
    ser         R19
    ldi         R23,0xb7
    ldi         R24,0x1d
    ldi         R25,0xc1
    ldi         XL,0x4
LAB_code_000bda:
    lds         R22,SPIE_STATUS             ;= ??
    sbrs        R22,0x7
    rjmp        LAB_code_000bda
    sts         SPIE_DATA,R10                   ;= ??
LAB_code_000be0:
    lds         R22,SPIE_STATUS             ;= ??
    sbrs        R22,0x7
    rjmp        LAB_code_000be0
    lds         R22,SPIE_DATA               ;= ??
    cp          R0,YL
    cpc         R1,YH
    cpc         R2,ZL
    brbs        CPU_Z_bp, LAB_code_000bf0
    sts         SPIE_DATA,R10                   ;= ??
    rcall       FUN_code_000bf2                         ;undefined FUN_code_000bf2(undefined2...
    adiw        Y,0x1
    adc         ZL,R10
    rjmp        LAB_code_000be0
LAB_code_000bf0:
    rcall       FUN_code_000bf2                         ;undefined FUN_code_000bf2(undefined2...
    rjmp        RETURN_WITH_DISABLE_FLASH_CHIP_SELECT
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000bf2()
.org (0x0bf2 << 1)
FUN_code_000bf2:
    ldi         R20,0x8
LAB_code_000bf3:
    add         R18,R18
    adc         R19,R19
    adc         R16,R16
    adc         R17,R17
    brbc        CPU_C_bp, LAB_code_000bfb
    lsr         R22
    brbs        CPU_C_bp, LAB_code_000c01
    rjmp        LAB_code_000bfd
LAB_code_000bfb:
    lsr         R22
    brbc        CPU_C_bp, LAB_code_000c01
LAB_code_000bfd:
    eor         R18,R23
    eor         R19,R24
    eor         R16,R25
    eor         R17,XL
LAB_code_000c01:
    dec         R20
    brbc        CPU_Z_bp, LAB_code_000bf3
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000c04()
.org (0x0c04 << 1)
FUN_code_000c04:
    ldi         R17,0x10
    sts         PORTE_OUTCLR,R17                ;= ??
    sts         SPIE_DATA,R16
LAB_code_000c09:
    lds         R19,SPIE_STATUS             ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000c09
    sts         SPIE_DATA,R22
LAB_code_000c0f:
    lds         R19,SPIE_STATUS             ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000c0f
    sts         SPIE_DATA,R21
LAB_code_000c15:
    lds         R19,SPIE_STATUS             ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000c15
    sts         SPIE_DATA,R20
LAB_code_000c1b:
    lds         R19,SPIE_STATUS             ;= ??
    sbrs        R19,0x7
    rjmp        LAB_code_000c1b
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
; Parameters:
; out R18 -- manufacturer ID
; out R19 -- Memory interface typ
; out R16 -- Memory Capacity (2^R16 bit)
.org (0x0c20 << 1)
flash_chip_get_RDID:
    ldi         R16,0x10                        ;
    sts         PORTE_OUTCLR,R16                ; Enable FPGA Flash
    ldi         R16,0x9f                        ; Flash RDIF address
    sts         SPIE_DATA,R16                   ;
    eor         R20,R20                         ;
LAB_code_000c27:
    lds         R19,SPIE_STATUS                 ;
    sbrs        R19,0x7
    rjmp        LAB_code_000c27

    sts         SPIE_DATA,R20                   ; Send 0 - read data
flash_chip_get_RDID_read_1:
    lds         R19,SPIE_STATUS
    sbrs        R19,0x7
    rjmp        flash_chip_get_RDID_read_1
    lds         R18,SPIE_DATA                   ; Read manufacturer ID

    sts         SPIE_DATA,R20
flash_chip_get_RDID_read_2:
    lds         R19,SPIE_STATUS
    sbrs        R19,0x7
    rjmp        flash_chip_get_RDID_read_2
    lds         R19,SPIE_DATA                   ; Read: memory type

    sts         SPIE_DATA,R20
flash_chip_get_RDID_read_3:
    lds         R20,SPIE_STATUS
    sbrs        R20,0x7
    rjmp        flash_chip_get_RDID_read_3
    lds         R16,SPIE_DATA                   ; Read: capacity

RETURN_WITH_DISABLE_FLASH_CHIP_SELECT:
    ldi         R20,0x10
    sts         PORTE_OUTSET,R20
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000c47(void)
.org (0x0c47 << 1)
cli_send_ch_mean_amplitude:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SUNTAX_ERROR_MSG_5
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000c4d
    ret
LAB_code_000c4d:
    ldi         R18,0x64
LAB_code_000c4e:
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    ldi         R16,0x20
    call        cli_send_buf                         ;undefined FUN_code_001456(void)
    inc         R18
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    rcall       cli_send_newline                         ;undefined FUN_code_00140f(void)
    inc         R18
    cpi         R18,0x7c
    brbs        CPU_C_bp, LAB_code_000c4e
    rjmp        RETURN_WITH_OK_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000c5f(void)
.org (0x0c5f << 1)
cli_send_adc_baseline_dispersion:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SUNTAX_ERROR_MSG_5
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000c65
    ret
LAB_code_000c65:
    eor         R19,R19
LAB_code_000c66:
    ldi         R18,0xd
    add         R18,R19
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    inc         R18
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    ldi         R18,0x4c
    add         R18,R19
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    inc         R18
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    rcall       cli_send_newline                         ;undefined FUN_code_00140f(void)
    subi        R19,0xfe
    cpi         R19,0x18
    brbs        CPU_C_bp, LAB_code_000c66
    rjmp        RETURN_WITH_OK_MSG_1
RETURN_WITH_SUNTAX_ERROR_MSG_5:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000c88(void)
.org (0x0c88 << 1)
cli_send_tdc_data:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SUNTAX_ERROR_MSG_5
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000c8e
    ret
LAB_code_000c8e:
    ldi         R18,0x3e
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    mov         R20,R17
    eor         R17,R17
    sbrc        R16,0x7
    com         R17
    rcall       cli_send_int16                         ;undefined FUN_code_0013a3(void)
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    mov         R16,R20
    eor         R17,R17
    sbrc        R16,0x7
    com         R17
    rcall       cli_send_int16                         ;undefined FUN_code_0013a3(void)
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    ldi         R18,0x3f
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    eor         R17,R17
    sbrc        R16,0x7
    com         R17
    rcall       cli_send_int16                         ;undefined FUN_code_0013a3(void)
    rcall       cli_send_newline                         ;undefined FUN_code_00140f(void)
    ldi         YL,0x7b
    ldi         YH,0x21
    eor         R23,R23
LAB_code_000cac:
    ldi         R18,0x40
    add         R18,R23
    cli
    rcall       fpga_msg_read_t1                         ;undefined FUN_code_0011b4(undefined2...
    bset        CPU_I_bp
    rcall       cli_send_32bit_hex                         ;undefined FUN_code_00137c(void)
    cpi         R16,0x60
    brbs        CPU_S_bp,LAB_code_000cb7
    sbrs        R17,0x0
    subi        R17,0x2
    rjmp        LAB_code_000cbb
LAB_code_000cb7:
    cpi         R16,0x10
    brbc        CPU_C_bp, LAB_code_000cbb
    sbrc        R17,0x0
    subi        R17,0xfe
LAB_code_000cbb:
    asr         R17
    asr         R17
    brbc        CPU_C_bp, LAB_code_000cbf
    ori         R16,0x80
LAB_code_000cbf:
    push        R16
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    pop         R16
    rcall       cli_send_int16                         ;undefined FUN_code_0013a3(void)
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    eor         R24,R24
    ld          R16,Y+
    add         R16,R16
    asr         R16
    eor         R17,R17
    sbrc        R16,0x7
    com         R17
    rcall       cli_send_int16                         ;undefined FUN_code_0013a3(void)
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    rcall       cli_send_newline                         ;undefined FUN_code_00140f(void)
    inc         R23
    cpi         R23,0xc
    brbs        CPU_S_bp,LAB_code_000cac
    rcall       cli_send_newline                         ;undefined FUN_code_00140f(void)
    rjmp        RETURN_WITH_OK_MSG_1
RETURN_WITH_SYNTAX_ERROR_MSG_6:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000cd7(void)
.org (0x0cd7 << 1)
eeprom_settings_save:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_6
LAB_code_000cda:
    lds         R16,NVM_STATUS                  ;= ??
    sbrc        R16,0x7
    rjmp        LAB_code_000cda
    ldi         R16,0x36
    sts         NVM_CMD,R16                     ;= ??
    ldi         R16,0x1
    ldi         R17,0xd8
    cli
    sts         CPU_CCP,R17                     ;= ??
    sts         NVM_CTRLA,R16                   ;= ??
    bset        CPU_I_bp
    ldi         ZL,0x63
    ldi         ZH,0x21
    ser         YL
    ldi         YH,0xf
    ldi         R20,0x22
LAB_code_000cee:
    lds         R16,NVM_STATUS                  ;= ??
    sbrc        R16,0x7
    rjmp        LAB_code_000cee
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x3
    eor         R19,R19
LAB_code_000cf4:
    adiw        Y,0x1
    ld          R16,Z+
    ld          R17,Y
    eor         R17,R16
    brbs        CPU_Z_bp, LAB_code_000cfb
    st          Y,R16
    ldi         R19,0x1
LAB_code_000cfb:
    cpi         ZL,0x35
    cpc         ZH,R20
    brbs        CPU_Z_bp, LAB_code_000d04
    mov         R18,YL
    andi        R18,0x1f
    cpi         R18,0x1f
    brbc        CPU_Z_bp, LAB_code_000cf4
    rcall       FUN_code_000d07                         ;undefined FUN_code_000d07(void)
    rjmp        LAB_code_000cf4
LAB_code_000d04:
    rcall       FUN_code_000d07                         ;undefined FUN_code_000d07(void)
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x3
    rjmp        RETURN_WITH_OK_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000d07(void)
.org (0x0d07 << 1)
FUN_code_000d07:
    and         R19,R19
    brbs        CPU_Z_bp, LAB_code_000d1d
    ldi         R16,0x35
    sts         NVM_CMD,R16                     ;= ??
    sts         NVM_ADDR0,YL                         ;= ??
    sts         NVM_ADDR1,YH                   ;= ??
    ldi         R16,0x1
    ldi         R17,0xd8
    cli
    sts         CPU_CCP,R17                     ;= ??
    sts         NVM_CTRLA,R16                   ;= ??
    bset        CPU_I_bp
LAB_code_000d18:
    lds         R16,NVM_STATUS                  ;= ??
    sbrc        R16,0x7
    rjmp        LAB_code_000d18
    eor         R19,R19
LAB_code_000d1d:
    ret
RETURN_WITH_SYNTAX_ERROR_MSG_7:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000d1f(void)
.org (0x0d1f << 1)
cdce62005_rst:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_7
    ldi         ZL,0x3e
    ldi         ZH,0x29
    ldi         R20,0x9
    cli
LAB_code_000d26:
    lpm         R16,Z+
    lpm         R17,Z+
    lpm         R18,Z+
    lpm         R19,Z+
    rcall       CDCE62005_send_control_settings                         ;undefined FUN_code_001243(void)
    dec         R20
    brbc        CPU_Z_bp, LAB_code_000d26
    bset        CPU_I_bp
    ldi         ZL,0x98
    ldi         ZH,0x29
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000d32(void)
.org (0x0d32 << 1)
cli_send_system_status:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_7
    ldi         ZL,0x6a
    ldi         ZH,0x2b
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    lds         R16,0x2232                   ;= ??
    lds         R17,0x2233                   ;= ??
    rcall       cli_send_32bit_hex                         ;undefined FUN_code_00137c(void)
    ldi         ZL,0x7e
    ldi         ZH,0x2b
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x92
    ldi         ZH,0x2b
    lpm         R18,Z+
    lpm         R19,Z+
    lpm         R16,Z+
    lpm         R17,Z+
    rcall       cli_send_32bit_hex                         ;undefined FUN_code_00137c(void)
    movw        R16,R18
    rcall       cli_send_32bit_hex                         ;undefined FUN_code_00137c(void)
    ldi         ZL,0xa6
    ldi         ZH,0x29
    rcall       cli_send_msg                    ; send: "External power source: "
    cli
    lds         R18,0x2157                   ;= ??
    lds         R16,0x2160                   ;= ??
    lds         R17,0x2161                   ;= ??
    lds         R20,PORTE_IN                    ;= ??
    bset        CPU_I_bp
    ldi         ZL,0x98
    ldi         ZH,0x29
    sbrc        R18,0x0
    rjmp        LAB_code_000d5c
    ldi         ZL,0x9e
    ldi         ZH,0x29
LAB_code_000d5c:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    mov         R19,R18
    ldi         ZL,0xc0
    ldi         ZH,0x29
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    rcall       cli_send_temperature                         ;undefined FUN_code_00139b(void)
    ldi         ZL,0xce
    ldi         ZH,0x29
    andi        R19,0x6
    brbs        CPU_Z_bp, LAB_code_000d70
    ldi         ZL,0xe2
    ldi         ZH,0x29
    cpi         R19,0x6
    brbs        CPU_Z_bp, LAB_code_000d70
    ldi         ZL,0xdc
    ldi         ZH,0x29
    andi        R19,0x4
    brbc        CPU_Z_bp, LAB_code_000d70
    ldi         ZL,0xd6
    ldi         ZH,0x29
LAB_code_000d70:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0xec
    ldi         ZH,0x29
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    sbrc        R20,0x2
    rjmp        LAB_code_000d7a
    ldi         ZL,0x2
    ldi         ZH,0x2a
LAB_code_000d78:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ret
LAB_code_000d7a:
    ldi         ZL,0xfc
    ldi         ZH,0x29
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x98
    ldi         ZH,0x29
    sbrc        R18,0x3
    rjmp        LAB_code_000d89
    ldi         ZL,0x9e
    ldi         ZH,0x29
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    sbrs        R18,0x6
    ret
    ldi         ZL,0xf2
    ldi         ZH,0x2a
    rjmp        LAB_code_000d78
LAB_code_000d89:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x28
    ldi         ZH,0x2a
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    lds         R19,0x2162                   ;= ??
    ldi         ZL,0x36
    ldi         ZH,0x2a
    sbrc        R19,0x1
    rjmp        LAB_code_000d99
    ldi         ZL,0x3e
    ldi         ZH,0x2a
    sbrc        R19,0x2
    rjmp        LAB_code_000d99
    ldi         ZL,0x48
    ldi         ZH,0x2a
LAB_code_000d99:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x52
    ldi         ZH,0x2a
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x5a
    ldi         ZH,0x2a
    sbrs        R19,0x0
    rjmp        LAB_code_000da3
    ldi         ZL,0x5e
    ldi         ZH,0x2a
LAB_code_000da3:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x4
    ldi         ZH,0x2b
    sbrc        R18,0x4
    rjmp        LAB_code_000dab
    ldi         ZL,0xb4
    ldi         ZH,0x2a
    rjmp        LAB_code_000d78
LAB_code_000dab:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x12
    ldi         ZH,0x2b
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x98
    ldi         ZH,0x29
    sbrs        R18,0x7
    rjmp        LAB_code_000dc9
    ldi         ZL,0x20
    ldi         ZH,0x2b
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    lds         R20,0x2158                   ;= ??
    eor         R17,R17
LAB_code_000db9:
    sbrs        R20,0x2
    rjmp        LAB_code_000dc4
    ldi         ZL,0x28
    ldi         ZH,0x2b
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         R16,0x30
    add         R16,R17
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    ldi         ZL,0x2e
    ldi         ZH,0x2b
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
LAB_code_000dc4:
    cpi         R17,0x2
    brbc        CPU_C_bp, LAB_code_000df1
    inc         R17
    lsr         R20
    rjmp        LAB_code_000db9
LAB_code_000dc9:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x96
    ldi         ZH,0x2b
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    lds         R20,0x2441                   ;= ??
    add         R20,R20
    ldi         ZL,0xa8
    ldi         ZH,0x2b
    eor         R21,R21
    add         ZL,R20
    adc         ZH,R21
    lpm         R20,Z+
    lpm         R21,Z
    movw        Z,R20
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x84
    ldi         ZH,0x29
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    lds         R20,0x2158                   ;= ??
    ldi         ZL,0x44
    ldi         ZH,0x2b
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x2
    ldi         ZH,0x2a
    sbrc        R20,0x0
    rjmp        LAB_code_000de7
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ret
LAB_code_000de7:
    ldi         ZL,0xfc
    ldi         ZH,0x29
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         ZL,0x4e
    ldi         ZH,0x2b
    sbrs        R20,0x1
    rjmp        LAB_code_000df0
    ldi         ZL,0x5c
    ldi         ZH,0x2b
LAB_code_000df0:
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
LAB_code_000df1:
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000df2(void)
.org (0x0df2 << 1)
alarms_clear:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_8
    cli
    lds         R16,0x2157                   ;= ??
    in          R17,UPDATE_ERROR_STATUS_REGISTER
    andi        R17,0x3
    brbc        CPU_Z_bp, LAB_code_000e0c
    lds         R16,0x2157                   ;= ??
    andi        R16,0x7f
    sts         0x2157,R16                   ;= ??
    lds         R16,0x2158                   ;= ??
    andi        R16,0xe1
    sts         0x2158,R16                   ;= ??
    bset        CPU_I_bp
    ldi         R16,0x40
    sts         PORTA_OUTSET,R16                ;= ??
    ldi         ZL,0x08
    ldi         ZH,0x2a
    rjmp        alarm_send_msg              ; Send msg "No alarm, error flags cleared\r\n"
LAB_code_000e0c:
    andi        R16,0x7
    cpi         R16,0x1
    brbs        CPU_Z_bp, LAB_code_000e13
    bset        CPU_I_bp
    ldi         ZL,0x9e
    ldi         ZH,0x29
    rjmp        alarm_send_msg              ; Send msg "FAIL"
LAB_code_000e13:
    lds         R16,0x2157                   ;= ??
    andi        R16,0x1f
    sts         0x2157,R16                   ;= ??
    eor         R16,R16
    sts         0x2158,R16                   ;= ??
    ldi         R16,0x1
    sts         0x215b,R16                   ;= ??
    ldi         R16,0x4
    sts         PORTE_OUTCLR,R16                ;= ??
    ldi         R16,0xd0
    sts         0x215c,R16                   ;= ??
    ldi         R16,0x7
    sts         0x215d,R16                   ;= ??
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x1
    ldi         R16,0x41
    sts         PORTA_OUTSET,R16                ;= ??
    bset        CPU_I_bp
    ldi         ZL,0x98
    ldi         ZH,0x29                     ; Send msg "OK\r\n"
alarm_send_msg:
    rcall       cli_send_msg
    ret
RETURN_WITH_SYNTAX_ERROR_MSG_8:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000e31(void)
.org (0x0e31 << 1)
channels_read:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_8
    eor         R20,R20
    eor         R21,R21
LAB_code_000e36:
    ldi         ZL,0xc6
    ldi         ZH,0x2a
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    mov         R16,R20
    eor         R17,R17
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         YL,0x63
    ldi         YH,0x21
    mov         R22,R20
    add         R22,R22
    add         YL,R22
    adc         YH,R21
    ld          R16,Y+
    ld          R17,Y
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    mov         R23,R20
    andi        R23,0x3
    ldi         R24,0x20
    mul         R23,R24
    ldi         R16,0xc
    add         R16,R0
    mov         R19,R20
    lsr         R19
    lsr         R19
    cli
    rcall       ths788_read                         ;undefined5 FUN_code_001104(undefined...
    bset        CPU_I_bp
    mov         R16,R17
    eor         R17,R17
    sbrc        R16,0x7
    ser         R17
    rcall       cli_send_int16                         ;undefined FUN_code_0013a3(void)
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         YL,0xb7
    ldi         YH,0x21
    mov         R22,R20
    add         R22,R22
    add         YL,R22
    adc         YH,R21
    ld          R16,Y+
    ld          R17,Y+
    rcall       cli_send_int16                         ;undefined FUN_code_0013a3(void)
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ldi         YL,0x87
    ldi         YH,0x21
    mov         R22,R20
    add         R22,R22
    add         R22,R22
    add         YL,R22
    adc         YH,R21
    ld          R16,Y+
    ld          R17,Y+
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    ldi         R16,0x20
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    ld          R16,Y+
    ld          R17,Y
    rcall       cli_send_uint16                         ;undefined FUN_code_0013a7(void)
    rcall       cli_send_newline                         ;undefined FUN_code_00140f(void)
    inc         R20
    cpi         R20,0xc
    brbs        CPU_Z_bp, LAB_code_000e77
    rjmp        LAB_code_000e36
LAB_code_000e77:
    ret
RETURN_WITH_SYNTAX_ERROR_MSG_9:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000e79(void)
.org (0x0e79 << 1)
cli_send_channel_cdf_adc:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,'\r'
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_9
    ldi         YL,0xcf
    ldi         YH,0x21
    eor         R20,R20
cli_send_chanel_parameters_loop:
    ldi         ZL,0x68
    ldi         ZH,0x2a                             ; Z = CHANNEL_PARAMETERS
    rcall       cli_send_msg                        ; Send: "CH:"
    mov         R16,R20                             ;
    eor         R17,R17
    rcall       cli_send_uint16                     ; Send: int(R20) -- channel number

    rcall       cli_send_msg                        ; Send: " Threshold:"
    cli
    ld          R16,Y+                              ;
    ld          R17,Y+
    bset        CPU_I_bp
    rcall       cli_send_float_round_2                         ;undefined FUN_code_001397(void)

    rcall       cli_send_msg                         ;Send: " Shift:"
    cli
    ld          R16,Y+
    ld          R17,Y+
    bset        CPU_I_bp
    rcall       cli_send_float_round_2                         ;undefined FUN_code_001397(void)

    rcall       cli_send_msg                         ;Send: " Zero offs:"
    cli
    ld          R16,Y+
    ld          R17,Y+
    bset        CPU_I_bp
    rcall       cli_send_float_round_2                         ;undefined FUN_code_001397(void)

    rcall       cli_send_msg                         ;Send: " Delay:"
    cli
    ld          R16,Y+
    ld          R17,Y+
    bset        CPU_I_bp
    rcall       cli_send_delay
    rcall       cli_send_newline

    inc         R20
    cpi         R20,12
    brbc        CPU_Z_bp, cli_send_chanel_parameters_loop
    ldi         ZL,0x92
    ldi         ZH,0x2a
    rcall       cli_send_msg                        ; Send: "Trigger window: "
    lds         R16,TRIGGER_WINDOW
    eor         R17,R17                             ;
    rcall       cli_send_uint16                     ;

    rcall       cli_send_msg                        ; Send: "CFD sat. level:"
    lds         R16,CFD_SAT_LVL_LOW
    lds         R17,CFD_SAT_LVL_HIGH
    rcall       cli_send_uint16
    rcall       cli_send_newline
    ret
RETURN_WITH_SYNTAX_ERROR_MSG_13:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000eb1(void)
.org (0x0eb1 << 1)
fpga_set_trg_charge_lvls:
    rcall       cli_get_next_char
    cpi         R16,' '
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_13
    rcall       cli_get_integer
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_9
    and         R21,R21
    brbs        CPU_N_bp, RETURN_WITH_SYNTAX_ERROR_MSG_9
    ldi         R26,0x10
    cpi         R20,0x0
    cpc         R21,R26
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_13
    rcall       check_fpga_is_ready
    brbc        CPU_C_bp, LAB_code_000ebf
    ret
LAB_code_000ebf:
    sts         CFD_SAT_LVL_LOW,R20                   ;= ??
    sts         CFD_SAT_LVL_HIGH,R21                   ;= ??
    ldi         R18,0x3d
    movw        R16,R20
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    rjmp        RETURN_WITH_OK_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000ec9(void)
.org (0x0ec9 << 1)
fpga_set_trg_settings:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    cpi         R16,' '
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_13
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_13
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_13
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000ed3
    ret
LAB_code_000ed3:
    sts         TRIGGER_WINDOW,R20                   ;= ??
    ldi         R18,0x0
    movw        R16,R20
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    rjmp        RETURN_WITH_OK_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000edb(void)
.org (0x0edb << 1)
fpga_set_adc_range_corr:
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_14
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_14
    cpi         R20,0xc
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_14
    mov         R22,R20
    cpi         R16,0x20
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_14
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_14
    cpi         R16,0x2c
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_14
    movw        R24,R20
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_14
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_14
    ldi         XL,0xc
    cpi         R20,0x0
    cpc         R21,XL
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_14
    cpi         R24,0x0
    cpc         R25,XL
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_14
    ldi         XL,0x5
    cpi         R20,0x55
    cpc         R21,XL
    brbs        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_14
    cpi         R24,0x55
    cpc         R25,XL
    brbs        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_14
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000efe
    ret
LAB_code_000efe:
    ldi         YL,0x87
    ldi         YH,0x21
    add         R22,R22
    mov         R23,R22
    add         R23,R23
    eor         R11,R11
    add         YL,R23
    adc         YH,R11
    st          Y+,R24
    st          Y+,R25
    st          Y+,R20
    st          Y,R21
    ldi         R18,0x25
    add         R18,R22
    movw        R16,R24
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    inc         R18
    movw        R16,R20
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    rjmp        RETURN_WITH_OK_MSG_1
RETURN_WITH_SYNTAX_ERROR_MSG_14:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000f17(void)
.org (0x0f17 << 1)
fpga_set_tdc_values:
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    cpi         R20,0xc
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_15
    mov         R22,R20
    cpi         R16,0x20
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    and         R21,R21
    brbs        CPU_N_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    ldi         R24,0x10
    cpi         R20,0x0
    cpc         R21,R24
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_15
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000f2d
    ret
LAB_code_000f2d:
    ldi         YL,0xb7
    ldi         YH,0x21
    mov         R23,R22
    add         R23,R23
    eor         R11,R11
    add         YL,R23
    adc         YH,R11
    st          Y+,R20
    st          Y,R21
    ldi         R18,0x1
    add         R18,R22
    movw        R16,R20
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    rjmp        RETURN_WITH_OK_MSG_1
RETURN_WITH_SYNTAX_ERROR_MSG_15:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000f3e(void)
.org (0x0f3e << 1)
fpga_set_threshold_calibration:
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    cpi         R20,0xc
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_15
    mov         R22,R20
    cpi         R16,0x20
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    and         R21,R21
    brbs        CPU_N_bp, RETURN_WITH_SYNTAX_ERROR_MSG_15
    ldi         R24,0xf
    cpi         R20,0xa1
    cpc         R21,R24
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_15
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000f54
    ret
LAB_code_000f54:
    movw        R16,R20
    ldi         R18,0xb0
    add         R18,R22
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    ldi         YL,0x63
    ldi         YH,0x21
    mov         R23,R22
    add         R23,R23
    eor         R11,R11
    add         YL,R23
    adc         YH,R11
    st          Y+,R20
    st          Y,R21
    ldi         YL,0xcf
    ldi         YH,0x21
    mov         R10,R22
    add         R10,R10
    add         R10,R10
    add         R10,R10
    eor         R11,R11
    add         YL,R10
    adc         YH,R11
    ld          R20,Y+
    ld          R21,Y
    rcall       dac_set_value_3                         ;undefined4 FUN_code_001053(undefined...
    rjmp        RETURN_WITH_OK_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000f70(void)
.org (0x0f70 << 1)
FUN_code_000f70:
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    cpi         R20,0xc
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_16
    mov         R19,R20
    cpi         R16,0x20
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    ldi         R24,0x0
    cpi         R20,0x40
    cpc         R21,R24
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_16
    ser         R24
    cpi         R20,0xc0
    cpc         R21,R24
    brbs        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_16
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000f88
    ret
LAB_code_000f88:
    ldi         YL,0x7b
    ldi         YH,0x21
    eor         R11,R11
    add         YL,R19
    adc         YH,R11
    st          Y,R20
    mov         R21,R19
    andi        R21,0x3
    ldi         R22,0x20
    mul         R21,R22
    ldi         R16,0xc
    add         R16,R0
    lsr         R19
    lsr         R19
    mov         R17,R20
    eor         R18,R18
    cli
    rcall       ths788_write                         ;undefined5 FUN_code_0010ba(undefined...
    bset        CPU_I_bp
    rjmp        RETURN_WITH_OK_MSG_1
RETURN_WITH_SYNTAX_ERROR_MSG_16:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000f9d(void)
.org (0x0f9d << 1)
fpga_set_ch_adc_delay:
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    cpi         R20,0xc
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_16
    mov         R22,R20
    cpi         R16,0x20
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    and         R21,R21
    brbs        CPU_N_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    ldi         R24,0x4e
    cpi         R20,0x21
    cpc         R21,R24
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_16
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000fb3
    ret
LAB_code_000fb3:
    movw        R16,R20
    mov         R23,R22
    add         R23,R23
    add         R23,R23
    ldi         R18,0x83
    add         R18,R23
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    ldi         YL,0xcf
    ldi         YH,0x21
    add         R23,R23
    subi        R23,0xfa
    eor         R11,R11
    add         YL,R23
    adc         YH,R11
    st          Y+,R20
    st          Y,R21
    rcall       dac_set_value_3                         ;undefined4 FUN_code_001068(undefined...
    rjmp        RETURN_WITH_OK_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000fc7(void)
.org (0x0fc7 << 1)
fpga_set_ch_cfd_threshold:
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    cpi         R20,0xc
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_16
    mov         R22,R20
    cpi         R16,0x20
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_16
    ldi         R24,0x75
    cpi         R20,0x31
    cpc         R21,R24
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_16
    ldi         R24,0x1
    cpi         R20,0x2c
    cpc         R21,R24
    brbs        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_16
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_000fdf
    ret
LAB_code_000fdf:
    movw        R16,R20
    mov         R10,R22
    add         R10,R10
    add         R10,R10
    ldi         R18,0x80
    add         R18,R10
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    ldi         YL,0xcf
    ldi         YH,0x21
    add         R10,R10
    eor         R11,R11
    add         YL,R10
    adc         YH,R11
    st          Y+,R20
    st          Y,R21
    rcall       dac_set_value_3                         ;undefined4 FUN_code_001053(undefined...
RETURN_WITH_OK_MSG_1:
    ldi         ZL,0x98
    ldi         ZH,0x29                             ; Send: "OK\n\r"
    rcall       cli_send_msg                         ;undefined FUN_code_001413(void)
    ret
RETURN_WITH_SYNTAX_ERROR_MSG_10:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_000ff6(void)
.org (0x0ff6 << 1)
fpga_set_adc_zero:
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    cpi         R20,0xc
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_10
    mov         R22,R20
    cpi         R16,0x20
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    ldi         R24,0x1
    cpi         R20,0xf5
    cpc         R21,R24
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_10
    ldi         R24,0xfe
    cpi         R20,0xc
    cpc         R21,R24
    brbs        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_10
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_00100e
    ret
LAB_code_00100e:
    sbi         UPDATE_ERROR_STATUS_REGISTER,0x3
    movw        R16,R20
    mov         R23,R22
    add         R23,R23
    add         R23,R23
    ldi         R18,0x82
    add         R18,R23
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    ldi         YL,0xcf
    ldi         YH,0x21
    add         R23,R23
    subi        R23,0xfc
    eor         R11,R11
    add         YL,R23
    adc         YH,R11
    cli
    st          Y+,R20
    st          Y,R21
    bset        CPU_I_bp
    rcall       dac_set_value                         ;undefined3 FUN_code_001082(void)
    cbi         UPDATE_ERROR_STATUS_REGISTER,0x3
    rjmp        RETURN_WITH_OK_MSG_1
RETURN_WITH_SYNTAX_ERROR_MSG_2:
    rjmp        RETURN_WITH_SYNTAX_ERROR_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001027(void)
.org (0x1027 << 1)
fpga_set_ch_cfd_zero:
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    and         R21,R21
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    cpi         R20,0xc
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_10
    mov         R22,R20
    cpi         R16,0x20
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    rcall       cli_get_integer                         ;undefined5 FUN_code_00131a(undefined...
    brbs        CPU_C_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    cpi         R16,0xd
    brbc        CPU_Z_bp, RETURN_WITH_SYNTAX_ERROR_MSG_10
    ldi         R24,0x1
    cpi         R20,0xf5
    cpc         R21,R24
    brbc        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_2
    ldi         R24,0xfe
    cpi         R20,0xc
    cpc         R21,R24
    brbs        CPU_S_bp,RETURN_WITH_SYNTAX_ERROR_MSG_2
    rcall       check_fpga_is_ready                         ;undefined FUN_code_00108e(void)
    brbc        CPU_C_bp, LAB_code_00103f
    ret
LAB_code_00103f:
    movw        R16,R20
    mov         R23,R22
    add         R23,R23
    add         R23,R23
    ldi         R18,0x81
    add         R18,R23
    cli
    rcall       fpga_msg_send_t2                         ;undefined FUN_code_001187(void)
    bset        CPU_I_bp
    ldi         YL,0xcf
    ldi         YH,0x21
    add         R23,R23
    subi        R23,0xfe
    eor         R11,R11
    add         YL,R23
    adc         YH,R11
    st          Y+,R20
    st          Y,R21
    rcall       dac_set_value_2                         ;undefined3 FUN_code_001076(void)
    rjmp        RETURN_WITH_OK_MSG_1
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined4 FUN_code_001053()
.org (0x1053 << 1)
dac_set_value_3:
    push        R18
    ldi         R18,0xc
    ldi         R19,0x2
    rcall       calculate_parameters_for_dac_2                         ;undefined FUN_code_0010a6(undefined2...
    ldi         ZL,0x63
    ldi         ZH,0x21
    eor         R20,R20
    add         R22,R22
    add         ZL,R22
    adc         ZH,R20
    add         R22,R22
    ori         R22,0x3
    ld          R20,Z+
    ld             R21,Z
    add         R16,R20
    adc         R17,R21
    com         R16
    com         R17
    rcall       dac_send_value                         ;undefined3 FUN_code_001155(undefined...
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined4 FUN_code_001068()
.org (0x1068 << 1)
dac_set_value_3:
    push        R18
    ldi         R18,0x20
    ldi         R19,0x4e
    sub         R18,R20                                 ; 0x20 - R20
    sbc         R19,R21                                 ; 0x4E - R21 - C
    movw        R20,R18                                 ; R20 = R18, R21 = R19
    ldi         R18,0x72                                ; R18 = 0x72
    ldi         R19,0x2                                 ; R19 = 0x02
    rcall       calculate_parameters_for_dac_2                         ;undefined FUN_code_0010a6(undefined2...
    add         R22,R22                                 ;
    add         R22,R22                                 ;
    rcall       dac_send_value                          ;undefined3 FUN_code_001155(undefined...
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined3 FUN_code_001076(void)
.org (0x1076 << 1)
dac_set_value_2:
    push        R18
    ldi         R18,0x88
    ldi         R19,0x41
    rcall       calculate_parameters_for_dac                         ;undefined FUN_code_001098(void)
    ldi         R18,0x80
    eor         R17,R18
    add         R22,R22
    add         R22,R22
    ori         R22,0x2
    rcall       dac_send_value                         ;undefined3 FUN_code_001155(undefined...
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined3 FUN_code_001082(void)
.org (0x1082 << 1)
dac_set_value:
    push        R18
    ldi         R18,0x88
    ldi         R19,0x41
    rcall       calculate_parameters_for_dac                         ;undefined FUN_code_001098(void)
    ldi         R18,0x80
    eor         R17,R18
    add         R22,R22
    add         R22,R22
    ori         R22,0x1
    rcall       dac_send_value                         ;undefined3 FUN_code_001155(undefined...
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
; int check_fpga_ready(){
;   if (POWER_NOK_bm && (1 << 4)){
;       return 0;
;   }
;
;   cli_send_msg("FPGA is not ready!\n\r");
;   return 1;
; }
.org (0x108e << 1)
check_fpga_is_ready:
    clc
    lds         R16,0x2157                          ; if (POWER_NOK_bm && (1 << 4)) {
    sbrc        R16, 4                              ;   return;
    ret                                             ; }
    ldi         ZL,0xb4
    ldi         ZH,0x2a                             ; Send: "FPGA is not ready!\n\r"
    rcall       cli_send_msg
    bset        CPU_C_bp
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001098(void)
.org (0x1098 << 1)
; Uknown
; Inputs:
;   R18 - unsigned int = 0x81
;   R19 - unsigned int = 0x41
;   R20 -
;   R21 - signed int
;   R0  -
;   R1  -
; Outputs:
; R17, R16
calculate_parameters_for_dac:
    eor         R17,R17                         ; R17 = 0                   // What this is?!?!?!
    mul         R18,R20                         ; R18 = R18 * R20           //
    sbrc        R0,0x7                          ; if (!(R0 & 0x07))         //
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
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0010a6()
.org (0x10a6 << 1)
calculate_parameters_for_dac_2:
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
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
; Software SPI implementation
; Params:
; in  R16 -- register address
; in  R18, R17 -- read data
; in  R19 - select hStrobe (range 1 - 3 or 4 for all)
.org (0x10ba << 1)
ths788_write:
    push        R16
    push        R17
    push        R18
    push        R19
    push        R20
    push        R21
    push        R22
    mov         R21,R19
    andi        R19,0x3
    cpi         R19,0x3
    brbs        CPU_C_bp, ths788_write_select_channel
    ldi         R22,0x1c
    rjmp        thd788_write_start
ths788_write_select_channel:
    ldi         R22,0x4
LAB_code_0010c8:
    dec         R19
    brbs        CPU_N_bp, thd788_write_start
    add         R22,R22
    rjmp        LAB_code_0010c8
thd788_write_start:
    ori         R22,0x2
    sts         PORTB_OUTCLR,R22
    ldi         R22,0x1                     ; CLK
    ldi         R20,0x2                     ; DATA

    sts         PORTB_OUTSET,R22            ; Send write bit
    sts         PORTB_OUTCLR,R22

    andi        R21,0x4                     ; select programming mode
    brbs        CPU_Z_bp, ths788_write_skip_programming_mode
    sts         PORTB_OUTSET,R20
ths788_write_skip_programming_mode:
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22

    ldi         R21,0x18
ths788_write_address_with_data:
    sbrs        R16,0x7
    sts         PORTB_OUTCLR,R20
    sbrc        R16,0x7
    sts         PORTB_OUTSET,R20
    adc         R17,R17
    adc         R18,R18
    adc         R16,R16
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22
    dec         R21
    brbc        CPU_Z_bp, ths788_write_address_with_data

    sts         PORTB_OUTSET,R22            ; send w0 pulse
    sts         PORTB_OUTCLR,R22

    ldi         R21,0x1c                    ; disable hStrobe
    sts         PORTB_OUTSET,R21
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22
    pop         R22
    pop         R21
    pop         R20
    pop         R19
    pop         R18
    pop         R17
    pop         R16
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
; Software SPI implementation
; Params:
; in  R16 -- register address
; out R18, R17 -- read data
; in  R19 - select hStrobe (range 1 - 3)
.org (0x1104 << 1)
ths788_read:
    push        R16
    push        R19
    push        R20
    push        R21
    push        R22
    cpi         R19,0x3
    brbs        CPU_C_bp, ths788_read_check_hStrobe
    rjmp        ths788_read_return
ths788_read_check_hStrobe:
    ldi         R22,0x4
ths788_read_select_hStrobe:                     ; R22 = 0x04 << R19
    dec         R19
    brbs        CPU_N_bp, LAB_code_001111
    add         R22,R22
    rjmp        ths788_read_select_hStrobe
LAB_code_001111:
    sts         PORTB_OUTCLR,R22                ; Set hStrobe
    ldi         R22,0x1                         ; CLK
    ldi         R20,0x2                         ; DATA

    sts         PORTB_OUTSET,R20                ; Send read bit
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22
    sts         PORTB_OUTCLR,R20                ; Unused bit
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22
    ldi         R21, 8
ths788_read_send_address:
    sbrs        R16,0x7
    sts         PORTB_OUTCLR,R20
    sbrc        R16,0x7
    sts         PORTB_OUTSET,R20
    adc         R16,R16
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22
    dec         R21
    brbc        CPU_Z_bp, ths788_read_send_address

    sts         PORTB_DIRCLR,R20            ; Reserve bit
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22

    ldi         R21, 16
ths788_read_data:
    sts         PORTB_OUTSET,R22
    add         R17,R17
    adc         R18,R18
    lds         R16,PORTB_IN
    sbrc        R16,0x1
    ori         R17,0x1
    sts         PORTB_OUTCLR,R22
    dec         R21
    brbc        CPU_Z_bp, ths788_read_data

    ldi         R21,0x1c
    sts         PORTB_OUTSET,R21            ; Disable hStobe
    sts         PORTB_DIRSET,R20
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22
    sts         PORTB_OUTSET,R22
    sts         PORTB_OUTCLR,R22

ths788_read_return:
    pop         R22
    pop         R21
    pop         R20
    pop         R19
    pop         R16
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
.org (0x1155 << 1)
; Params:
;   R22 Select DAC_SYNC channel (probably range 1 - 3)
;   MSB, LSB
;   R17, R16 - Data to send
dac_send_value:
    push        R22                             ; Select DAC_SYNC channel
    push        R23                             ; Dont overwrite
    push        R24                             ; Dont overwrite
    cli
    ldi         R23,0xD5                        ; SPI Control
    sts         SPIC_CTRL,R23                   ; Double clock, Enable, MSB first, prescaler = 16
    mov         R23,R22                         ; R23 = R22
    ldi         R24,0x1                         ; R24 = 0x01
    andi        R23,0x30                        ;
    brbs        CPU_Z_bp, LAB_code_001164       ; if ((R22 & 0x20) != 0)
    add         R24,R24                         ;   R24 = R24 * 2
    subi        R23,0x10                        ;
    brbs        CPU_Z_bp, LAB_code_001164       ; if ((R22 & 0x10) != 0)
    add         R24,R24                         ;   R24 = R24 * 2
LAB_code_001164:
    mov         R23,R22                         ;

    swap        R22                             ; Select a device address
    andi        R22,0xc0                        ;

    add         R23,R23                         ;
    andi        R23,0x6                         ; Select both DAC output

    or          R22,R23                         ;
    ori         R22,0x10                        ; Write to bugger and load
                                                ; R22 = (R22 & 0x0C) << 4 | (R22 & 0x06) | 0x10

    sts         PORTC_OUTCLR,R24                ; Write select DAC_SYNC channel

    sts         SPIC_DATA,R22                   ;
LAB_code_00116f:                                ; Wait until end transmission
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_00116f

                                                ; Send R17 and R16
    sts         SPIC_DATA,R17                   ;
LAB_code_001175:                                ; Wait until end transmission
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_001175

    sts         SPIC_DATA,R16
LAB_code_00117b:                                ; Wait until end transmission
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_00117b

    ldi         R22,0x7
    sts         PORTC_OUTSET,R22                ; Disable DAC_SYNC channel
    bset        CPU_I_bp
    pop         R24
    pop         R23
    pop         R22
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001187(void)
; FPGA msg send
; @in R18 -- address high
; @in R21 -- address low
; @in R17 -- data high
; @in R16 -- data low
.org (0x1187 << 1)
fpga_msg_send_t2:
    push        R18
    push        R21
    push        R22
    ldi         R22,0xD1                    ; SPI Control config
    sts         SPIC_CTRL,R22               ; Double freq, Enable, MSB first, Master, Prescaler = 16
    eor         R21,R21                     ; R21 = 0
    lsr         R18                         ;
    ror         R21                         ;
    lsr         R18                         ;
    ror         R21                         ; R21 = 0x00 | (R18 << 6)
                                            ; R18 = R18 >> 2
    ldi         R22,0x1
    sts         PORTD_OUTCLR,R22            ; Enable CS FPGA SPI

    sts         SPIC_DATA,R18               ; Send R18
FPGA_MSG_write_wait_until_spi_1:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        FPGA_MSG_write_wait_until_spi_1
    sts         SPIC_DATA,R21               ; Send R21
FPGA_MSG_write_wait_until_spi_2:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        FPGA_MSG_write_wait_until_spi_2

    sts         SPIC_DATA,R17               ; Send R17
FPGA_MSG_write_wait_until_spi_3:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        FPGA_MSG_write_wait_until_spi_3
    sts         SPIC_DATA,R16               ; Send R16
FPGA_MSG_write_wait_until_spi_4:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        FPGA_MSG_write_wait_until_spi_4

    ldi         R22,0x1
    sts         PORTD_OUTSET,R22            ; Disable CS FPGA SPI
    pop         R22
    pop         R21
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0011b4()
; FPGA_msg_read_from_address
; @in R18   -- address high
; @in R21   -- address low
; @out R17  -- data high
; @out R16  -- data low
.org (0x11b4 << 1)
fpga_msg_read_t1:
    push        R18
    push        R21
    push        R22
    ldi         R22,0xD1                ; SPI Control config
    sts         SPIC_CTRL,R22           ; Double freq, Enable, MSB first, Master, Prescaler = 16
    lsr         R18                     ;
    ror         R21                     ;
    lsr         R18                     ;
    ror         R21                     ;
                                        ; R21 = (R21 >> 2) | (R18 << 6)
    ori         R18,0x80                ; R18 = 0x80 | R18 >> 2 // set MSB to 1 - read
    ldi         R22,0x1
    sts         PORTD_OUTCLR,R22        ; Enable CS at FPGA SPI
    sts         SPIC_DATA,R18           ; Send R18
FPGA_MSG_read_wait_until_spi_1:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        FPGA_MSG_read_wait_until_spi_1
    sts         SPIC_DATA,R21           ; Send R21
FPGA_MSG_read_wait_until_spi_2:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        FPGA_MSG_read_wait_until_spi_2
    sts         SPIC_DATA,R17
FPGA_MSG_read_wait_until_spi_3:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        FPGA_MSG_read_wait_until_spi_3
    lds         R17,SPIC_DATA
    sts         SPIC_DATA,R16           ; Read data from SPI
FPGA_MSG_read_wait_until_spi_4:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        FPGA_MSG_read_wait_until_spi_4
    lds         R16,SPIC_DATA           ; Read data from SPI
    ldi         R22,0x1
    sts         PORTD_OUTSET,R22        ; Disable CS at FPGA SPI
    pop         R22
    pop         R21
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0011e5(void)
; FUN_code_0011e5(void)
; @out R9,  R8  -
; @out R11, R10 -
; @out R13, R12 -
; @out R15, R14 -
.org (0x11e5 << 1)
FUN_code_0011e5:
    push        R18
    push        R21
    push        R22
    ldi         R22,0xD1                        ; SPI Control config
    sts         SPIC_CTRL,R22                   ; Double freq, Enable, MSB first, Master, Prescaler = 16
    ldi         R18,0xbc                        ; R18 = 0xBC | R21 = 0
    eor         R21,R21                         ; MSB = 1 (READ) address = 0xF0
    ldi         R22,0x1
    sts         PORTD_OUTCLR,R22                ; Enable CS at FPGA SPI

    sts         SPIC_DATA,R18                   ; SPI send to FPGA 0xBC
LAB_code_0011f2:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_0011f2
    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_0011f8:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_0011f8

    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_0011fe:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_0011fe
    lds         R9,SPIC_DATA                    ; Save data 1

    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_001206:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_001206
    lds         R8,SPIC_DATA                    ; Save data 2
    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_00120e:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_00120e
    lds         R11,SPIC_DATA                   ; Save data 3
    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_001216:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_001216
    lds         R10,SPIC_DATA                   ; Save data 4
    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_00121e:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_00121e
    lds         R13,SPIC_DATA                   ; Save data 5
    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_001226:
    lds         R22,SPIC_STATU
    sbrs        R22,0x7
    rjmp        LAB_code_001226
    lds         R12,SPIC_DATA                   ; Save data 6
    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_00122e:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_00122e
    lds         R15,SPIC_DATA                   ; Save data 7
    sts         SPIC_DATA,R21                   ; SPI send to FPGA 0x00
LAB_code_001236:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_001236
    lds         R14,SPIC_DATA                   ; Save data 8
    ldi         R22,0x1
    sts         PORTD_OUTSET,R22                ; Disable SPI from SPI
    pop         R22
    pop         R21
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001243(void)
.org (0x1243 << 1)
; Parameters:
; in R16    - ADDRESS & 0x0F | DATA
; in R17    - DATA
; in R18    - DATA
CDCE62005_send_control_settings:
    push        R22
    ldi         R22,0xF1
    sts         SPIC_CTRL,R22                   ;   Double clock, Enable, First LSB, Master, Prescaler = 16
    ldi         R22,0x10
    sts         PORTF_OUTCLR,R22                ;   Enable LE in PLL

    sts         SPIC_DATA,R16
CDCE62005_wait_spi_send_1:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        CDCE62005_wait_spi_send_1

    sts         SPIC_DATA,R17
CDCE62005_wait_spi_send_2:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        CDCE62005_wait_spi_send_2

    sts         SPIC_DATA,R18
CDCE62005_wait_spi_send_3:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        CDCE62005_wait_spi_send_3

    sts         SPIC_DATA,R19
CDCE62005_wait_spi_send_4:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        CDCE62005_wait_spi_send_4

    ldi         R22,0x10
    sts         PORTF_OUTSET,R22
    pop         R22
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001267(void)
.org (0x1267 << 1)
; Parameters:
;   out: R16, R17, R18, R19 -- read data from status register
CDCE62005_read_status_register:
    push        R22
    push        R23
    ldi         R16,0x8e
    eor         R17,R17
    eor         R18,R18
    eor         R19,R19
    rcall       CDCE62005_send_control_settings ; address = 0x0E Data = 0x00'00'00'8 -- read status
    ldi         R22,0x10
    sts         PORTF_OUTCLR,R22
    eor         R23,R23

    sts         SPIC_DATA,R23
CDCE62005_READ_wait_1:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        CDCE62005_READ_wait_1
    lds         R16,SPIC_DATA

    sts         SPIC_DATA,R23
CDCE62005_READ_wait_2:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        CDCE62005_READ_wait_2
    lds         R17,SPIC_DATA

    sts         SPIC_DATA,R23
CDCE62005_READ_wait_3:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        CDCE62005_READ_wait_3
    lds         R18,SPIC_DATA

    sts         SPIC_DATA,R23
CDCE62005_READ_wait_4:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        CDCE62005_READ_wait_4
    lds         R19,SPIC_DATA

    ldi         R22,0x10
    sts         PORTF_OUTSET,R22                ; Disable LE
    pop         R23
    pop         R22
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001298(void)
.org (0x1298 << 1)
fpga_send_mcu_timestamp:
    push        R18
    push        R21
    push        R22
    push        ZL
    push        ZH
    ldi         ZL,0x92
    ldi         ZH,0x2B                         ; Z = 0x2B92
                                                ; data: 0x2B, 0xD9, 0x2A, 0x85
    ldi         R22,0xD1                        ; SPI Control config
    sts         SPIC_CTRL,R22                   ; Double freq, Enable, MSB first, Master, Prescaler = 16
    ldi         R18,0x3D                        ; R18 = 0x3D | R21 = 0x40
    ldi         R21,0x40                        ; MSB = 0 (WRITE) address = 0xF5
    ldi         R22,0x1
    sts         PORTD_OUTCLR,R22                ; Enable CS FPGA SPI

                                                ; Send address
    sts         SPIC_DATA,R18                   ; Send 0x3D as address
fpga_send_mcu_timestamp_wait_1:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        fpga_send_mcu_timestamp_wait_1

    sts         SPIC_DATA,R21                   ; Send 0x01
fpga_send_mcu_timestamp_wait_2:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        fpga_send_mcu_timestamp_wait_2

LAB_code_0012b3:                                ; for (int i = 0; i < 4; i++){
    lpm         R18,Z+                          ;   spi_send_data(*(0x2B92 + i));
    lpm         R21,Z+                          ;   while(!(SPIC_STATUS && 7));
                                                ; }
    sts         SPIC_DATA,R21                   ; Send R21
LAB_code_0012b7:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_0012b7

    sts         SPIC_DATA,R18                   ; Send R18
LAB_code_0012bd:
    lds         R22,SPIC_STATUS
    sbrs        R22,0x7
    rjmp        LAB_code_0012bd

    cpi         ZL,0x96                         ; if Z == 0x2B96 skip
    brbc        CPU_Z_bp, LAB_code_0012b3
    ldi         R22,0x1
    sts         PORTD_OUTSET,R22                ; Disable CS FPGA SPI

    pop         ZH
    pop         ZL
    pop         R22
    pop         R21
    pop         R18
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
; Soft SPI send address with 8bit data
; @in R16 - address
; @in R17 - data
; @out void
.org (0x12cc << 1)
adt7311_8bit_rw:
    push        R16
    push        R17
    push        R18
    push        R19
    ldi         R18,0x10                        ;
    sts         PORTA_OUTCLR,R18                ; Enable CS ADT7311
    mov         R19,R17
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(R16)
    mov         R16,R19
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(R17)
    ldi         R18,0x10
    sts         PORTA_OUTSET,R18                ; Disable CS ADT7311
    pop         R19
    pop         R18
    pop         R17
    pop         R16
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
; Soft SPI send address with 16bit data
; @in R16 - address
; @in R18 - data high
; @in R17 - data low
; @out R21 - read high
; @out R20 - read low
.org (0x12df << 1)
adt7311_16bit_rw:
    push        R16
    push        R17
    push        R18
    ldi         R20,0x10
    sts         PORTA_OUTCLR,R20                ; Enable CS ADT7311
    mov         R20,R17
    mov         R21,R18
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(R16)
    mov         R16,R21
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(R18)
    mov         R21,R16
    mov         R16,R20
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(R17)
    mov         R20,R16
    ldi         R18,0x10
    sts         PORTA_OUTSET,R18                ; Disable CS ADT7311
    pop         R18
    pop         R17
    pop         R16
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0012f5(void)
; FIX: That if R16 == 0xFF then error with data frame
; on the other head if R16 == 0x00 then write to Read-Only register
.org (0x12f5 << 1)
adt7311_faults_clr:
    ldi         R16,0x10
    sts         PORTA_OUTCLR,R16                ; ADT7311 CS enable
    ser         R16
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(0xFF)
    ser         R16
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(0xFF)
    ser         R16
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(0xFF)
    ser         R16
    rcall       adt7311_byte_rw                 ; adt7311_byte_rw(0xFF)
    ldi         R16,0x10
    sts         PORTA_OUTSET,R16                ; ADT7311 CS disable
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
; Software SPI read/write implementation
; @in R16
; @out R16
.org (0x1304 << 1)
adt7311_byte_rw:
    ldi         R18,0x8
soft_spi_send_next_bit:
    ldi         R17,0x8
    sbrc        R16,0x7                         ; if (R16 & 1 << 7 != 0){
    sts         PORTA_OUTSET,R17                ;       PORTA |= 0x08;      // Termometr Din = 1
    sbrs        R16,0x7                         ; } if (R16 & 1 << 7 == 0) {
    sts         PORTA_OUTCLR,R17                ;       PORTA &= ~0x08;     // Termometr Din = 0
    ldi         R17,0x2                         ; }
    sts         PORTA_OUTCLR,R17                ; Termometr Clock fall edge
    add         R16,R16                         ; R16 = R16 << 1
    nop
    sts         PORTA_OUTSET,R17                ; Termometr Clock rise edge
    lds         R17,PORTA_IN                    ;
    bst         R17,0x2                         ; store last bit
    bld         R16,0x0
    dec         R18
    brbc        CPU_Z_bp, soft_spi_send_next_bit
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined5 FUN_code_00131a()
.org (0x131a << 1)
cli_get_integer:
    push        R22
    push        R17
    push        R18
    push        R19
    push        R1
    push        R0
    eor         R18,R18
    ldi         R17,0xa
    eor         R19,R19
    eor         R20,R20
    eor         R21,R21
LAB_code_001325:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    and         R18,R18
    brbc        CPU_Z_bp, LAB_code_00132d
    cpi         R16,'-'
    brbc        CPU_Z_bp, LAB_code_00132d
    inc         R19
    inc         R18
    rjmp        LAB_code_001325
LAB_code_00132d:
    inc         R18
    cpi         R16,0x30
    brbs        CPU_S_bp,LAB_code_001341
    cpi         R16,0x3a
    brbc        CPU_S_bp,LAB_code_001341
    mov         R22,R16
    subi        R22,0x30
    mul         R20,R17
    add         R0,R22
    eor         R22,R22
    adc         R1,R22
    mov         R22,R21
    mov         R21,R1
    mov         R20,R0
    mul         R17,R22
    and         R1,R1
    brbc        CPU_Z_bp, LAB_code_00134e
    add         R21,R0
    brbc        CPU_C_bp, LAB_code_001325
    rjmp        LAB_code_00134e
LAB_code_001341:
    cpi         R18,0x1
    brbs        CPU_Z_bp, LAB_code_00134e
    and         R19,R19
    brbs        CPU_Z_bp, LAB_code_00134c
    cpi         R18,0x2
    brbs        CPU_Z_bp, LAB_code_00134e
    eor         R19,R19
    neg         R20
    adc         R21,R19
    neg         R21
    brbc        CPU_N_bp, LAB_code_00134e
LAB_code_00134c:
    clc
    rjmp        LAB_code_00134f
LAB_code_00134e:
    bset        CPU_C_bp
LAB_code_00134f:
    pop         R0
    pop         R1
    pop         R19
    pop         R18
    pop         R17
    pop         R22
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001356(void)
.org (0x1356 << 1)
cli_get_hex:
    push        R22
    push        R18
    eor         R18,R18
    eor         R20,R20
    eor         R21,R21
cli_get_hex_next_char_loop:
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
    mov         R22,R16
    cpi         R16,0x30
    brbs        CPU_C_bp, LAB_code_001374
    cpi         R16,':'
    brbs        CPU_C_bp, LAB_code_001366
    cpi         R16,'A'
    brbs        CPU_C_bp, LAB_code_001374
    cpi         R16,'G'
    brbc        CPU_C_bp, LAB_code_001374
    subi        R22,'\a'
LAB_code_001366:
    subi        R22,0x30
    add         R20,R20
    adc         R21,R21
    add         R20,R20
    adc         R21,R21
    add         R20,R20
    adc         R21,R21
    add         R20,R20
    adc         R21,R21
    or          R20,R22
    inc         R18
    cpi         R18,0x4
    brbc        CPU_Z_bp, cli_get_hex_next_char_loop
    rcall       cli_get_next_char                         ;undefined FUN_code_00141e(void)
LAB_code_001374:
    and         R18,R18
    brbs        CPU_Z_bp, LAB_code_001378
    clc
    rjmp        LAB_code_001379
LAB_code_001378:
    bset        CPU_C_bp
LAB_code_001379:
    pop         R18
    pop         R22
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
.org (0x137c << 1)
; Parameters:
;   in R17 -- MSB value
;   in R16 -- LSB value
cli_send_32bit_hex:
    push        R16
    push        R17
    push        R18
    mov         R18,R16
    swap        R17
    mov         R16,R17
    rcall       cli_send_digit_hex                         ;undefined FUN_code_001390(void)
    swap        R17
    mov         R16,R17
    rcall       cli_send_digit_hex                         ;undefined FUN_code_001390(void)
    swap        R18
    mov         R16,R18
    rcall       cli_send_digit_hex                         ;undefined FUN_code_001390(void)
    swap        R18
    mov         R16,R18
    rcall       cli_send_digit_hex                         ;undefined FUN_code_001390(void)
    pop         R18
    pop         R17
    pop         R16
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
; Convert digit to hex
.org (0x1390 << 1)
; Parameters:
; in R16 - digit in hex to send
cli_send_digit_hex:
    andi        R16,0x0F                        ;
    subi        R16,0xD0                        ; R16 = R16 + '0'
    cpi         R16,0x3a                        ;
    brbs        CPU_C_bp, LAB_code_001395       ; if R16 > '9'
    subi        R16,0xf9                        ; R16 = R16 + 'A' - '0'
LAB_code_001395:
    rcall       cli_send_buf
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001397(void)
.org (0x1397 << 1)
; in R16-R17 - number
cli_send_float_round_2:
    push        R20
    ldi         R20,0x2
    bset        CPU_C_bp
    rjmp        cli_send_number
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_00139b(void)
.org (0x139b << 1)
; in R16-R17 - number
cli_send_temperature:
    push        R20
    ldi         R20,0x1
    bset        CPU_C_bp
    rjmp        cli_send_number
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_00139f(void)
.org (0x139f << 1)
; in R16-R17 - number
cli_send_delay:
    push        R20
    ldi         R20,0x3
    bset        CPU_C_bp
    rjmp        cli_send_number
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0013a3(void)
.org (0x13a3 << 1)
; in R16-R17 - number
cli_send_int16:
    push        R20
    eor         R20,R20
    bset        CPU_C_bp
    rjmp        cli_send_number
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_0013a7(void)
.org (0x13a7 << 1)
cli_send_uint16:
    push        R20
    eor         R20,R20
    clc
; Parameters:
; in R16-R17 - number
; in R20 - floating point
; cli_send_number(float: value, int: round)
cli_send_number:
    push        R14
    push        R15
    push        R16
    push        R17
    push        R18
    push        R19
    push        R25
    push        ZL
    push        ZH
    eor         R15,R15                         ; R15 = 0
    brbc        CPU_C_bp, LAB_code_0013bd
    inc         R15                             ; R15 = 1
    and         R17,R17                         ; if (R17 == 0), R17 = 0
    brbc        CPU_N_bp, LAB_code_0013bd       ;
    neg         R15
    neg         R16
    brbc        CPU_C_bp, LAB_code_0013bc
    inc         R17
LAB_code_0013bc:
    neg         R17
LAB_code_0013bd:
    ldi         ZL,0x56
    ldi         ZH,0x21                         ; Z   = 0x2156
    eor         R19,R19                         ; R19 = 0
    st          Z,R19                           ; *(0x2156) = 0
LAB_code_0013c1:
    ldi         R18,0xd
    eor         R14,R14
LAB_code_0013c3:
    subi        R17,0xa0
    sbrs        R14,0x0
    brbs        CPU_C_bp, LAB_code_0013c8
    bset        CPU_C_bp
    rjmp        LAB_code_0013ca
LAB_code_0013c8:
    subi        R17,0x60
    clc
LAB_code_0013ca:
    adc         R16,R16
    adc         R17,R17
    adc         R14,R14
    dec         R18
    brbc        CPU_Z_bp, LAB_code_0013c3
    mov         R18,R17
    ror         R14
    ror         R18
    andi        R17,0x1f
    swap        R18
    andi        R18,0xf
    subi        R18,0xd0
    st          -Z, R18
    inc         R19
    cp          R20,R19
    brbc        CPU_Z_bp, LAB_code_0013dc
    ldi         R18,0x2e
    st          -Z, R18
LAB_code_0013dc:
    and         R17,R17
    brbc        CPU_Z_bp, LAB_code_0013c1
    and         R16,R16
    brbc        CPU_Z_bp, LAB_code_0013c1
    cp          R20,R19
    brbs        CPU_S_bp,LAB_code_0013ee
    ldi         R18,0x30
    st          -Z,R18
    brbs        CPU_Z_bp, LAB_code_0013ee
LAB_code_0013e5:
    inc         R19
    cp          R19,R20
    brbs        CPU_Z_bp, LAB_code_0013ea
    st          -Z,R18
    rjmp        LAB_code_0013e5
LAB_code_0013ea:
    ldi         R18,0x2e
    st          -Z,R18
    ldi         R18,0x30
    st          -Z,R18
LAB_code_0013ee:
    ldi         R17,0x50                        ; if (R20 == 0){
    and         R20,R20                         ;   R17 = 0x50;
    brbs        CPU_Z_bp, LAB_code_0013f2       ; } else {
    dec         R17                             ;   R17 = 0x4F
LAB_code_0013f2:                                ; }
    ldi         R16,0x20                        ;
    and         R15,R15                         ;
    brbs        CPU_Z_bp, LAB_code_0013fa       ; if (R15 != 0) {
    brbc        CPU_N_bp, LAB_code_0013f7       ;   if ((R15 & 1 << 7) == 0) {
    ldi         R16,0x2D                        ;       R16 = 0x2D
LAB_code_0013f7:                                ;   }
    st          -Z,R16                          ;
    ldi         R16,0x20                        ;
    dec         R17                             ;
LAB_code_0013fa:                                ; }
    cp          ZL,R17
    brbs        CPU_Z_bp, LAB_code_0013fe
    st          -Z,R16
    rjmp        LAB_code_0013fa
LAB_code_0013fe:
    adiw        Z,0x1
LAB_code_0013ff:
    ld          R16,Z+
    and         R16,R16                             ; if (R16 == 0)  return
    brbs        CPU_Z_bp, LAB_code_001404
    rcall       cli_send_buf                        ; in: R16
    rjmp        LAB_code_0013ff
LAB_code_001404:
    pop         ZH
    pop         ZL
    pop         R25
    pop         R19
    pop         R18
    pop         R17
    pop         R16
    pop         R15
    pop         R14
    pop         R20
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_00140f(void)
.org (0x140f << 1)
cli_send_newline:
    ldi         ZL,0x84
    ldi         ZH,0x29
    rcall       cli_send_msg
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001413(void)
.org (0x1413 << 1)
; Parameters:
;   in Z -- string start address
cli_send_msg:
    push        R16
CLI_SEND_MSG_next_char:
    lpm         R16,Z+
    and         R16,R16
    brbs        CPU_Z_bp, CLI_SEND_MSG_return
    rcall       cli_send_buf                         ;undefined FUN_code_001456(void)
    rjmp        CLI_SEND_MSG_next_char
CLI_SEND_MSG_return:
    pop         R16
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_00141b(void)
.org (0x141b << 1)
cli_get_next_byte:
    push        R19
    ldi         R19,0x1
    rjmp        CLI_GET_NEXT
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_00141e(void)
; uint8_t RECV_CURRENT_CHAR_INDEX = *(0x2001)
; uint8_t RECV_MESSAGE_SIZE = *(0x2000)
.org (0x141e << 1)
; Parameters:
; out R18 - char
cli_get_next_char:
    push        R19
    eor         R19,R19
CLI_GET_NEXT:
    push        R17
    push        R18
    push        R20
    push        ZL
    push        ZH
    ldi         ZL,0x00
    ldi         ZH,0x20                                     ; Z = *RECV_MESSAGE_SIZE
CLI_GET_NEXT_nothing_receive:
    cli                                                     ; Disable irq
    ld          R17,Z                                       ; R17 = RECV_MESSAGE_SIZE
    ldd         R16,Z+0x1                                   ; R1+ = RECV_CURRENT_CHAR_INDEX
    bset        CPU_I_bp                                    ; Enable irq
    cp          R16,R17                                     ; if (RECV_CURRENT_CHAR_INDEX == RECV_MESSAGE_SIZE) jump CLI_GET_NEXT_nothing_receive
    brbs        CPU_Z_bp, CLI_GET_NEXT_nothing_receive
    inc         R17                                         ; RECV_MESSAGE_SIZE++
    andi        R17,RECV_BUFFER_SIZE
    lds         R20,PORTF_OUT                               ;
    sbrs        R20,0                                       ; if (MCU_Console_RTS == 0) jump CLI_GET_NEXT_ready_to_read //ready to read
    rjmp        CLI_GET_NEXT_ready_to_read
    mov         R18,R17                                     ; check if buffer capacity >= 20
    subi        R18,0xec
    andi        R18,0x3f
    cpse        R16,R18                                     ; if (recv_buf_capacity >= 20) {
    ldi         R20,0x1                                     ;   MCU_Console_RTS = 1
    sts         PORTF_OUTCLR,R20; }
CLI_GET_NEXT_ready_to_read:
    eor         R18,R18
    ldi         ZL,0x07
    ldi         ZH,0x20                                     ; Z = *RECV_BUFFER
    add         ZL,R17
    adc         ZH,R18
    ld          R18,Z                                       ; R18 = RECV_BUFFER[RECV_CURRENT_CHAR_INDEX];
    sts         RECV_MESSAGE_SIZE,R17                       ; RECV_MESSAGE_SIZE = RECV_CURRENT_CHAR_INDEX;
    cpi         R18,'\r'                                    ;
    brbc        CPU_Z_bp, CLI_GET_NEXT_end_transmission
    lds         R17,SERIAL_RECV_MSG_LEN                     ;
    dec         R17
    sts         SERIAL_RECV_MSG_LEN,R17                     ; SERIAL_RECV_MSG_LEN--
CLI_GET_NEXT_end_transmission:                              ;
    cpi         R18,0x60                                    ;
    brbs        CPU_S_bp, CLI_GET_NEXT_return               ;
    brbs        CPU_Z_bp, CLI_GET_NEXT_return               ;
    sbrs        R19,0x0                                     ;
    andi        R18,0x5f                                    ; to upper case
CLI_GET_NEXT_return:
    mov         R16,R18                                     ; R16 = read char
    pop         ZH
    pop         ZL
    pop         R20
    pop         R18
    pop         R17
    pop         R19
    ret
;************************************************************************************************
;*                                           FUNCTION                                           *
;************************************************************************************************
;undefined FUN_code_001456(void)
; // Global:
; uint8_t SEND_CURRENT_CHAR_INDEX   = *(0x2002);
; uint8_t SEND_MESSAGE_SIZE         = *(0x2003);
; uint8_t SEND_BUFFER_SIZE          = *(0x2004);

; char SEND_buffer[SEND_BUFFER_SIZE]; // First address 0x2047
.org (0x1456 << 1)
; Parameters:
;   in R16 -- char to send/add to buffer
cli_send_buf:
    push        ZH
    push        ZL
    push        R20
    push        R19
    push        R18
    push        R17
    ldi         ZL,0x02
    ldi         ZH,0x20
LAB_code_00145e:
    cli
    ld          R17,Z+                      ; R17 = SEND_CURRENT_CHAR_INDEX (0x2002)
    ld          R18,Z+                      ; R18 = SEND_MESSAGE_SIZE       (0x2003)
    cp          R17,R18
    brbs        CPU_Z_bp, CLI_SEND_BUFFER_full_buffer   ; if (SEND_CURRENT_CHAR_INDEX == SEND_MESSAGE_SIZE) jump
    inc         R18                         ;
    cp          R17,R18
    brbc        CPU_Z_bp, CLI_SEND_BUF_add_char_to_buffer
    bset        CPU_I_bp                    ; Enable interrupt
    sbiw        Z,0x2                       ; Z = Z - 2 = 0x2002
    rjmp        LAB_code_00145e
CLI_SEND_BUF_add_char_to_buffer:
    ldi         ZL,0x47
    ldi         ZH,0x20                     ; Z = SEND_buffer[] // Z = 0x2047
    eor         R17,R17                     ; R17 = 0
    add         ZL,R18                      ;
    adc         ZH,R17                      ; Z = SEND_buffer + SEND_CURRENT_CHAR_INDEX
    st          Z,R16                       ; SEND_buffer[SEND_CURRENT_CHAR_INDEX] = R16
    ldi         ZL,0x03
    ldi         ZH,0x20
    st          Z,R18                       ; SEND_MESSAGE_SIZE = SEND_CURRENT_CHAR_INDEX
    bset        CPU_I_bp
    rjmp        cli_send_buf_return
CLI_SEND_BUFFER_full_buffer:
    inc         R18                         ; SEND_MESSAGE_SIZE++
    ld          R19,Z                       ; R19 = SEND_BUFFER_SIZE        (0x2004)
    and         R19,R19
    brbs        CPU_Z_bp, CLI_SEND_BUF_add_char_to_buffer
    lds         R20,USARTF0_STATUS              ;
    sbrs        R20, 5                          ; if (DREIF == 1) jump CLI_SEND_BUF_add_char_to_buffer
    rjmp        CLI_SEND_BUF_add_char_to_buffer
    sts         USARTF0_DATA,R16                ; Send char
    lds         R20,USARTF0_CTRLA               ;
    ori         R20,0x2                         ;
    sts         USARTF0_CTRLA,R20               ; USARTF_CTRLA |= 0x02 enable irq from USART
    bset        CPU_I_bp
cli_send_buf_return:
    pop         R17
    pop         R18
    pop         R19
    pop         R20
    pop         ZL
    pop         ZH
    ret

    .org (0x148b << 1) ; Flash address: 0x2916              NOTE: PLL SPI DATA
    .byte			0x08, 0x18, 0x00, 0x00,	; 0x00001808 // 1
    .byte           0x20, 0x03, 0x07, 0xeb, ; 0xEB070320 // 2
    .byte           0x21, 0x03, 0x80, 0xeb, ; 0x210380EB // 3
    .byte           0x02, 0x03, 0x06, 0xeb, ; 0x020306EB // 4
    .byte           0x03, 0x03, 0x80, 0xeb, ; 0x030380EB // 5
    .byte           0x34, 0x03, 0x84, 0x68, ; 0x34038468 // 6
    .byte           0x35, 0x0f, 0x04, 0x40, ; 0x350F0440 // 7
    .byte           0x86, 0x01, 0xfe, 0xc0, ; 0x8601FEC0 // 8
    .byte           0xf7, 0xbb, 0x42, 0xbd, ; 0xF7BB42BD // 9
    .byte           0x86, 0x01, 0xfe, 0xc4, ; 0x8601FEC4 // 10 End PLL SPI DATA
    .byte           0x20, 0x03, 0x07, 0x69, ; 0x20030769
    .byte           0x21, 0x03, 0x80, 0x69, ; 0x21038069
    .byte           0x02, 0x03, 0x06, 0x69, ; 0x02030669
    .byte           0x03, 0x03, 0x80, 0x69, ; 0x03038069
    .byte           0x34, 0x03, 0x84, 0x68, ; 0x34038468
    .byte           0x35, 0x0f, 0x04, 0x40, ; 0x350F0440
    .byte           0x86, 0x01, 0xee, 0xc0, ; 0x8601EEC0
    .byte           0xf7, 0x37, 0x78, 0xbc, ; 0xF73778BC
    .byte           0x1f, 0x00

    .org (0x14b1 << 1)  ; Flash address: 0x2962
    .string         "\r\nPMxx control interface ready\r\n"

    .org (0x14c4 << 1)  ; Flash address: 0x2988
    .string         "Syntax error\r\n"

    .org (0x14cc << 1)  ; Flash address: 0x2998
    .string         "OK\r\n"

    .org (0x14cf << 1)  ; Flash address: 0x299E
    .string         "FAIL\r\n"

    .org (0x14d3 << 1)  ; Flash address: 0x29A6
    .string         "\r\nExternal power source: "

    .org (0x14e0 << 1)  ; Flash address: 0x29C0
    .string         "Temperature "

    .org (0x14e7 << 1)  ; Flash address: 0x29CF
    .string         " NORMAL"

    .org (0x14eb << 1)  ; Flash address: 0x29D7
    .string         " LOW"

    .org (0x14ee << 1)  ; Flash address: 0x29DD
    .string         " HIGH"

    .org (0x14f1 << 1)  ; Flash address: 0x29E3
    .string         " CRITICAL"

    .org (0x14f6 << 1)  ; Flash address: 0x29EC
    .string         "\r\nBoard power "

    .org (0x14fe << 1)  ; Flash address: 0x29FC
    .string         "ON, "

    .org (0x1501 << 1)  ; Flash address: 0x2A02
    .string         "OFF\r\n"

    .org (0x1504 << 1)  ; Flash address: 0x2A08
    .string         "No alarm, error flags cleared\r\n"

    .org (0x1514 << 1)  ; Flash address: 0x2A28
    .string         "Clock source "

    .org (0x151b << 1)  ; Flash address: 0x2A36
    .string         "PRIMARY"

    .org (0x151f << 1)  ; Flash address: 0x2A3E
    .string         "SECONDARY"

    .org (0x1524 << 1)  ; Flash address: 0x2A48
    .string         "INTERNAL"

    .org (0x1529 << 1)  ; Flash address: 0x2A52
    .string         ", PLL "

    .org (0x152d << 1)  ; Flash address: 0x2A5A
    .string         "NOT LOCKED\r\n"

    .org (0x1534 << 1)  ; Flash address: 0x2A68
    .string         "CH:"

    .org (0x1536 << 1)  ; Flash address: 0x2A6C
    .string         " Treshold:"

    .org ((0x153b << 1) + 1)    ; Flash address:  0x2A77
    .string         " Shift:"

    .org ((0x153f << 1) + 1)    ; Flash address: 0x2A7F
    .string         " Zero offs:"

    .org ((0x1545 << 1) + 1)    ; Flash address: 0x2A8B
    .string         " Delay"

    .org (0x1549 << 1)  ; Flash address: 0x2A92
    .string         "Trigger window:"

    .org (0x1551 << 1)  ; Flash address: 0x2AA2
    .string         "\r\nCFD sat. level:"

    .org (0x155a << 1)  ; Flash address: 0x2AB4
    .string         "FPGA not ready\r\n"

    .org (0x1563 << 1)  ; Flash address: 0x2AC6
    .string         "CH:"

    .org (0x1565 << 1)  ; Flash address: 0x2ACA
    .string         " Lcal:"

    .org ((0x1568 << 1) + 1)    ; Flash address: 0x2AD1
    .string         " TDC:"

    .org ((0x156b << 1) + 1)    ; Flash address: 0x2AD7
    .string         " Time shift:"

    .org (0x1572 << 1)  ; Flash address: 0x2AE4
    .string         " Range corr:"

    .org (0x1579 << 1)  ; Flash address: 0x2AF2
    .string         "TDC overheated\r\n"

    .org (0x1582 << 1)  ; Flash address: 0x2B04
    .string         "FPGA ready\r\n"

    .org (0x1589 << 1)  ; Flash address: 0x2B12
    .string         "Clock system "

    .org (0x1590 << 1)  ; Flash address: 0x2B20
    .string         "Error\r\n"

    .org (0x1594 << 1)  ; Flash address: 0x2B28
    .string         "TDC "

    .org (0x1597 << 1)  ; Flash address: 0x2B2F
    .string         " refernce unstable\r\n"

    .org (0x15a2 << 1)  ; Flash address: 0x2B44
    .string         "GBT link "

    .org (0x15a7 << 1)  ; Flash address: 0x2B4E
    .string         " no errors\r\n"

    .org (0x15ae << 1)  ; Flash address: 0x2B5C
    .string         " RX errors\r\n"

    .org (0x15b5 << 1)  ; Flash address: 0x2B6A
    .string         "Board S/N: "

    ; Programming key
    .org (0x15bb << 1)  ; Flash address: 0x2B76
    .byte             0x78, 0x56, 0x34, 0x12, 0x98, 0xBA, 0xDC, 0xFE

    .org (0x15bf << 1)  ; Flash address: 0x2B7E
    .string         " Flash Timestamp: "

    .org (0x15c9 << 1)  ; Flash address: 0x2B92
    .byte             0x2B, 0xD9, 0x2A, 0x85

    .org (0x15cb << 1)  ; Flash address: 0x2B96
    .string         "Last reset from "

    .org (0x15d4 << 1)  ; Flash address: 0x2BA8
    .byte             0xB0, 0x2B, 0xC4, 0x2B, 0xBA, 0x2B, 0xD0

    .org ((0x15d7 << 1) + 1)    ; Flash address: 0x2BAF
    .string         "+Power on"

    .org (0x15dd << 1)  ; Flash address: 0x2BBA
    .string         "PLL lock"

    .org (0x15e2 << 1)  ; Flash address: 0x2BC4
    .string         "FPGA reload"

    .org (0x15e8 << 1)  ; Flash address: 0x2BD0
    .string         "SPI command"

;    .org (0x100d0 << 1)
;    .byte             0x7f, 0xc0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x2e, 0xc0, 0xff, 0xff, 0x00, 0xc0, 0xff, 0x93, 0xff, 0xb7, 0xff, 0x93, 0xef, 0x93, 0x3f, 0x93, 0x2f, 0x93, 0x1f, 0x93, 0x0f, 0x93, 0xe2, 0xe0, 0xf0, 0xe2, 0x01, 0x91, 0x11, 0x91, 0x20, 0x81, 0x22, 0x23, 0x11, 0xf0, 0x01, 0x17, 0x31, 0xf4, 0x30, 0x91, 0xa3, 0x0b, 0x3c, 0x7f, 0x30, 0x93, 0xa3, 0x0b, 0x0c, 0xc0, 0x03, 0x95, 0x11, 0x27, 0xe7, 0xe4, 0xf0, 0xe2, 0xe0, 0x0f, 0xf1, 0x1f, 0x10, 0x81, 0x10, 0x93, 0xa0, 0x0b, 0xe2, 0xe0, 0xf0, 0xe2, 0x00, 0x83, 0x0f, 0x91, 0x1f, 0x91, 0x2f, 0x91, 0x3f, 0x91, 0xef, 0x91, 0xff, 0x91, 0xff, 0xbf, 0xff, 0x91, 0x18, 0x95, 0xff, 0x93, 0xff, 0xb7, 0xff, 0x93, 0xef, 0x93, 0x3f, 0x93, 0x2f, 0x93, 0x1f, 0x93, 0x0f, 0x93, 0xe0, 0xe0, 0xf0, 0xe2, 0x01, 0x91, 0x10, 0x81, 0x13, 0x95, 0x1f, 0x73, 0x21, 0x2f, 0x2c, 0x5e, 0x2f, 0x73, 0x20, 0x17, 0x41, 0xf4, 0x21, 0xe0, 0x20, 0x93, 0xa5, 0x06, 0x20, 0x91, 0x05, 0x20, 0x20, 0x68, 0x20, 0x93, 0x05, 0x20, 0x30, 0x91, 0xa1, 0x0b, 0x20, 0x91, 0xa0, 0x0b, 0x34, 0xfd, 0x09, 0xc0, 0x01, 0x17, 0x39, 0xf0, 0x10, 0x83, 0xe7, 0xe0, 0xf0, 0xe2, 0x00, 0x27, 0xe1, 0x0f, 0xf0, 0x1f, 0x20, 0x83, 0x0f, 0x91, 0x1f, 0x91, 0x2f, 0x91, 0x3f, 0x91, 0xef, 0x91, 0xff, 0x91, 0xff, 0xbf, 0xff, 0x91, 0x18, 0x95, 0xff, 0x93, 0xff, 0xb7, 0xff, 0x93, 0xef, 0x93, 0xdf, 0x93, 0x2f, 0x93, 0x1f, 0x93, 0x0f, 0x93, 0xe4, 0xe0, 0xf0, 0xe2, 0xdd, 0x27, 0x00, 0x91, 0xa8, 0x06, 0x01, 0xfd, 0x1b, 0xc0, 0xd3, 0x95, 0x12, 0x91, 0x02, 0x91, 0x01, 0x17, 0xa9, 0xf0, 0x20, 0x91, 0xa1, 0x0b, 0x25, 0xff, 0x0c, 0xc0, 0x11, 0x27, 0x03, 0x95, 0xe7, 0xe4, 0xf0, 0xe2, 0xe0, 0x0f, 0xf1, 0x1f, 0x10, 0x81, 0x10, 0x93, 0xa0, 0x0b, 0xe2, 0xe0, 0xf0, 0xe2, 0x00, 0x83, 0x20, 0x91, 0xa3, 0x0b, 0x22, 0x60, 0x20, 0x93, 0xa3, 0x0b, 0x32, 0x96, 0xd0, 0x83, 0x0f, 0x91, 0x1f, 0x91, 0x2f, 0x91, 0xdf, 0x91, 0xef, 0x91, 0xff, 0x91, 0xff, 0xbf, 0xff, 0x91, 0x18, 0x95
