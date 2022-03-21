.section .data
SboxTable:
	.word	0x63,	0x7c,	0x77,	0x7b,	0xf2,	0x6b,	0x6f,	0xc5,	0x30,	0x01,	0x67,	0x2b,	0xfe,	0xd7,	0xab,	0x76
	.word	0xca,	0x82,	0xc9,	0x7d,	0xfa,	0x59,	0x47,	0xf0,	0xad,	0xd4,	0xa2,	0xaf,	0x9c,	0xa4,	0x72,	0xc0
	.word	0xb7,	0xfd,	0x93,	0x26,	0x36,	0x3f,	0xf7,	0xcc,	0x34,	0xa5,	0xe5,	0xf1,	0x71,	0xd8,	0x31,	0x15
	.word	0x04,	0xc7,	0x23,	0xc3,	0x18,	0x96,	0x05,	0x9a,	0x07,	0x12,	0x80,	0xe2,	0xeb,	0x27,	0xb2,	0x75
	.word	0x09,	0x83,	0x2c,	0x1a,	0x1b,	0x6e,	0x5a,	0xa0,	0x52,	0x3b,	0xd6,	0xb3,	0x29,	0xe3,	0x2f,	0x84
	.word	0x53,	0xd1,	0x00,	0xed,	0x20,	0xfc,	0xb1,	0x5b,	0x6a,	0xcb,	0xbe,	0x39,	0x4a,	0x4c,	0x58,	0xcf
	.word	0xd0,	0xef,	0xaa,	0xfb,	0x43,	0x4d,	0x33,	0x85,	0x45,	0xf9,	0x02,	0x7f,	0x50,	0x3c,	0x9f,	0xa8
	.word	0x51,	0xa3,	0x40,	0x8f,	0x92,	0x9d,	0x38,	0xf5,	0xbc,	0xb6,	0xda,	0x21,	0x10,	0xff,	0xf3,	0xd2
	.word	0xcd,	0x0c,	0x13,	0xec,	0x5f,	0x97,	0x44,	0x17,	0xc4,	0xa7,	0x7e,	0x3d,	0x64,	0x5d,	0x19,	0x73
	.word	0x60,	0x81,	0x4f,	0xdc,	0x22,	0x2a,	0x90,	0x88,	0x46,	0xee,	0xb8,	0x14,	0xde,	0x5e,	0x0b,	0xdb
	.word	0xe0,	0x32,	0x3a,	0x0a,	0x49,	0x06,	0x24,	0x5c,	0xc2,	0xd3,	0xac,	0x62,	0x91,	0x95,	0xe4,	0x79
	.word	0xe7,	0xc8,	0x37,	0x6d,	0x8d,	0xd5,	0x4e,	0xa9,	0x6c,	0x56,	0xf4,	0xea,	0x65,	0x7a,	0xae,	0x08
	.word	0xba,	0x78,	0x25,	0x2e,	0x1c,	0xa6,	0xb4,	0xc6,	0xe8,	0xdd,	0x74,	0x1f,	0x4b,	0xbd,	0x8b,	0x8a
	.word	0x70,	0x3e,	0xb5,	0x66,	0x48,	0x03,	0xf6,	0x0e,	0x61,	0x35,	0x57,	0xb9,	0x86,	0xc1,	0x1d,	0x9e
	.word	0xe1,	0xf8,	0x98,	0x11,	0x69,	0xd9,	0x8e,	0x94,	0x9b,	0x1e,	0x87,	0xe9,	0xce,	0x55,	0x28,	0xdf
	.word	0x8c,	0xa1,	0x89,	0x0d,	0xbf,	0xe6,	0x42,	0x68,	0x41,	0x99,	0x2d,	0x0f,	0xb0,	0x54,	0xbb,	0x16



	.text
	.align	2
	.globl	main
	.type	main, @function
main:
    # AES cipher with RVI32 only
	# Block size 128: s0, s1, s2, s3
	# Key 	size 128: s4, s5, s6, s7
	# Keycounters	: s8, s9
	# Roundconstant	: s10
	# Roundcounter	: s11 

    sw     ra, 0(sp)
	
	# initialize State
	li  s0, 0xf34481ec
	li  s1, 0x3cc627ba
	li  s2, 0xcd5dc3fb
	li  s3, 0x08f273e6
	

	# initialize key, W0...W3
	li	s4, 0x00000000
	li	s5, 0x00000000
	li	s6, 0x00000000
	li	s7, 0x00000000
	addi	s8, zero, 3
	addi	s9, zero, 3
	li	    s10, 0x01000000
	addi	s11, zero, 1

	# Add First RoundKey
	xor		s0, s0, s4 
	xor		s1, s1, s5 
	xor		s2, s2, s6 
	xor		s3, s3, s7 

	call keyscheduleround
	
round:
	# Put state blocks through sBox
	add a0, zero, s0
	call sBox
	add s0, zero, a0
	add a0, zero, s1
	call sBox
	add s1, zero, a0	
	add a0, zero, s2
	call sBox
	add s2, zero, a0
	add a0, zero, s3
	call sBox
	add s3, zero, a0	

	
	# Shift rows
	li	t6, 0x00FF0000
	li	t5, 0xFF00FFFF
	and	t0, s0, t6 #save a10
	and t1, s1, t6 # get a11
	and s0, s0, t5 # delete a10
	or	s0, s0, t1 # write a11 into a10
	and t1, s2, t6 # get a12
	and s1, s1, t5 # delete a11
	or s1, s1, t1 # write a12 into a11
	and t1, s3, t6 # get a13
	and s2, s2, t5 # delete a12
	or	s2, s2, t1 # write a13 into a12
	and s3, s3, t5 # delete a13
	or s3, s3, t0 # write a10 into a13
	
	li	t6, 0x0000FF00
	li	t5, 0xFFFF00FF	
	and	t0, s0, t6 #save a20
	and t1, s2, t6 # get a22
	and s0, s0, t5 # delete a20
	or	s0, s0, t1 # write a22 into a20
	and s2, s2, t5 # delete a22
	or  s2, s2, t0 # write a10 into a22
	and	t0, s1, t6 #save a21
	and t1, s3, t6 # get a23
	and s1, s1, t5 # delete a21
	or	s1, s1, t1 # write a23 into a21
	and s3, s3, t5 # delete a23
	or s3, s3, t0 # write a10 into a13

	li	t6, 0x000000FF
	li	t5, 0xFFFFFF00
	and	t0, s0, t6 #save a30
	and t1, s3, t6 # get a33
	and s0, s0, t5 # delete a30
	or	s0, s0, t1 # write a33 into a30
	and t1, s2, t6 # get a32
	and s3, s3, t5 # delete a33
	or s3, s3, t1 # write a32 into a33
	and t1, s1, t6 # get a31
	and s2, s2, t5 # delete a32
	or	s2, s2, t1 # write a32 into a32
	and s1, s1, t5 # delete a31
	or s1, s1, t0 # write a30 into a31
	
	# mixcolumns
	# mix first column
	add	a6, zero, s0
	call mixcolumns
	add s0, zero, a6

	# mix second column
	add	a6, zero, s1
	call mixcolumns
	add s1, zero, a6
	
	# mix third column
	add	a6, zero, s2
	call mixcolumns
	add s2, zero, a6


	# mix fourth column
	add	a6, zero, s3
	call mixcolumns
	add s3, zero, a6

	
	# Add round key
	xor		s0, s0, s4 
	xor		s1, s1, s5 
	xor		s2, s2, s6 
	xor		s3, s3, s7 

	call keyschedule	
	
	addi	s11, s11, 1
	addi	t0, zero, 10
	bltu	s11, t0, round

lastround:
	# Put state blocks through sBox
	nnlaese s0, s0
	nnlaese s1, s1
	nnlaese s2, s2
	nnlaese s3, s3
	
	# Shift rows
	li	t6, 0x00FF0000
	li	t5, 0xFF00FFFF
	and	t0, s0, t6 #save a10
	and t1, s1, t6 # get a11
	and s0, s0, t5 # delete a10
	or	s0, s0, t1 # write a11 into a10
	and t1, s2, t6 # get a12
	and s1, s1, t5 # delete a11
	or s1, s1, t1 # write a12 into a11
	and t1, s3, t6 # get a13
	and s2, s2, t5 # delete a12
	or	s2, s2, t1 # write a13 into a12
	and s3, s3, t5 # delete a13
	or s3, s3, t0 # write a10 into a13
	
	li	t6, 0x0000FF00
	li	t5, 0xFFFF00FF	
	and	t0, s0, t6 #save a20
	and t1, s2, t6 # get a22
	and s0, s0, t5 # delete a20
	or	s0, s0, t1 # write a22 into a20
	and s2, s2, t5 # delete a22
	or  s2, s2, t0 # write a10 into a22
	and	t0, s1, t6 #save a21
	and t1, s3, t6 # get a23
	and s1, s1, t5 # delete a21
	or	s1, s1, t1 # write a23 into a21
	and s3, s3, t5 # delete a23
	or s3, s3, t0 # write a10 into a13

	li	t6, 0x000000FF
	li	t5, 0xFFFFFF00
	and	t0, s0, t6 #save a30
	and t1, s3, t6 # get a33
	and s0, s0, t5 # delete a30
	or	s0, s0, t1 # write a33 into a30
	and t1, s2, t6 # get a32
	and s3, s3, t5 # delete a33
	or s3, s3, t1 # write a32 into a33
	and t1, s1, t6 # get a31
	and s2, s2, t5 # delete a32
	or	s2, s2, t1 # write a32 into a32
	and s1, s1, t5 # delete a31
	or s1, s1, t0 # write a30 into a31
	
	# Add round key
	xor		s0, s0, s4 
	xor		s1, s1, s5 
	xor		s2, s2, s6 
	xor		s3, s3, s7 
	
    lw     ra, 0(sp)

	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
	
	
mixcolumns:
	#a0 = a0*2 + a1*3 + a2 + a3
	#a1 = a0 + a1*2 + a2*3 + a3
	#a2 = a0 + a1 + a2*2 + a3*3
	#a3 = a0*3 + a1 + a2 + a3*2
	
	addi sp, sp, -4
	sw ra, 0(sp)
	
	srli a0, a6, 24
	slli a1, a6, 8
	srli a1, a1, 24
	slli a2, a6, 16
	srli a2, a2, 24
	slli a3, a6, 24
	srli a3, a3, 24
	
	# first byte
	add a5, zero, a0
	call mult2
	add	t0, zero, a5
	add a5, zero, a1
	call mult2
	xor a5, a5, a1
	xor t0, t0, a5
	xor t0, t0, a2
	xor t0, t0, a3
	
	# second byte
	add a5, zero, a1
	call mult2
	add	t1, zero, a5
	add a5, zero, a2
	call mult2
	xor a5, a5, a2
	xor t1, t1, a5
	xor t1, t1, a3
	xor t1, t1, a0

	# third byte
	add a5, zero, a2
	call mult2
	add	t2, zero, a5
	add a5, zero, a3
	call mult2
	xor a5, a5, a3
	xor t2, t2, a5
	xor t2, t2, a0
	xor t2, t2, a1

	# fourth byte
	add a5, zero, a3
	call mult2
	add	t3, zero, a5
	add a5, zero, a0
	call mult2
	xor a5, a5, a0
	xor t3, t3, a5
	xor t3, t3, a1
	xor t3, t3, a2	
	
	slli t0, t0, 24
	slli t1, t1, 16
	slli t2, t2, 8
	add  a6, zero, t3
	add	 a6, a6, t2
	add  a6, a6, t1
	add a6, a6, t0
	
	lw ra, 0(sp)
	addi sp, sp, 4
	
	ret
	
mult2:
	slli	t4, a5, 1
	li		t6, 0x80
	bltu	a5, t6, continuemult2
	xori 	t4, t4, 0x11B
continuemult2:
	add	a5, zero, t4
	ret
	
	

keyschedule:
	# Calc new constant and call keyschedule
	slli	t0, s10, 1
	li		t6, 0x80000000
	bltu	s10, t6, continue
	li		t6, 0x1B000000
	xor 	t0, t0, t6
continue:
	add	s10, zero, t0
keyscheduleround:
	# RotWord
	li	t6, 0xFF000000
	and	t0, s7, t6
	srli t0, t0, 24
	slli t1, s7, 8
	add	t0, t0, t1
	# SubWord
	nnlaese t0, t0
	# Add constant
	xor		t0, t0, s10
	
	xor		s4, s4, t0
	xor		s5, s5, s4
	xor		s6, s6, s5
	xor		s7, s7, s6
	ret

sBox:
    # t0 = sBoxTable offset / sBoxReturn
    # t1 = input
    # a0 = input -> return - 32bit end result of 32bit sBox
    # shift respective byte of state to right -> add it to sBoxTable-index -> get sBoxTable result -> put result back into respective significance -> add to endresult
    
	lui	    t1,%hi(SboxTable)
	addi    t2,t1,%lo(SboxTable)
	
    add     t1, zero, a0 # save input

    andi    t0, t1, 0xFF  # sbox first byte
    slli    t0, t0, 2
    add     t0, t0, t2
    lw      a0, 0(t0)

    srli    t0, t1, 8   #sbox second byte
    andi    t0, t0, 0xFF
    slli    t0, t0, 2   
    add     t0, t0, t2
    lw      t0, 0(t0)
    slli    t0, t0, 8
    add     a0, a0, t0

    srli    t0, t1, 16   #sbox third byte
    andi    t0, t0, 0xFF
    slli    t0, t0, 2
    add     t0, t0, t2
    lw      t0, 0(t0)
    slli    t0, t0, 16
    add     a0, a0, t0   

    srli    t0, t1, 24   #sbox fourth byte
    andi    t0, t0, 0xFF
    slli    t0, t0, 2
    add     t0, t0, t2
    lw      t0, 0(t0)
    slli    t0, t0, 24
    add     a0, a0, t0 

	ret