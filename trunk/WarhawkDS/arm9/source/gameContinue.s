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

	#define MENUITEM_RESTART		0
	#define MENUITEM_STARTLEVEL		1
	#define MENUITEM_MENTALVERSION	2

	#define MENUITEM_COUNT			3
	#define ARROW_COLOR_OFFSET		11

	.arm
	.align
	.text
	.global showGameContinueMenu
	.global updateGameContinueMenu
	
showGameContinueMenu:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =optionLevelNum						@ Read optionLevelNum address
	ldr r0, [r0]								@ Read optionLevelNum value
	
	cmp r0, #1									@ Is optionLevelNum <= 1
	ble showGameContinueMenuGameStart			@ Yes then go to game start
	
	ldr r1, =levelNum
	str r0, [r1]
	
	ldr r0, =gameMode							@ Get gameMode address
	ldr r1, =GAMEMODE_GAMECONTINUE				@ Set the gameMode to continue game
	str r1, [r0]								@ Store back gameMode
	
	bl clearBG0Sub
	
	ldr r0, =menuNum							@ Reset menuNum
	mov r1, #0
	str r1, [r0]

	@ Write the tile data to VRAM
	
	ldr r0, =ArrowSpriteTiles					@ Load cursor sprite tiles
	ldr r1, =SPRITE_GFX_SUB
	ldr r2, =ArrowSpriteTilesLen
	bl dmaCopy
	
	ldr r0, =ContinueText						@ Load out text pointer
	ldr r1, =7									@ x pos
	ldr r2, =11									@ y pos
	ldr r3, =1									@ Draw on sub screen
	bl drawText
	
	bl fxCopperTextOn
	
	ldr r0, =colorHilight
	mov r1, #14
	str r1, [r0]
	
	ldr r0,=buttonWaitPress
	mov r1,#1
	str r1,[r0]									@ set button active (start)
	
	b showGameContinueMenuDone
	
showGameContinueMenuGameStart:

	bl showGameStart
	
showGameContinueMenuDone:
	
	ldmfd sp!, {r0-r6, pc} 					@ restore registers and return
	
	@---------------------------------
	
updateGameContinueMenu:

	stmfd sp!, {r0-r6, lr}
		
	bl readInput								@ read the input
	
	cmp r0, #1									@ if it is 1, keep pressed (from no-key pressed)
	bne updateGameContinueMenuContinue
	
	ldr r0, =menuNum							@ Load menuNum address
	ldr r1, [r0]								@ Load menuNum value
	
	ldr r2, =REG_KEYINPUT						@ Read key input register
	ldr r3, [r2]								@ Read key input value
	tst r3, #BUTTON_UP							@ Button up?
	subeq r1, #1								@ Move menu up
	tst r3, #BUTTON_DOWN						@ Button down?
	addeq r1, #1								@ Move menu down
	
	cmp r1, #0									@ menuNum 0
	movlt r1, #MENUITEM_COUNT - 1				@ menuNum < 0 then make it MENUITEM_COUNT
	cmp r1, #MENUITEM_COUNT - 1					@ menuNum (MENU_ITEM_COUNT - 1)?
	movgt r1, #0								@ menuNum > MENUITEM_COUNT then make it (MENU_ITEM_COUNT - 1)
	
	ldr r4, =colorHilight
	mov r5, #0
	add r5, r1, lsl #1
	add r5, #14
	str r5, [r4]
	str r1, [r0]
	
	cmp r1, #MENUITEM_RESTART
	beq updateGameContinueMenuContinue
	cmp r1, #MENUITEM_STARTLEVEL
	beq updateGameContinueMenuStartLevel
	cmp r1, #MENUITEM_MENTALVERSION
	beq updateGameContinueMenuMentalVersion
	b updateGameContinueMenuContinue
	
updateGameContinueMenuMentalVersion:

	ldr r0, =optionMentalVer					@ Load optionMentalVer address
	ldr r1, [r0]								@ Load optionMentalVer value
	
	tst r3, #BUTTON_LEFT						@ Button left?
	mvneq r1, r1								@ Move cursor left
	tst r3, #BUTTON_RIGHT						@ Button right?
	mvneq r1, r1								@ Move cursor right

	and r1, #1
	str r1, [r0]

	b updateGameContinueMenuContinue

updateGameContinueMenuStartLevel:

	ldr r0, =levelNum							@ Load levelNum address
	ldr r1, [r0]								@ Load levelNum value
	
	tst r3, #BUTTON_LEFT						@ Button left?
	subeq r1, #1								@ Move cursor left
	tst r3, #BUTTON_RIGHT						@ Button right?
	addeq r1, #1								@ Move cursor right
	
	ldr r2, =optionLevelNum
	ldr r2, [r2]
	
	cmp r1, #1									@ levelNum 0
	movlt r1, #1								@ levelNum < 0 then make it 0
	cmp r1, r2									@ levelNum optionLevelNum?
	movgt r1, r2								@ levelNum > optionLevelNum then make it optionLevelNum
	cmp r1, #LEVEL_COUNT						@ levelNum LEVEL_COUNT?
	movgt r1, #LEVEL_COUNT						@ levelNum > LEVEL_COUNT then make it 2
	
	str r1, [r0]
	
updateGameContinueMenuContinue:

	bl scrollStarsHoriz							@ Scroll stars
	bl updateLogoSprites						@ Update logo sprites
	bl updateStartSprites						@ Update start sprites
	bl updateCheatCheck							@ check for cheat sequence

	bl drawArrowSprite							@ Draw the arrow sprite
	bl drawGameContinueMenuText					@ Draw the continue text

	mov r1, #BUTTON_START
	bl keyWait
	cmp r1,#1									@ 1 is returned if key pressed and released

	beq updateGameContinueMenuDone

	ldr r0, =levelNum
	ldr r1, =menuNum
	ldr r1, [r1]
	mov r2, #1
	cmp r1, #MENUITEM_RESTART
	streq r2, [r0]
	cmp r1, #MENUITEM_MENTALVERSION
	beq updateGameContinueMenuDone

	bl showGameContinue							@ Start level
	
updateGameContinueMenuDone:
	
	ldmfd sp!, {r0-r6, pc} 					@ restore registers and return
	
	@---------------------------------
	
drawGameContinueMenuText:

	stmfd sp!, {r0-r6, lr}

	ldr r0, =restartText
	ldr r1, =8									@ x pos
	ldr r2, =14									@ y pos
	ldr r3, =1									@ Draw on sub screen
	bl drawText
	
	ldr r0, =startLevelText
	ldr r1, =8									@ x pos
	ldr r2, =16									@ y pos
	ldr r3, =1									@ Draw on sub screen
	bl drawText
	
	ldr r10, =levelNum							@ Pointer to data
	ldr r10, [r10]
	mov r8, #16									@ y pos
	mov r9, #2									@ Number of digits
	mov r11, #21								@ x pos
	bl drawDigits								@ Draw
	
	ldr r0, =mentalVerText
	ldr r1, =8									@ x pos
	ldr r2, =18									@ y pos
	ldr r3, =1									@ Draw on sub screen
	bl drawText
	
	ldr r0, =optionMentalVer
	ldr r0, [r0]
	ldr r1, =yesText
	ldr r2, =noText
	cmp r0, #1
	moveq r0, r1
	movne r0, r2
	ldr r1, =24									@ x pos
	ldr r2, =18									@ y pos
	ldr r3, =1									@ Draw on sub screen
	bl drawText
	
	ldmfd sp!, {r0-r6, pc} 					@ restore registers and return
	
	@---------------------------------
	
drawArrowSprite:

	stmfd sp!, {r0-r6, lr}
	
	ldr r0, =SPRITE_PALETTE_SUB
	ldr r1, =pulseValue
	ldr r1, [r1]
	ldr r2, =ARROW_COLOR_OFFSET
	lsl r2, #1
	strh r1, [r0, r2]
	
	ldr r0, =OBJ_ATTRIBUTE0_SUB(0)				@ Attrib 0
	ldr r1, =(ATTR0_COLOR_16 | ATTR0_SQUARE)	@ Attrib 0 settings
	orr r1, #(14 * 8)							@ Orr in the y pos (10 * 8 pixels + 2 pixels so cursor is below text)
	ldr r2, =menuNum							@ Load the hiScoreIndex address
	ldr r2, [r2] 								@ Load the hiScoreIndex value
	lsl r2, #1
	add r1, r2, lsl #3							@ Add the hiScoreIndex * 8
	strh r1, [r0]								@ Write to Attrib 0
	
	ldr r0, =OBJ_ATTRIBUTE1_SUB(0)				@ Attrib 1
	ldr r1, =(ATTR1_SIZE_8)						@ Attrib 1 settings
	orr r1, #(6 * 8)							@ Orr in the x pos (19 * 8 pixels)
	strh r1, [r0]								@ Write to Attrib 1
	
	ldr r0, =OBJ_ATTRIBUTE2_SUB(0)				@ Attrib 2
	mov r1, #ATTR2_PRIORITY(0)					@ Set sprite priority
	strh r1, [r0]								@ Write Attrib 2
	
	ldmfd sp!, {r0-r6, pc} 					@ restore registers and return
	
	@---------------------------------
	
	.data
	.align
	
menuNum:
	.word 0
	
	.align
ContinueText:
	.asciz "CONTINUE GAME?"

	.align
restartText:
	.asciz "RESTART"

	.align
startLevelText:
	.asciz "START LEVEL:"
	
	.align
mentalVerText:
	.asciz "MENTAL VERSION:"
	
	.align
yesText:
	.asciz "YES"
	
	.align
noText:
	.asciz "NO "
	
	.pool
	.end
