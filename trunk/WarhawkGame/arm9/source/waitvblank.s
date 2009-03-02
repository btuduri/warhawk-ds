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
	.global waitforVblank
	.global waitforNoVblank

waitforVblank:
	stmfd sp!, {r0-r6, lr} 

	ldr r0, =REG_VCOUNT
	
waitforVblankLoop:									
	ldrh r1,[r0]						@ read REG_VCOUNT into r2
	cmp r1, #193						@ 193 is, of course, the first scanline of vblank
	bne waitforVblankLoop				@ loop if r2 is not equal to (NE condition) 193
	
	ldmfd sp!, {r0-r6, pc}
	
waitforNoVblank:
	stmfd sp!, {r0-r6, lr} 
	
	ldr r0, =REG_VCOUNT

waitVBlankNoVblankLoop:									
	ldrh r1, [r0]						@ read REG_VCOUNT into r2
	cmp r1, #255	
	bmi waitVBlankNoVblankLoop			@ Changed from bne as it was often missed!
	
	ldmfd sp!, {r0-r6, pc}

	.pool
	.end
