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
	.text
	
	.global playInGameMusic
	.global playBlasterSound				@ Use = Normal Fire
	.global playExplosionSound
	.global playAlienExplodeSound
	.global playAlienExplodeScreamSound
	.global playElecShotSound
	.global playLaserShotSound
	.global playShipArmourHit1Sound
	.global playShipArmourHit2Sound
	.global playClassicSound
	.global playCrashBuzSound				@ Use = Low Energy
	.global playDinkDinkSound
	.global playHitWallSound
	.global playLowSound
	.global playSteelSound

playInGameMusic:
	stmfd sp!, {r0-r1, lr}

	ldr r0, =IPC_SOUND_LEN(0)		@ Get the IPC sound length address
	ldr r1, =InGameMusicLen			@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(0)		@ Get the IPC sound data address
	ldr r1, =ingame_wav				@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r1, pc} 		@ restore registers and return
	
playBlasterSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =BlasterLen				@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =blaster_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return
	
playExplosionSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =ExplosionLen			@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =explosion_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return
	
playAlienExplodeSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =AlienExplodeLen		@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =alien_explode_raw		@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return

playAlienExplodeScreamSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =AlienExplodeScreamLen	@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =alien_explode_scream_raw		@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return

playElecShotSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =ElecShotLen			@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =elecshot_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return
	
playLaserShotSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =LaserShotLen			@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =lasershot_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return

playShipArmourHit1Sound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =ShipArmourHit1Len		@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =ship_armour_hit1_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return
	
playShipArmourHit2Sound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =ShipArmourHit2Len		@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =ship_armour_hit2_raw	@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return
	
playClassicSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =ClassicLen				@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =classic_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return

playCrashBuzSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =CrashBuzLen				@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =crashbuz_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return

playDinkDinkSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =DinkDinkLen			@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =dinkdink_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return

playHitWallSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =HitWallLen				@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =hitwall_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return
	
playLowSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =LowLen					@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =low_raw				@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return
	
playSteelSound:
	stmfd sp!, {r0-r2, lr}

	ldr r0, =IPC_SOUND_LEN(1)		@ Get the IPC sound length address
	ldr r1, =SteelLen				@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(1)		@ Get the IPC sound data address
	ldr r1, =steel_raw				@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r2, pc} 		@ restore registers and return
	
	.pool
	.end