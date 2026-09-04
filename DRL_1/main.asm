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
;	src/main.c: 17: void delay(uint32_t count)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #4
;	src/main.c: 19: while (count--)
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
;	src/main.c: 21: __asm__("nop");
	nop
	jra	00101$
00104$:
;	src/main.c: 23: }
	ldw	x, (5, sp)
	addw	sp, #10
	jp	(x)
;	src/main.c: 25: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #3
;	src/main.c: 28: uint8_t stateChanged = 1;
	ld	a, #0x01
	ld	(0x01, sp), a
;	src/main.c: 30: PC_DDR |= (1 << 4);
	bset	0x500c, #4
;	src/main.c: 31: PC_DDR &= ~(1 << 3); /* PC3 as input */
	bres	0x500c, #3
;	src/main.c: 34: PC_CR1 |= (1 << 4);
	bset	0x500d, #4
;	src/main.c: 35: PC_CR1 |= (1 << 3); /* PC3 as input pullup */
	bset	0x500d, #3
;	src/main.c: 39: while (1)
00108$:
;	src/main.c: 42: Ip_Pin_state = (PC_IDR >> Ip_Pin) & 0x01; /* Read PC3 state */
	ld	a, 0x500b
	swap	a
	sll	a
	clr	a
	rlc	a
;	src/main.c: 43: if (Ip_Pin_state == 1 && stateChanged == 1) /* If PC3 is LOW */
	ld	(0x02, sp), a
	dec	a
	jrne	00103$
	ld	a, (0x01, sp)
	dec	a
	jrne	00103$
;	src/main.c: 45: stateChanged = 0;
	clr	(0x01, sp)
;	src/main.c: 46: for (uint32_t i = 0; i < 6; i++)
	clr	(0x03, sp)
00111$:
	ld	a, (0x03, sp)
	cp	a, #0x06
	jrnc	00103$
;	src/main.c: 48: PC_ODR |= (1 << 4); /* Set PC4 HIGH */
	bset	0x500a, #4
;	src/main.c: 49: delay(DELAY_500MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 50: PC_ODR &= ~(1 << 4); /* Set PC4 LOW */
	bres	0x500a, #4
;	src/main.c: 51: delay(DELAY_500MS_COUNT); /* Delay for a while */
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
;	src/main.c: 46: for (uint32_t i = 0; i < 6; i++)
	inc	(0x03, sp)
	jra	00111$
00103$:
;	src/main.c: 54: if (Ip_Pin_state == 0) /* If PC3 is HIGH */
	tnz	(0x02, sp)
	jrne	00106$
;	src/main.c: 56: stateChanged = 1;
	ld	a, #0x01
	ld	(0x01, sp), a
00106$:
;	src/main.c: 59: PC_ODR |= (1 << 4); /* Set PC4 HIGH */
	bset	0x500a, #4
	jra	00108$
;	src/main.c: 61: }
	addw	sp, #3
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
