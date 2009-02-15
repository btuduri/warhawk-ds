#include "warhawk.h"
#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"
#include "sprite.h"
#include "ipc.h"

	.global alienFireInit
	.global alienFireMove
	.global findAlienFire
	
	@ Fire types
	@ 1-4	=	Directional 1=up, 2=right, 3=down, 4=left (speed 2)
	@ 5-6	=	Directional with Vertical move 5=right, 6=left (move down with scroller) (Speed 2)
	@ 7-10	=	Directional 7=up, 8=right, 9=down, 10=left (speed 4)
	@ 11-12	=	Directional with Vertical move 5=right, 6=left (move down with scroller) (Speed 4)
	@ 13	=	Standard "Warhawk" tracker shot
	.arm
	.align

@
@----------------- INITIALISE A SHOT 
@

alienFireInit:
	stmfd sp!, {r0-r10, lr}
	@ This initialises and aliens bullet
	@ REMEMBER, 	R1 = our aliens offset (we can use this to get coords) (must use sptXXXOffs)
	@ 				R3 = our fire type to initialise (passed from moveAliens)
	@
	ldr r4,=spriteX
	ldr r4,[r4]
	ldr r5,=spriteY
	ldr r5,[r5]
	@---------- All our inits follow from here - SEQUENTIALLY ---------@
	
	cmp r3,#19					@ check and init standard linear shots types 1-12
		blmi initStandardShot
	cmp r3,#19
		bleq initTrackerShot
	@ etc!

	alienFireInitDone:
	ldmfd sp!, {r0-r10, pc}

@	
@----------------- MOVE ALIEN BULLETS AND CHECK COLLISIONS
@

alienFireMove:
	stmfd sp!, {r0-r10, lr}
	@ here. we need to step through all alien bullets and check type
	@ and from that we will bl to code to act on it :)
	@ and then return to the main loop!
		ldr r0,=spriteX
		ldr r0,[r0]							@ set r0 to player x
		ldr r1,=horizDrift
		ldr r1,[r1]
		add r0,r1							@ and add the horizontal drift value
		ldr r1,=spriteY
		ldr r1,[r1]							@ set r1 to player y
	
		ldr r5,=spriteActive				@ R5 is pointer to bullet base
		mov r4, #81							@ alien bullet are 81-112 (32)
		findAlienBullet:
			ldr r3,[r5,r4, lsl #2]			@ Multiplied by 4 as in words
			cmp r3,#0
			beq testSkip
				mov r2,r5					@ mov r5 into r2 as bullet base
				add r2,r4, lsl #2			@ Set r2 to bullets offset
				mov r3,#sptFireTypeOffs
				ldr r3,[r2,r3]				@ r3= fire type to update
	
				cmp r3,#19					@ check for standard shot 1-12
					blmi moveStandardShot	
				cmp r3,#19
					bleq moveTrackerShot
				@ ETC

			testSkip:
			add r4,#1
			cmp r4,#113
		bne findAlienBullet		
	
	@ and from here we need to check if the bullet is on our ship
	@ and if so, deplete energy, mainloop will act on a 0 and kill us!
	
	ldmfd sp!, {r0-r10, pc}
	
@----------------- FIND A SPARE SLOT FOR A BULLET
	@ be warned - this modifies r2,r5
	@ this returns r2=	sprite offset to use
	@					or 255, if none available
findAlienFire:
	stmfd sp!, {r0,r1,r3,r4,r5,lr}
		mov r4, #81					@ alien bullet are 81-112 (32)
		ldr r2, =spriteActive
		isAlienFirePossible:
			ldr r5,[r2,r4, lsl #2]	@ Multiplied by 4 as in words
			cmp r5,#0
			beq findAlienFireDone
			add r4,#1
			cmp r4,#113
		bne isAlienFirePossible
		mov r2,#255					@ set to 255 to signal "NO SPACE FOR FIRE"
		ldmfd sp!, {r0,r1,r3,r4,r5,pc}
		findAlienFireDone:
		add r2, r4, lsl #2			@ return r2 as pointer to bullet
	ldmfd sp!, {r0,r1,r3,r4,r5,pc}
.end
