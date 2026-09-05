;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.6.0 #16555 (Mac OS X ppc)
;--------------------------------------------------------
	.module main
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _delay
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------
	.area SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
	call	___sdcc_external_startup
	tnz	a
	jreq	__sdcc_init_data
	jp	__sdcc_program_startup
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	src/main.c: 29: void delay(uint32_t count)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #4
;	src/main.c: 31: while (count--)
	ldw	x, (0x07, sp)
00101$:
	ldw	(0x01, sp), x
	ld	a, (0x09, sp)
	ld	(0x03, sp), a
	ld	a, (0x0a, sp)
	ldw	y, (0x09, sp)
	subw	y, #0x0001
	ldw	(0x09, sp), y
	jrnc	00123$
	decw	x
00123$:
	tnz	a
	jrne	00124$
	ldw	y, (0x02, sp)
	jrne	00124$
	tnz	(0x01, sp)
	jreq	00104$
00124$:
;	src/main.c: 33: __asm__("nop");
	nop
	jra	00101$
00104$:
;	src/main.c: 35: }
	ldw	x, (5, sp)
	addw	sp, #10
	jp	(x)
;	src/main.c: 37: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #2
;	src/main.c: 40: uint8_t stateChanged = 1;
	ld	a, #0x01
	ld	(0x01, sp), a
;	src/main.c: 42: PD_ODR = 0x00;
	mov	0x500f+0, #0x00
;	src/main.c: 43: PC_ODR = 0x00;
	mov	0x500a+0, #0x00
;	src/main.c: 46: PC_DDR |= ((1 << Op_Pin_C3) | (1 << Op_Pin_C4) | (1 << Op_Pin_C5) | (1 << Op_Pin_C6)); /* PC3, PC4, PC5, PC6 as output */
	ld	a, 0x500c
	or	a, #0x78
	ld	0x500c, a
;	src/main.c: 47: PD_DDR |= ((1 << Op_Pin_D2) | (1 << Op_Pin_D3)); /* PD2 and PD3 as output */
	ld	a, 0x5011
	or	a, #0x0c
	ld	0x5011, a
;	src/main.c: 50: PD_DDR &= ~(1 << Ip_Pin_D4); /* PD4 as input */
	bres	0x5011, #4
;	src/main.c: 53: PC_CR1 |= (1 << Op_Pin_C3) | (1 << Op_Pin_C4) | (1 << Op_Pin_C5) | (1 << Op_Pin_C6); /* PC3, PC4, PC5, PC6 as push-pull output */
	ld	a, 0x500d
	or	a, #0x78
	ld	0x500d, a
;	src/main.c: 54: PD_CR1 |= ((1 << Ip_Pin_D4) | (1 << Op_Pin_D2) | (1 << Op_Pin_D3)); /* PD4 as input pullup, PD2 and PD3 as push-pull output */
	ld	a, 0x5012
	or	a, #0x1c
	ld	0x5012, a
;	src/main.c: 58: while (1)
00107$:
;	src/main.c: 61: Ip_Pin_state = (PD_IDR >> Ip_Pin_D4) & 0x01; /* Read PD4 state */
	ld	a, 0x5010
	srl	a
	srl	a
	srl	a
	srl	a
	and	a, #0x01
;	src/main.c: 62: if (Ip_Pin_state == 1 && stateChanged == 1) /* If PC3 is LOW */
	ld	(0x02, sp), a
	dec	a
	jreq	00145$
	jp	00102$
00145$:
	ld	a, (0x01, sp)
	dec	a
	jreq	00148$
	jp	00102$
00148$:
;	src/main.c: 64: PD_ODR = 0x00;
	mov	0x500f+0, #0x00
;	src/main.c: 65: PC_ODR = 0x00;
	mov	0x500a+0, #0x00
;	src/main.c: 66: stateChanged = 0;
	clr	(0x01, sp)
;	src/main.c: 68: PD_ODR |= (1 << Op_Pin_D3); /* Set PD2 HIGH */
	bset	0x500f, #3
;	src/main.c: 69: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 70: PD_ODR &= ~(1 << Op_Pin_D3); /* Set PD2 HIGH */
	bres	0x500f, #3
;	src/main.c: 72: PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
	bset	0x500a, #3
;	src/main.c: 73: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 74: PC_ODR &= ~(1 << Op_Pin_C3); /* Set PC4 HIGH */
	bres	0x500a, #3
;	src/main.c: 76: PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
	bset	0x500f, #2
;	src/main.c: 77: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 78: PD_ODR &= ~(1 << Op_Pin_D2); /* Set PD2 HIGH */
	bres	0x500f, #2
;	src/main.c: 80: PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
	bset	0x500a, #4
;	src/main.c: 81: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 82: PC_ODR &= ~(1 << Op_Pin_C4); /* Set PC4 HIGH */
	bres	0x500a, #4
;	src/main.c: 84: PC_ODR |= (1 << Op_Pin_C5); /* Set PC4 HIGH */
	bset	0x500a, #5
;	src/main.c: 85: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 86: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 87: PC_ODR &= ~(1 << Op_Pin_C5); /* Set PC4 HIGH */
	bres	0x500a, #5
;	src/main.c: 89: PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
	bset	0x500a, #4
;	src/main.c: 90: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 91: PC_ODR &= ~(1 << Op_Pin_C4); /* Set PC4 HIGH */
	bres	0x500a, #4
;	src/main.c: 93: PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
	bset	0x500f, #2
;	src/main.c: 94: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 95: PD_ODR &= ~(1 << Op_Pin_D2); /* Set PD2 HIGH */
	bres	0x500f, #2
;	src/main.c: 97: PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
	bset	0x500a, #3
;	src/main.c: 98: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 99: PC_ODR &= ~(1 << Op_Pin_C3); /* Set PC4 HIGH */
	bres	0x500a, #3
;	src/main.c: 101: PD_ODR |= (1 << Op_Pin_D3); /* Set PD2 HIGH */
	bset	0x500f, #3
;	src/main.c: 102: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 103: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 104: PD_ODR &= ~(1 << Op_Pin_D3); /* Set PD2 HIGH */
	bres	0x500f, #3
;	src/main.c: 106: PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
	bset	0x500a, #3
;	src/main.c: 107: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 108: PC_ODR &= ~(1 << Op_Pin_C3); /* Set PC4 HIGH */
	bres	0x500a, #3
;	src/main.c: 110: PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
	bset	0x500f, #2
;	src/main.c: 111: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 112: PD_ODR &= ~(1 << Op_Pin_D2); /* Set PD2 HIGH */
	bres	0x500f, #2
;	src/main.c: 114: PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
	bset	0x500a, #4
;	src/main.c: 115: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 116: PC_ODR &= ~(1 << Op_Pin_C4); /* Set PC4 HIGH */
	bres	0x500a, #4
;	src/main.c: 118: PC_ODR |= (1 << Op_Pin_C5); /* Set PC4 HIGH */
	bset	0x500a, #5
;	src/main.c: 119: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 120: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 121: PC_ODR &= ~(1 << Op_Pin_C5); /* Set PC4 HIGH */
	bres	0x500a, #5
;	src/main.c: 123: PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
	bset	0x500a, #4
;	src/main.c: 124: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 125: PC_ODR &= ~(1 << Op_Pin_C4); /* Set PC4 HIGH */
	bres	0x500a, #4
;	src/main.c: 127: PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
	bset	0x500f, #2
;	src/main.c: 128: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 129: PD_ODR &= ~(1 << Op_Pin_D2); /* Set PD2 HIGH */
	bres	0x500f, #2
;	src/main.c: 131: PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
	bset	0x500a, #3
;	src/main.c: 132: delay(DELAY_200MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 133: PC_ODR &= ~(1 << Op_Pin_C3); /* Set PC4 HIGH */
	bres	0x500a, #3
;	src/main.c: 135: PD_ODR |= (1 << Op_Pin_D3); /* Set PD2 HIGH */
	bset	0x500f, #3
;	src/main.c: 136: PC_ODR |= (1 << Op_Pin_C3); /* Set PC4 HIGH */
	bset	0x500a, #3
;	src/main.c: 137: PD_ODR |= (1 << Op_Pin_D2); /* Set PD2 HIGH */
	bset	0x500f, #2
;	src/main.c: 138: PC_ODR |= (1 << Op_Pin_C4); /* Set PC4 HIGH */
	bset	0x500a, #4
;	src/main.c: 139: PC_ODR |= (1 << Op_Pin_C5); /* Set PC4 HIGH */
	bset	0x500a, #5
00102$:
;	src/main.c: 143: if (Ip_Pin_state == 0) /* If PD4 is HIGH */
	tnz	(0x02, sp)
	jreq	00149$
	jp	00107$
00149$:
;	src/main.c: 145: stateChanged = 1;
	ld	a, #0x01
	ld	(0x01, sp), a
;	src/main.c: 146: PC_ODR |= ((1 << Op_Pin_C3) | (1 << Op_Pin_C4) | (1 << Op_Pin_C5)); /* Set PC4 HIGH */
	ld	a, 0x500a
	or	a, #0x38
	ld	0x500a, a
;	src/main.c: 147: PD_ODR |= ((1 << Op_Pin_D2) | (1<< Op_Pin_D3)); /* Set PD2 HIGH */
	ld	a, 0x500f
	or	a, #0x0c
	ld	0x500f, a
;	src/main.c: 150: }
	jp	00107$
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
