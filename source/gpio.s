@ Returns the adress of the GPIO
.globl GetGpioAddress
GetGpioAddress:
	ldr r0, =0x20200000
	mov pc,lr


@ Sets function of a GPIO pin
@ input: r0 - GPIO pin no.
@			r1 - function
.globl SetGpioFunction
SetGpioFunction:

	@ check sanitary input:
	cmp r0, #53		@ 54 pins
	cmpls r1, #7	@ only run if r0 <= 53.
	movhi pc, lr	@ return if either input fails.

	push {lr}		@ put return address on the stack
	push {r4}
	mov r2, r0		@ save r0. 
	bl GetGpioAddress

	@ Need to know which block of 10 our pin is in.
	functionLoop$:
		cmp r2, #9
		subhi r2, #10		@ If pin > 9, sub 10 from number
		addhi r0, #4		@ and add 4 to gpio pin
		bhi functionLoop$ @ keep going if we need to
	
	@ TODO only set value of bits to be changed (use boolean ops).
	add r2, r2, lsl #1	@ r2 += r2 << 1
	lsl r1, r2				@ shift funtion value r2 places

	@ What to do on high-leve: bitmask 111, shift to bits to change.
	@ NOT bitmask, then AND  with errything to set changing set of 3 bits to 000 but save others.
	@ then add shifted funtion to bitmask result.
	ldr r3, [r0]			@ load what we currently have at pin
	 mov r4, #7				@ bitmask.
	lsl r4, r2				@ shift
	mvn r4, r4				@ r4 = ! r4 ( I think)
	and r3, r3, r4			@ r3 = r3 AND r4
	add r1, r3
	str r1,[r0]				@ store function
	pop {r4}
	pop {pc}					@ return.

@ Sets a GPIO pin on or off
@ input: r0 - GPIO pin number
@			r1 - turn off if 0, on otherwise
.globl SetGpio
SetGpio:
	pinNum .req r0
	pinVal .req r1		@ aliasing.

	cmp pinNum,#53
	movhi pc,lr 
	push {lr}
	mov r2, pinNum
	.unreq pinNum
	pinNum .req r2
	bl GetGpioAddress
	gpioAddr .req r0

	pinBank .req r3
	lsr pinBank,pinNum,#5
	lsl pinBank,#2
	add gpioAddr, pinBank
	.unreq pinBank

	and pinNum, #31
	setBit .req r3
	mov setBit, #1
	lsl setBit, pinNum
	.unreq pinNum

	teq pinVal, #0
	.unreq pinVal
	streq setBit,[gpioAddr, #40]
	strne setBit,[gpioAddr, #28]
	.unreq setBit
	.unreq gpioAddr
	pop {pc}

