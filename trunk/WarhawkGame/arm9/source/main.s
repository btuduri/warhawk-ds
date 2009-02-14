@
@ Release V0.22
@
@ ps. you can kill trackers by swinging them off the bottom of the screen!

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
	.global initSystem
	.global main
	.global debugDigits

initSystem:
	bx lr

main:
	@ Setup the screens and the sprites	

	bl initVideo
	bl initSprites
	bl initData

	@ firstly, lets draw all the screen data ready for play
	@ and display the ship sprite
	
@	bl waitforVblank
	bl clearBG0
	bl clearBG1
	bl clearBG2
	bl clearBG3
	bl drawMapScreenMain
	bl drawMapScreenSub
	bl drawSFMapScreenMain
	bl drawSFMapScreenSub
	bl drawSBMapScreenMain
	bl drawSBMapScreenSub
	bl drawScore
	bl drawSprite
	bl drawGetReadyText
	@bl playInGameMusic

	bl waitforFire		@ wait for a short while to start game
	mov r1,#1			@ just for checking (though this would NEVER be active at level start)
	ldr r0,=powerUp
	str r1,[r0]
	
	bl clearBG0
	bl drawAllEnergyBars

@----------------------------@	
@ This is the MAIN game loop @
@----------------------------@
gameLoop:

	bl waitforVblank
	@--------------------------------------------
	@ this code is executed offscreen
	@--------------------------------------------
		
		bl moveShip			@ check and move your ship
		
		bl scrollMain		@ Scroll Level Data
		bl scrollSub		@ Main + Sub
		bl levelDrift		@ update level with the horizontal drift
		bl moveBullets		@ check and then moves bullets
		bl alienFireMove	@ check and move alien bullets
		bl fireCheck		@ check for your wish to shoot!

		bl moveAliens		@ move the aliens and detect colisions with you

		bl drawScore		@ update the score with any changes

		
		bl scrollStars		@ Scroll Stars (BG2,BG3)

		bl checkWave		@ check if time for another alien attack
		
		bl checkEndOfLevel	@ Set Flag for end-of-level (use later to init BOSS)

		bl drawSprite		@ drawsprites and do update bloom effect

@		bl drawDebugText	@ draw some numbers :)

	bl waitforNoblank
	
	@---------------------------------------------
	@ this code is executed during refresh
	@ this should give us a bit more time in vblank
	@---------------------------------------------
			

	b gameLoop			@ our main loop
	
	@ we will end up with more code here for game over and death
	@ also for return to title!

@------------------------------------------------------------------------------
