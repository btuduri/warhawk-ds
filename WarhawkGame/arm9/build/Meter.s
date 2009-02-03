
@{{BLOCK(Meter)

@=======================================================================
@
@	Meter, 48x24@8, 
@	Transparent color : FF,00,FF
@	+ palette 256 entries, not compressed
@	+ 3 tiles (t|f|p reduced) not compressed
@	+ regular map (flat), not compressed, 6x3 
@	Total size: 512 + 192 + 36 = 740
@
@	Time-stamp: 2009-02-04, 04:24:32
@	Exported by Cearn's GBA Image Transmogrifier, v0.8.3
@	( http://www.coranac.com/projects/#grit )
@
@=======================================================================

	.section .rodata
	.align	2
	.global MeterTiles		@ 192 unsigned chars
MeterTiles:
	.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
	.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
	.word 0x00000000,0x00000000,0x00000000,0x4F000000,0x00000000,0x4F4F0000,0x00000000,0x4F4F4F00
	.word 0x00000000,0x224F4F4F,0x4F000000,0x22224F4F,0x4F4F0000,0x0022224F,0x4F4F4F00,0x00002222
	.word 0x00000000,0x00000000,0x00000000,0x00000000,0x0000004F,0x00000000,0x00004F4F,0x00000000
	.word 0x004F4F4F,0x00000000,0x4F4F4F22,0x00000000,0x4F4F2222,0x0000004F,0x4F222200,0x00004F4F

	.section .rodata
	.align	2
	.global MeterMap		@ 36 unsigned chars
MeterMap:
	.hword 0x4001,0x4002,0x4001,0x4002,0x4001,0x4002,0x4001,0x4002
	.hword 0x4001,0x4002,0x4001,0x4002,0x4001,0x4002,0x4001,0x4002
	.hword 0x4001,0x4002

	.section .rodata
	.align	2
	.global MeterPal		@ 512 unsigned chars
MeterPal:
	.hword 0x7C1F,0x3C65,0x10AD,0x7FFF,0x35AD,0x1CE7,0x0000,0x292C
	.hword 0x4E77,0x62FA,0x5AD7,0x0C64,0x5295,0x0421,0x0842,0x0401
	.hword 0x0421,0x0421,0x0822,0x0C63,0x0000,0x0C63,0x1084,0x0000
	.hword 0x0800,0x1000,0x1821,0x1841,0x0400,0x2062,0x1C62,0x0000
	.hword 0x2483,0x2CA4,0x30C4,0x4126,0x5168,0x5589,0x1441,0x24A4
	.hword 0x3505,0x2CC5,0x4D68,0x3D26,0x4947,0x6E0C,0x6E2C,0x5DCA
	.hword 0x4968,0x5189,0x4147,0x722D,0x4988,0x4D89,0x4DA9,0x51AA
	.hword 0x51AA,0x51CB,0x5588,0x61EA,0x5188,0x4D88,0x59A9,0x59C9

	.hword 0x660B,0x6A0B,0x59CA,0x6A2C,0x764D,0x51AA,0x55A9,0x6E4D
	.hword 0x6E2D,0x5DEB,0x51AA,0x55CB,0x1462,0x6E2B,0x51A8,0x7A6D
	.hword 0x724C,0x51A9,0x5DEA,0x766D,0x620B,0x55CA,0x59EA,0x662C
	.hword 0x4568,0x3526,0x1CA3,0x6E4C,0x6E6C,0x726D,0x51CA,0x768E
	.hword 0x55EA,0x6A4D,0x622C,0x59EB,0x5E0B,0x49A9,0x3947,0x49AA
	.hword 0x72D1,0x766C,0x6A4C,0x0420,0x55EB,0x5E0C,0x4189,0x6A8F
	.hword 0x3968,0x1CA4,0x662B,0x6E6D,0x622C,0x664D,0x4DCA,0x3547
	.hword 0x6A6D,0x51EA,0x24E5,0x51EB,0x45CA,0x4E0C,0x0C41,0x41AA

	.hword 0x7735,0x2928,0x2906,0x3589,0x0C62,0x2D48,0x1CC5,0x0000
	.hword 0x0421,0x1CE7,0x2108,0x56B5,0x1D06,0x0441,0x1084,0x0862
	.hword 0x6B7A,0x6F9A,0x0000,0x0020,0x0000,0x2D6B,0x14A5,0x18E6
	.hword 0x0000,0x52B4,0x0CC5,0x39CE,0x1084,0x2529,0x4A73,0x4E94
	.hword 0x56D7,0x0001,0x0022,0x0422,0x0442,0x0843,0x0843,0x0C64
	.hword 0x0C64,0x0864,0x18C7,0x2109,0x1085,0x14A6,0x6B5D,0x0000
	.hword 0x35B1,0x1085,0x4213,0x252A,0x0000,0x318E,0x1CE8,0x14A6
	.hword 0x0421,0x5AD8,0x0842,0x56B6,0x4211,0x5294,0x56B5,0x5294

	.hword 0x77BE,0x2D6B,0x7BDF,0x4631,0x739C,0x6F7B,0x6F7B,0x6F7B
	.hword 0x6B5A,0x6B5A,0x6B5A,0x6B5A,0x6739,0x6739,0x6739,0x6739
	.hword 0x6318,0x6318,0x6318,0x5EF7,0x5EF7,0x5EF7,0x5AD6,0x5AD6
	.hword 0x56B5,0x56B5,0x5294,0x5294,0x5294,0x4E73,0x4E73,0x4E73
	.hword 0x4A52,0x4A52,0x4631,0x4210,0x3DEF,0x3DEF,0x35AD,0x35AD
	.hword 0x35AD,0x318C,0x2D6B,0x2D6B,0x294A,0x294A,0x2529,0x2108
	.hword 0x2108,0x1CE7,0x1CE7,0x18C6,0x14A5,0x14A5,0x1084,0x0C63
	.hword 0x0842,0x0842,0x0842,0x0421,0x0000,0x0000,0x0000,0x0000

@}}BLOCK(Meter)
