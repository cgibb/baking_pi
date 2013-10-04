.section .init
.globl _start
_start:

ldr r0, =0x20200000 	@ store this value for later
							@ address of GPIO controller.

@ Enables pin 16 on GPIO
mov r1, #1
lsl r1, #18
str r1, [r0,#4]

loop$:
	mov r2, #0x3F0000
	wait1$:
		sub r2, #1		@ r2 -= 1
		cmp r2, #0 		@ same as in Y86
		bne wait1$		@ done waiting if r2 = 0

	@ Code to turn light on:

	mov r1, #1
	lsl r1, #16
	str r1, [r0,#40]

	mov r2, #0x3F0000
	wait2$:
		sub r2, #1		@ r2 -= 1
		cmp r2, #0 		@ same as in Y86
		bne wait2$		@ done waiting if r2 = 0

	mov r1, #1
	lsl r1, #16
	str r1, [r0,#28]

b loop$

