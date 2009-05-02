@ Copyright (c) 2009 Proteus Developments / Headsoft
@ 
@ Permission is hereby granted, free of charge, to any person obtaining
@ a copy of this software and associated documentation files (the
@ "Software"), to deal in the Software without restriction, including
@ without limitation the rights to use, copy, modify, merge, publish,
@ distribute, sublicense, and/or sell copies of the Software, and to
@ permit persons to whom the Software is furnished to do so, subject to
@ the following conditions:
@ 
@ The above copyright notice and this permission notice shall be included
@ in all copies or substantial portions of the Software.
@ 
@ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
@ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
@ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
@ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
@ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
@ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
@ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#include "system.h"
#include "interrupts.h"
#include "audio.h"
#include "ipc.h"

	#define AUDIO_PLAY_SOUND			0
	#define AUDIO_PLAY_MUSIC			1
	#define AUDIO_STOP_MUSIC			2

	.arm
	.align
	.text
	.global main
	
interruptHandlerVCount:

	stmfd sp!, {lr}
	
	@bl checkLid

	ldmfd sp!, {pc} 							@ restore registers and return

	@ ------------------------------------
	
interruptHandlerVBlank:

	stmfd sp!, {r0-r3, lr}
	
	ldr r0, =IPC_SOUND_DATA(0)					@ Get a pointer to the sound data in IPC
	ldr r1, [r0]								@ Read the value
	cmp r1, #-1									@ Stop music value?
	bleq stopMusic								@ Stop music
	
	ldr r0, =IPC_SOUND_DATA(0)					@ Get a pointer to the sound data in IPC
	ldr r1, [r0]								@ Read the value
	cmp r1, #0									@ Is there data there?
	blne playMusic								@ If so lets play the sound
	
	ldr r0, =IPC_SOUND_DATA(1)					@ Get a pointer to the sound data in IPC
	ldr r1, [r0]								@ Read the value
	cmp r1, #-1									@ Stop sound value?
	bleq stopSound								@ Stop sound
	
	ldr r0, =IPC_SOUND_DATA(1)					@ Get a pointer to the sound data in IPC
	ldr r1, [r0]								@ Read the value
	cmp r1, #0									@ Is there data there?
	blne playSound								@ If so lets play the sound
	
interruptHandlerVBlankDone:
	
	ldmfd sp!, {r0-r3, pc} 					@ restore registers and return

	@ ------------------------------------
	
interruptHandlerIPC:

	stmfd sp!, {r0-r3, lr}
	
	ldr r0, =REG_IPC_SYNC
	ldrh r1, [r0]
	and r1, #0xF
	cmp r1, #AUDIO_PLAY_SOUND
	bleq playSound
	@cmp r1, #AUDIO_PLAY_MUSIC
	@bleq playMusic
	@cmp r1, #AUDIO_STOP_MUSIC
	@bleq stopMusic
	
	ldmfd sp!, {r0-r3, pc} 					@ restore registers and return

	@ ------------------------------------
	
main:
	bl irqInit									@ Initialize Interrupts
	
	ldr r0, =IRQ_VCOUNT							@ VCOUNT interrupt
	ldr r1, =interruptHandlerVCount				@ Function Address
	bl irqSet									@ Set the interrupt
		
	ldr r0, =IRQ_VBLANK							@ VBLANK interrupt
	ldr r1, =interruptHandlerVBlank				@ Function Address
	bl irqSet									@ Set the interrupt
	
	@ldr r0, =IRQ_IPC_SYNC						@ IPC_SYNC interrupt
	@ldr r1, =interruptHandlerIPC				@ Function Address
	@bl irqSet									@ Set the interrupt
	
	@ldr r0, =(IRQ_VCOUNT | IRQ_VBLANK | IRQ_IPC_SYNC)		@ Interrupts
	ldr r0, =(IRQ_VCOUNT | IRQ_VBLANK)			@ Interrupts
	bl irqEnable								@ Enable
	
	@ldr r0, =REG_IPC_SYNC
	@ldr r1, =IPC_SYNC_IRQ_ENABLE
	@strh r1, [r0]
	
	ldr r0, =REG_POWERCNT
	ldr r1, =POWER_SOUND						@ Turn on sound
	str r1, [r0]
	
	ldr r0, =SOUND_CR							@ This just turns on global sound and sets volume
	ldr r1, =(SOUND_ENABLE | SOUND_VOL(127))	@ Turn on sound
	strh r1, [r0]
	
mainLoop:

	bl swiWaitForVBlank
	
	b mainLoop
	
	@ ------------------------------------
	
playMusic:

	stmfd sp!, {r0-r3, lr}
	
	ldr r0, =SCHANNEL_CR(0)
	ldr r1, =SCHANNEL_CR(1)
	mov r2, #0
	str r2, [r0]
	str r2, [r1]
	
	ldr r0, =SCHANNEL_TIMER(0)
	ldr r1, =SCHANNEL_TIMER(1)
	ldr r2, =SOUND_FREQ(32000)					@ Frequency currently hard-coded to 32000 Hz
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =SCHANNEL_SOURCE(0)					@ Channel source
	ldr r1, =SCHANNEL_SOURCE(1)					@ Channel source
	ldr r2, =IPC_SOUND_DATA(0)					@ Lets get first sound in IPC
	ldr r3, [r2]								@ Read the value
	str r3, [r0]								@ Write the value
	str r3, [r1]								@ Write the value
	
	ldr r0, =SCHANNEL_LENGTH(0)
	ldr r1, =SCHANNEL_LENGTH(1)
	ldr r2, =IPC_SOUND_LEN(0)					@ Get the location of the sound length
	ldr r3, [r2]								@ Read the value
	and r3, #(~7)								@ Multiple of 4 bytes
	and r3, #0x7FFFFFFF							@ And with 0x7FFFFFFF
	lsr r3, #2									@ Right shift (LEN >> 2)
	str r3, [r0]								@ Write the value
	str r3, [r1]								@ Write the value
	
	ldr r0, =SCHANNEL_REPEAT_POINT(0)
	ldr r1, =SCHANNEL_REPEAT_POINT(1)
	mov r2, #0
	strh r2, [r0]
	strh r2, [r1]
	
	ldr r0, =SCHANNEL_CR(0)
	ldr r1, =SCHANNEL_CR(1)
	ldr r2, =(SCHANNEL_ENABLE | SOUND_REPEAT | SOUND_VOL(127) | SOUND_PAN(0))
	str r2, [r0]
	ldr r2, =(SCHANNEL_ENABLE | SOUND_REPEAT | SOUND_VOL(127) | SOUND_PAN(127))
	str r2, [r1]
	
	ldr r0, =IPC_SOUND_DATA(0)					@ Get a pointer to the sound data in IPC
	mov r1, #0
	str r1, [r0]								@ Clear the value so it wont play again

	ldmfd sp!, {r0-r3, pc} 					@ restore rgisters and return
	
	@ ------------------------------------
	
stopMusic:

	stmfd sp!, {r0-r3, lr}
	
	ldr r0, =SCHANNEL_CR(0)
	ldr r1, =SCHANNEL_CR(1)
	mov r2, #0
	str r2, [r0]
	str r2, [r1]
	
	ldr r0, =IPC_SOUND_DATA(0)					@ Get a pointer to the sound data in IPC
	mov r1, #0
	str r1, [r0]								@ Clear the value so it wont play again

	ldmfd sp!, {r0-r3, pc} 					@ restore rgisters and return
	
	@ ------------------------------------
	
playSound:

	stmfd sp!, {r0-r3, lr}
	
	ldr r0, =IPC_SOUND_DATA(1)					@ Get a pointer to the sound data in IPC
	ldr r1, [r0]								@ Read the value
	cmp r1, #0									@ Is there data there?
	beq playSoundDone							@ If not lets not play a sound
	
	bl getFreeChannel
	cmp r0, #-1
	beq playSoundDone

	mov r3, r0, lsl #4
	
	ldr r0, =SCHANNEL_CR(0)
	mov r1, #0
	str r1, [r0, r3]
	
	ldr r0, =SCHANNEL_TIMER(0)
	ldr r1, =SOUND_FREQ(11025)					@ Frequency currently hard-coded to 11025 Hz
	strh r1, [r0, r3]
	
	ldr r0, =SCHANNEL_SOURCE(0)					@ Channel source
	ldr r1, =IPC_SOUND_DATA(1)					@ Lets get first sound in IPC
	ldr r2, [r1]								@ Read the value
	str r2, [r0, r3]							@ Write the value
	
	ldr r0, =SCHANNEL_LENGTH(0)
	ldr r1, =IPC_SOUND_LEN(1)					@ Get the location of the sound length
	ldr r2, [r1]								@ Read the value
	and r2, #(~7)								@ Multiple of 4 bytes
	and r2, #0x7FFFFFFF							@ And with 0x7FFFFFFF
	lsr r2, #2									@ Right shift (LEN >> 2)
	str r2, [r0, r3]							@ Write the value
	
	ldr r0, =SCHANNEL_REPEAT_POINT(0)
	mov r1, #0
	strh r1, [r0, r3]
	
	ldr r0, =SCHANNEL_CR(0)
	ldr r1, =(SCHANNEL_ENABLE | SOUND_ONE_SHOT | SOUND_VOL(127) | SOUND_PAN(64) | SOUND_8BIT)
	str r1, [r0, r3]
	
playSoundDone:
	
	ldr r0, =IPC_SOUND_DATA(1)					@ Get a pointer to the sound data in IPC
	mov r1, #0
	str r1, [r0]					

	ldmfd sp!, {r0-r3, pc} 					@ restore registers and return
	
	@ ------------------------------------
	
stopSound:

	stmfd sp!, {r0-r3, lr}
	
	mov r0, #15									@ Reset the counter
	ldr r1, =SCHANNEL_CR(0)						@ This is the base address of the sound channel
	mov r2, #0									@ Clear
	
stopSoundLoop:
	
	str r2, [r1, r0, lsl #4]					@ Add the offset (0x04000400 + ((n)<<4))
	subs r0, #1									@ sub one from our counter
	bpl stopSoundLoop							@ back to our loop

	ldr r0, =IPC_SOUND_DATA(1)					@ Get a pointer to the sound data in IPC
	mov r1, #0
	str r1, [r0]

	ldmfd sp!, {r0-r3, pc} 					@ restore registers and return
	
	@ ------------------------------------
	
getFreeChannel:

	@ RetVal r0 = channel number (0 - 15)

	stmfd sp!, {r1-r3, lr}

	mov r0, #15									@ Reset the counter
	ldr r1, =SCHANNEL_CR(0)						@ This is the base address of the sound channel
	
getFreeChannelLoop:
	
	ldr r2, [r1, r0, lsl #4]					@ Add the offset (0x04000400 + ((n)<<4))
	tst r2, #SCHANNEL_ENABLE					@ Is the sound channel enabled?
	beq getFreeChannelFound						@ (if not equal = channel clear)
	subs r0, #1									@ sub one from our counter
	bpl getFreeChannelLoop						@ keep looking
	mov r0, #-1

getFreeChannelFound:

	ldmfd sp!, {r1-r3, pc}						@ restore registers and return
	
	@ ------------------------------------

	.pool
	.end
