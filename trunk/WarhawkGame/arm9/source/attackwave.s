	.data
	@.section .ewram
	.section .rodata
	.balign 4
	
	.global alienDescript
	.global alienWave
	.global alienLevel
	
alienLevel:
	@ These blocks define what alienWave appears and when on each level
	@ these are pairs, first is "ypossub" and second is "alienWave"
	@ "ypossub" starts at 3744 and ends at 160
	@ the "scroll pos" MUST work backwards, ie. start at level base
	.word 3650,1,3450,1,3060,3,3060-16,2,3060-32,2,3060-48,2,3060-64,2,3060-80,2,3060-96,2,3060-112,4,2600,5,2550,5,2500,5,2450,5,2400,5,2350,5
	.word 2150,6,2000,7,1950,7,1900,7,1850,7,1600,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
alienWave:
	@ These blocks define what alienDescripts create a attack wave
	@ these are just indexes to the alienDescripts to use. A maximum of
	@ 32 aliens per wave!
	@ The first line must remain 0, this is so alienLevel can use 0 as NOTHING - for ease
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	@ wave 1
	.word 1,2,3,4,5,6,7,8,9,10,11,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	@ wave 2
	.word 13,14,15,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	@ wave 3
	.word 17,18,19,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	@ wave 4
	.word 21,22,23,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	@ wave 5
	.word 25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	@ wave 6
	.word 26,27,28,29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	@ wave 7
	.word 30,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	@ wave ETC...
	
alienDescript:
	@ The first descript is blank so we can use 0 in alienWave for "no descript"

	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	@ These are stored in blocks of 32 words --- for however many we use?
@1
	.word 90,120,1,1024,0,41,0,0					@ inits
	.word 5,280,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@2	
	.word 90,140,1,1024,0,41,0,0					@ inits
	.word 5,260,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@3	
	.word 90,160,1,1024,0,41,0,0					@ inits
	.word 5,240,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@4	
	.word 90,180,1,1024,0,41,0,0					@ inits
	.word 5,220,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@5	
	.word 90,200,1,1024,0,41,0,0					@ inits
	.word 5,200,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@6	
	.word 90,220,1,1024,0,41,0,0					@ inits
	.word 5,180,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@7	
	.word 90,240,1,1024,0,41,0,0					@ inits
	.word 5,160,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@8	
	.word 90,260,1,1024,0,41,0,0					@ inits
	.word 5,140,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@9	
	.word 90,280,1,1024,0,41,0,0					@ inits
	.word 5,120,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@10	
	.word 90,300,1,1024,0,41,0,0					@ inits
	.word 5,100,4,50,3,50,4,50,5,50,6,50			@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@11	
	.word 90,320,1,1024,0,41,0,0					@ inits
	.word 5,80,4,50,3,50,4,50,5,50,6,50				@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@12	
	.word 90,340,1,1024,0,41,0,0					@ inits
	.word 5,60,4,50,3,50,4,50,5,50,6,50				@ Track points
	.word 7,10,8,10,1,5,2,5,3,80,5,500
@13 @	
	.word 180,300,2,1024,0,48,2048,12806			@ fire is 50 delay and fire left (fire type 6)
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@14	
	.word 212,300,2,1024,0,49,2048,0					@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@15	
	.word 244,300,2,1024,0,50,2048,0					@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@16	@
	.word 276,300,2,1024,0,51,2048,12805				@ fire is 50 delay and fire right (fire type 5) 00110010 00000101
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@17	
	.word 180,300,2,1024,0,52,2048,10249					@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@18	
	.word 212,300,2,1024,0,53,200,10249 			@ fie is 40 delay and fire down (fire type 7) 00101000 00000111
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@19	
	.word 244,300,2,1024,0,54,200,10249				@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@20	
	.word 276,300,2,1024,0,55,200,10249					@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@21	
	.word 180,300,2,1024,0,56,2048,0					@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@22	
	.word 212,300,2,1024,0,57,200,0 				@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@23	
	.word 244,300,2,1024,0,58,200,0 				@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@24	
	.word 276,300,2,1024,0,59,200,0 				@ inits
	.word 5,800,0,0,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@25
	.word 320,360,0,0,3,34,6,10243					@ inits
	.word 280,400,200,420,200,460,1024,1024,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@26	
	.word 32,576,1,1024,0,36,0,0					@ inits
	.word 3,383,2048,2048,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@27	
	.word 32,576+22,2,1024,0,36,0,0					@ inits
	.word 3,383,2048,2048,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@28	
	.word 383,576+44,2,1024,0,36,0,0					@ inits
	.word 7,383,2048,2048,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@29	
	.word 383,576+66,1,1024,0,36,0,0					@ inits
	.word 7,383,2048,2048,0,0,0,0,0,0,0,0					@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0
@30
	.word 63+32,360,0,0,3,34,6,0						@ inits
	.word 103+32,400,183+32,420,183+32,460,1024,1024,0,0,0,0	@ Track points
	.word 0,0,0,0,0,0,0,0,0,0,0,0	


@31
	@ Alien define structure

	.word 180		@ init X				@ initial X coord
	.word 50		@ init y				@ initial Y coord
	.word 0 		@ init speed X			@ (this is overal speed in linear mode)
	.word 0			@ init speed y			@ (set to 1024 to signal linear mode)
	.word 3 		@ init maxSpeed			@ (on ones that attack you - 5 is the fastest)
	.word 37		@ init spriteObj		@ Sprite to use for image
	.word 20		@ init hits to kill		@ make massive for indestructable (0=one shot)
	.word 5			@ init 'fire type' 		@ Lower 8 bits = type, 0=none
											@ the rest is delay (shifted 8 left)
	.word 1024,600	@ track x,y 1			@ tracking coordinate (as in coords.png)
	.word 0,0		@ track x,y 2
	.word 0,0		@ track x,y 3
	.word 315,660	@ etc.....
	.word 215,660	@ make any track 1024 to attack your ship on that vertices
	.word 230,384	@ (in linear mode these are direction, distance, "speed x" is speed)
	.word 1024,1024	@ you can make them trackers at any time on any axis.. :)
	.word 0,0		@ make them 0 and the wave will loop to the begining
	.word 0,0		@ make them 2048 to kill the alien (spriteActive=0)
	.word 0,0
	.word 0,0		@ The last Y coord must be off screen base so alien is destroyed
	.word 0,0		@ if not, the pattern will loop forever

			
.end
Auto KIll

Perhaps adding a track value of 2048 will instantly kill the alien. This could be handy for taking
an alien off the side of the screen for both trackers and linear?


one thing we do need to think about is the other attack types in Warhawk
we could have seperate code for each, I really do not know how to fit them in at the moment

Each level will have a wavePattern desctription

This will be 2 words per wave

- Scroll_pos, attackWave

So, at a certain point, wave X will be initialised.

Each wave is constructed of 32 words, each word is a pointer to the number of a alienDescript with
0 signalling "no Alien" (we need to sub 1 to get correct wave)
So, each wave can have 32 aliens in it. too many???? Please let me know!

So, back to the Warhawk special waves

1 = mines. These randomly fall from the top of the screen at a random X coord
2 = Trackers	These have 3 phases
			1 = random X, fall down screen and lock onto your Y coord and change direction
			2 = as above, except, when their x matches yours, and y is less than they move up
			3 = as 2, except they move up or down on a x match
3 = Powerup(s)
			This is dropped from a shot (special) ship from level 3 onwards.
			shoot ship to release power up, shooting power up kills it!!
			
We could use attackWave with an unreachable value to signal these? Ie. 10000000,10000001,10000002, etc

We may also need to add a spriteType to global.s to enable collision detection to know what power up
is collected, or that an alien is now a SAFE explosion, and to tell drawsprite.s to animate it!

Oh, well - that is my rambling from a fool all done with (for now! ha ha ha ha ha! <manically>)