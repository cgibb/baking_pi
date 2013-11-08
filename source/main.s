.section .init
.globl _start
_start:
b main

.section .text
main:
mov sp, #0x8000


@ Enables pin 16 on GPIO
mov r0, #16
mov r1, #1
bl SetGpioFunction

loop$:

	@ Code to turn light on:
	mov r0, #16
	mov r1, #0
	bl SetGpio

	mov r2, #0x3F0000
	wait2$:
		sub r2, #1		@ r2 -= 1
		cmp r2, #0 		@ same as in Y86
		bne wait2$		@ done waiting if r2 = 0

	mov r0, #16
	mov r1, #1
	bl SetGpio

	mov r2, #0x3F0000
	wait1$:
		sub r2, #1		@ r2 -= 1
		cmp r2, #0 		@ same as in Y86
		bne wait1$		@ done waiting if r2 = 0

b loop$

