#include "warhawk.h"
#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"
#include "sprite.h"
#include "ipc.h"

	.arm
	.align
	.global drawDebugText
	.global drawGetReadyText
	.global drawText
	.global drawDigits
	
drawDebugText:
	stmfd sp!, {r0-r10, lr}
	
	ldr r0, =spriteXText			@ Load out text pointer
	ldr r1, =0						@ x pos
	ldr r2, =0						@ y pos
	ldr r3, =1						@ Draw on Sub screen
	bl drawText
	
	ldr r10,=spriteX				@ Pointer to data
	ldr r10,[r10]					@ Read value
	mov r8,#0						@ y pos
	mov r9,#3						@ Number of digits
	mov r11, #9						@ x pos
	bl drawDigits					@ Draw
	
	
	ldr r0, =spriteYText			@ Load out text pointer
	ldr r1, =0						@ x pos
	ldr r2, =2						@ y pos
	ldr r3, =1						@ Draw on Sub screen
	bl drawText
		
	ldr r10,=spriteY				@ Pointer to data
	ldr r10,[r10]					@ Read value
	mov r8,#2						@ y pos
	mov r9,#3						@ Number of digits
	mov r11, #9						@ x pos
	bl drawDigits					@ Draw

	ldr r0, =vofsSubText			@ Load out text pointer
	ldr r1, =0						@ x pos
	ldr r2, =4						@ y pos
	ldr r3, =1						@ Draw on Sub screen
	bl drawText

	ldr r10,=vofsSub				@ Pointer to data
	ldr r10,[r10]					@ Read value
	mov r8,#4						@ y pos
	mov r9,#3						@ Number of digits
	mov r11, #9						@ x pos
	bl drawDigits					@ Draw
	
	ldr r0, =yposSubText			@ Load out text pointer
	ldr r1, =0						@ x pos
	ldr r2, =6						@ y pos
	ldr r3, =1						@ Draw on Sub screen
	bl drawText
	
	ldr r10,=yposSub				@ Pointer to data
	ldr r10,[r10]					@ Read value
	mov r8,#6						@ y pos
	mov r9,#4						@ Number of digits
	mov r11, #9						@ x pos
	bl drawDigits					@ Draw

	ldr r10,=REG_VCOUNT				@ Pointer to data
	ldrh r10,[r10]					@ Read value
	mov r8,#20						@ y pos
	mov r9,#3						@ Number of digits
	mov r11, #0						@ x pos
	bl drawDigits					@ Draw


	ldmfd sp!, {r0-r10, pc}
	
drawGetReadyText:

	stmfd sp!, {r0-r3, lr} 

	ldr r0, =getReadyText			@ Load out text pointer
	ldr r1, =11						@ x pos
	ldr r2, =10						@ y pos
	ldr r3, =0						@ Draw on main screen
	bl drawText
	
	ldr r0, =getReadyText			@ Load out text pointer
	ldr r1, =11						@ x pos
	ldr r2, =10						@ y pos
	ldr r3, =1						@ Draw on sub screen
	bl drawText
	
	ldmfd sp!, {r0-r3, pc}

drawText:
	
	@ r0 = pointer to null terminated text
	@ r1 = x pos
	@ r2 = y pos
	@ r3 = 0 = Main, 1 = Sub

	stmfd sp!, {r4-r6, lr} 
	
	ldr r4, =BG_MAP_RAM(BG0_MAP_BASE)	@ make r4 a pointer to main
	ldr r5, =BG_MAP_RAM_SUB(BG0_MAP_BASE_SUB) @ make r5 a pointer to sub
	cmp r3, #1						@ Draw on sub screen?
	moveq r4, r5					@ Yes so store subscreen pointer
	add r4, r1, lsl #1				@ Add x position
	add r4, r2, lsl #6				@ Add y multiplied by 64

textLoop:
	ldrb r5, [r0], #1				@ Read r1 [text] and add 1 to [text] offset
	cmp r5, #0						@ Null character?
	beq textDone					@ Yes so were done
	sub r5, #32						@ ASCII character - 32 to get tile offset
	add r5, #42						@ Skip 42 tiles (score digits)
	strh r5, [r4], #2				@ Write the tile number to our 32x32 map and move along
	bl textLoop

textDone:
	
	ldmfd sp!, {r4-r6, pc}

drawDigits:
	@ Ok, to use this we need to pass it a few things!!!
	@ r10 = number to display
	@ r8 = height to display to
	@ r9 = number of Digits to display
	@ r11 = X coord
	stmfd sp!, {r0-r10, lr}
	cmp r9,#0						@ if you forget to set r9 (or are using it)
	moveq r9,#4						@ we will default to 4 digits

	ldr r5,=digits					@ r5 = pointer to our digit store	
	mov r1,#31
	mov r2,#0
	
	debugClear:						@ clear our digits
		strb r2,[r5,r1]
		subs r1,#1
	bpl debugClear
	
	mov r6,#31						@ r6 is the digit we are to store 0-31 (USING WORDS)
	mov r1,r10
	convertLoop:	
		mov r2,#10					@ This is our divider
		bl divideNumber				@ call our code to divide r1 by r2 and return r0 with fraction
		strb r1,[r5,r6]			@ lets store our fraction in our digit data
		mov r1,r0					@ put the result back in r1 (original r1/10)
		sub r6,#1					@ take one off our digit counter
		cmp r1,#0					@ is our result 0 yet, if not, we have more to do
	bne convertLoop	

	ldr r0, =BG_MAP_RAM_SUB(BG0_MAP_BASE_SUB)	@ make r0 a pointer to screen memory bg bitmap sub address
	mov r1,#0
	add r1, r8, lsl #6
	add r0, r1
	add r0, r11, lsl #1
	ldr r1, =digits					@ Get address of text characters to draw

	mov r2,#32
	sub r2,r9						
	add r1,r2						@ r1 = offset from digit reletive to number of digits to draw (r8)
	mov r2,r9						@ r2 = number of digits to draw

digitsLoop:
	ldrb r3,[r1],#1					@ Read r1 [text] and add 1 to [text] offset
	add r3,#136						@ offset for 0. We only have chars as a tile in sub screen (+136 for our c64 digits)
	strh r3, [r0], #2				@ Write the tile number to our 32x32 map and move along
	subs r2, #1						@ Move along one
	bne digitsLoop					@ And loop back until done
	
	
	ldmfd sp!, {r0-r10, pc}