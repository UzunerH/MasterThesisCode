.section .data
SboxTable:
.word 0xCC,0xC5,0xC6,0xCB,0xC9,0xC0,0xCA,0xCD,0xC3,0xCE,0xCF,0xC8,0xC4,0xC7,0xC1,0xC2
.word 0x5C,0x55,0x56,0x5B,0x59,0x50,0x5A,0x5D,0x53,0x5E,0x5F,0x58,0x54,0x57,0x51,0x52
.word 0x6C,0x65,0x66,0x6B,0x69,0x60,0x6A,0x6D,0x63,0x6E,0x6F,0x68,0x64,0x67,0x61,0x62
.word 0xBC,0xB5,0xB6,0xBB,0xB9,0xB0,0xBA,0xBD,0xB3,0xBE,0xBF,0xB8,0xB4,0xB7,0xB1,0xB2
.word 0x9C,0x95,0x96,0x9B,0x99,0x90,0x9A,0x9D,0x93,0x9E,0x9F,0x98,0x94,0x97,0x91,0x92
.word 0x0C,0x05,0x06,0x0B,0x09,0x00,0x0A,0x0D,0x03,0x0E,0x0F,0x08,0x04,0x07,0x01,0x02
.word 0xAC,0xA5,0xA6,0xAB,0xA9,0xA0,0xAA,0xAD,0xA3,0xAE,0xAF,0xA8,0xA4,0xA7,0xA1,0xA2
.word 0xDC,0xD5,0xD6,0xDB,0xD9,0xD0,0xDA,0xDD,0xD3,0xDE,0xDF,0xD8,0xD4,0xD7,0xD1,0xD2
.word 0x3C,0x35,0x36,0x3B,0x39,0x30,0x3A,0x3D,0x33,0x3E,0x3F,0x38,0x34,0x37,0x31,0x32
.word 0xEC,0xE5,0xE6,0xEB,0xE9,0xE0,0xEA,0xED,0xE3,0xEE,0xEF,0xE8,0xE4,0xE7,0xE1,0xE2
.word 0xFC,0xF5,0xF6,0xFB,0xF9,0xF0,0xFA,0xFD,0xF3,0xFE,0xFF,0xF8,0xF4,0xF7,0xF1,0xF2
.word 0x8C,0x85,0x86,0x8B,0x89,0x80,0x8A,0x8D,0x83,0x8E,0x8F,0x88,0x84,0x87,0x81,0x82
.word 0x4C,0x45,0x46,0x4B,0x49,0x40,0x4A,0x4D,0x43,0x4E,0x4F,0x48,0x44,0x47,0x41,0x42
.word 0x7C,0x75,0x76,0x7B,0x79,0x70,0x7A,0x7D,0x73,0x7E,0x7F,0x78,0x74,0x77,0x71,0x72
.word 0x1C,0x15,0x16,0x1B,0x19,0x10,0x1A,0x1D,0x13,0x1E,0x1F,0x18,0x14,0x17,0x11,0x12
.word 0x2C,0x25,0x26,0x2B,0x29,0x20,0x2A,0x2D,0x23,0x2E,0x2F,0x28,0x24,0x27,0x21,0x22
    .text
    .align    2
    .globl    main
    .type    main, @function
main:
    add    s0, zero, 1          # s0 = round-counter
    lui    a2,%hi(SboxTable)
    addi   a1,a2,%lo(SboxTable) # a1 = sBoxTable index
    li     s10, 0x00000000      # s10 = state 63...32
    li     s11, 0x00000000      # s11 = state 31...0
    li     s2,  0xFFFFFFFF      # s2 = k79...k48
    li     s3,  0xFFFFFFFF      # s3 = k47...k16
    li     s4,  0x0000FFFF      # s4 = 0...0 , k15...k0
    sw     ra, 0(sp)
round:
    xor    s10, s10, s2
    xor    s11, s11, s3
    add    a0, zero, s10
    call   sBox
    add    s10, zero, a0
    add    a0, zero, s11
    call   sBox
    add    s11, zero, a0
    add   t1, zero, zero    
    andi  t3, s11, 1
    or    t1, t1, t3    # P(0) = 0
    andi  t3, s11, 0x10
    srli  t3, t3, 3     
    or    t1, t1, t3    # P(4) = 1
    andi  t3, s11, 0x100
    srli  t3, t3, 6     
    or    t1, t1, t3    # P(8) = 2
    li    t6, 0x1000
    and   t3, s11, t6
    srli  t3, t3, 9     
    or    t1, t1, t3    # P(12) = 3
    li    t6, 0x10000
    and   t3, s11, t6
    srli  t3, t3, 12     
    or    t1, t1, t3    # P(16) = 4
    li    t6, 0x100000
    and   t3, s11, t6
    srli  t3, t3, 15     
    or    t1, t1, t3    # P(20) = 5
    li    t6, 0x1000000 
    and   t3, s11, t6
    srli  t3, t3, 18     
    or    t1, t1, t3    # P(24) = 6
    li    t6, 0x10000000 
    and   t3, s11, t6
    srli  t3, t3, 21     
    or    t1, t1, t3    # P(28) = 7
    andi  t3, s10, 0x1
    slli  t3, t3, 8     
    or    t1, t1, t3    # P(32) = 8
    andi  t3, s10, 0x10
    slli  t3, t3, 5     
    or    t1, t1, t3    # P(36) = 9
    andi  t3, s10, 0x100
    slli  t3, t3, 2     
    or    t1, t1, t3    # P(40) = 10
    li    t6, 0x1000
    and   t3, s10, t6
    srli  t3, t3, 1     
    or    t1, t1, t3    # P(44) = 11
    li    t6, 0x10000
    and   t3, s10, t6
    srli  t3, t3, 4     
    or    t1, t1, t3    # P(48) = 12
    li    t6, 0x100000
    and   t3, s10, t6
    srli  t3, t3, 7     
    or    t1, t1, t3    # P(52) = 13
    li    t6, 0x1000000
    and   t3, s10, t6
    srli  t3, t3, 10     
    or    t1, t1, t3    # P(56) = 14
    li    t6, 0x10000000
    and   t3, s10, t6
    srli  t3, t3, 13     
    or    t1, t1, t3    # P(60) = 15
    andi  t3, s11, 0x2
    slli  t3, t3, 15     
    or    t1, t1, t3    # P(1) = 16
    andi  t3, s11, 0x20
    slli  t3, t3, 12     
    or    t1, t1, t3    # P(5) = 17
    andi  t3, s11, 0x200
    slli  t3, t3, 9     
    or    t1, t1, t3    # P(9) = 18
    li    t6, 0x2000
    and   t3, s11, t6
    slli  t3, t3, 6     
    or    t1, t1, t3    # P(13) = 19
    li    t6, 0x20000
    and   t3, s11, t6
    slli  t3, t3, 3     
    or    t1, t1, t3    # P(17) = 20
    li    t6, 0x200000
    and   t3, s11, t6
    or    t1, t1, t3    # P(21) = 21
    li    t6, 0x2000000
    and   t3, s11, t6
    srli  t3, t3, 3     
    or    t1, t1, t3    # P(25) = 22
    li    t6, 0x20000000
    and   t3, s11, t6
    srli  t3, t3, 6     
    or    t1, t1, t3    # P(29) = 23
    andi  t3, s10, 0x2
    slli  t3, t3, 23     
    or    t1, t1, t3    # P(33) = 24
    andi  t3, s10, 0x20
    slli  t3, t3, 20     
    or    t1, t1, t3    # P(37) = 25
    andi  t3, s10, 0x200
    slli  t3, t3, 17     
    or    t1, t1, t3    # P(41) = 26
    li    t6, 0x2000
    and   t3, s10, t6
    slli  t3, t3, 14     
    or    t1, t1, t3    # P(45) = 27
    li    t6, 0x20000
    and   t3, s10, t6
    slli  t3, t3, 11     
    or    t1, t1, t3    # P(49) = 28
    li    t6, 0x200000
    and   t3, s10, t6
    slli  t3, t3, 8     
    or    t1, t1, t3    # P(53) = 29
    li    t6, 0x2000000
    and   t3, s10, t6
    slli  t3, t3, 5     
    or    t1, t1, t3    # P(57) = 30
    li    t6, 0x20000000
    and   t3, s10, t6
    slli  t3, t3, 2     
    or    t1, t1, t3    # P(61) = 31, t1 completed, write into s11 at the end
    add   t0, zero, zero    
    and   t3, s11, 0x4
    srli  t3, t3, 2   
    or    t0, t0, t3    # P(2) = 32
    and   t3, s11, 0x40
    srli  t3, t3, 5     
    or    t0, t0, t3    # P(6) = 33
    and   t3, s11, 0x400
    srli  t3, t3, 8     
    or    t0, t0, t3    # P(10) = 34
    li    t6, 0x4000
    and   t3, s11, t6
    srli  t3, t3, 11     
    or    t0, t0, t3    # P(14) = 35
    li    t6, 0x40000
    and   t3, s11, t6
    srli  t3, t3, 14    
    or    t0, t0, t3    # P(18) = 36
    li    t6, 0x400000
    and   t3, s11, t6
    srli  t3, t3, 17    
    or    t0, t0, t3    # P(22) = 37
    li    t6, 0x4000000
    and   t3, s11, t6
    srli  t3, t3, 20     
    or    t0, t0, t3    # P(26) = 38
    li    t6, 0x40000000
    and   t3, s11, t6
    srli  t3, t3, 23     
    or    t0, t0, t3    # P(30) = 39
    and   t3, s10, 0x4
    slli  t3, t3, 6     
    or    t0, t0, t3    # P(34) = 40
    and   t3, s10, 0x40
    slli  t3, t3, 3     
    or    t0, t0, t3    # P(38) = 41
    and   t3, s10, 0x400
    or    t0, t0, t3    # P(42) = 42
    li    t6, 0x4000
    and   t3, s10, t6
    srli  t3, t3, 3     
    or    t0, t0, t3    # P(46) = 43
    li    t6, 0x40000
    and   t3, s10, t6
    srli  t3, t3, 6     
    or    t0, t0, t3    # P(50) = 44
    li    t6, 0x400000
    and   t3, s10, t6
    srli  t3, t3, 9     
    or    t0, t0, t3    # P(54) = 45
    li    t6, 0x4000000
    and   t3, s10, t6
    srli  t3, t3, 12     
    or    t0, t0, t3    # P(58) = 46
    li    t6, 0x40000000
    and   t3, s10, t6
    srli  t3, t3, 15     
    or    t0, t0, t3    # P(62) = 47
    and   t3, s11, 0x8
    slli  t3, t3, 13   
    or    t0, t0, t3    # P(3) = 48
    and   t3, s11, 0x80
    slli  t3, t3, 10     
    or    t0, t0, t3    # P(7) = 49
    li    t6, 0x800
    and   t3, s11, t6
    slli  t3, t3, 7     
    or    t0, t0, t3    # P(11) = 50
    li    t6, 0x8000
    and   t3, s11, t6
    slli  t3, t3, 4     
    or    t0, t0, t3    # P(15) = 51
    li    t6, 0x80000
    and   t3, s11, t6
    slli  t3, t3, 1    
    or    t0, t0, t3    # P(19) = 52
    li    t6, 0x800000
    and   t3, s11, t6
    srli  t3, t3, 2    
    or    t0, t0, t3    # P(23) = 53
    li    t6, 0x8000000
    and   t3, s11, t6
    srli  t3, t3, 5     
    or    t0, t0, t3    # P(27) = 54
    li    t6, 0x80000000
    and   t3, s11, t6
    srli  t3, t3, 8     
    or    t0, t0, t3    # P(31) = 55
    and   t3, s10, 0x8
    slli  t3, t3, 21     
    or    t0, t0, t3    # P(35) = 56
    and   t3, s10, 0x80
    slli  t3, t3, 18     
    or    t0, t0, t3    # P(39) = 57
    li    t6, 0x800
    and   t3, s10, t6
    slli  t3, t3, 15     
    or    t0, t0, t3    # P(43) = 58
    li    t6, 0x8000
    and   t3, s10, t6
    slli  t3, t3, 12     
    or    t0, t0, t3    # P(47) = 59
    li    t6, 0x80000
    and   t3, s10, t6
    slli  t3, t3, 9     
    or    t0, t0, t3    # P(51) = 60
    li    t6, 0x800000
    and   t3, s10, t6
    slli  t3, t3, 6     
    or    t0, t0, t3    # P(55) = 61
    li    t6, 0x8000000
    and   t3, s10, t6
    slli  t3, t3, 3     
    or    t0, t0, t3    # P(59) = 62
    li    t6, 0x80000000
    and   t3, s10, t6
    or    t0, t0, t3    # P(63) = 63
    add   s10, zero, t0  # write permutation result of state 0 into s10
    add   s11, zero, t1  # write permutation result of state 1 into s11
    srli    t0, s2, 19
    slli    t1, s4, 13
    add     t0, t0, t1
    slli    t1, s3, 29  
    add     t0, t0, t1  # t0 = newk1
    srli    t1, s3, 19
    slli    t2, s2, 13
    add     t1, t1, t2  # t1 = newk2
    slli    t3, s3, 13
    srli    s4, t3, 16  # s4 = newk3
    add     s2, zero, t0
    add     s3, zero, t1
    srli    t0, s2, 24
    slli    t0, t0, 2
    add     t0, t0, a1    
    lw      t1, 0(t0)
    srli    t1, t1, 4
    slli    t1, t1, 28
    li      t6, 0xFFFFFFF
    and     s2, s2, t6
    add     s2, s2, t1
    slli    t0, s3, 28
    srli    t0, t0, 27
    srli    t1, s4, 15
    add     t0, t0, t1
    xor     t0, t0, s0
    li      t1, 0xFFFFFFF0
    and     s3, s3, t1    
    srli    t1, t0, 1
    add     s3, s3, t1
    li      t1, 0x7FFF
    and     s4, s4, t1
    andi    t1, t0, 1
    slli    t1, t1, 15
    add     s4, s4, t1
    addi    s0, s0, 1
    addi    t0, zero, 32
    bne     s0, t0, round
    beq     s0, t0, end
sBox:
    add     t1, zero, a0 # save input
    andi    t0, t1, 255  # sbox first byte
    slli    t0, t0, 2
    add     t0, t0, a1
    lw      a0, 0(t0)
    srli    t0, t1, 8   #sbox second byte
    andi    t0, t0, 255
    slli    t0, t0, 2   
    add     t0, t0, a1
    lw      t0, 0(t0)
    slli    t0, t0, 8
    add     a0, a0, t0
    srli    t0, t1, 16   #sbox third byte
    andi    t0, t0, 255
    slli    t0, t0, 2
    add     t0, t0, a1
    lw      t0, 0(t0)
    slli    t0, t0, 16
    add     a0, a0, t0   
    srli    t0, t1, 24   #sbox fourth byte
    andi    t0, t0, 255
    slli    t0, t0, 2
    add     t0, t0, a1
    lw      t0, 0(t0)
    slli    t0, t0, 24
    add     a0, a0, t0 
    ret
end:
    xor    s10, s10, s2
    xor    s11, s11, s3
    lw     ra, 0(sp)
    jr    ra
    .size    main, .-main
    .ident    "GCC: (GNU) 11.1.0"