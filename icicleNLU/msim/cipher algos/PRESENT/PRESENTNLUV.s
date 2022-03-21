    .text
    .align    2
    .globl    main
    .type    main, @function
main:
    # PRESNT cipher with NLU-V
    sw     ra, 0(sp)

    # initialize fields
    add   s0, zero, 1          # s0 = round-counter
    li    s10, 0x00000000      # s10 = state 63...32
    li    s11, 0x00000000      # s11 = state 31...0
    li    s2,  0xFFFFFFFF      # s2 = k79...k48
    li    s3,  0xFFFFFFFF      # s3 = k47...k16
    li    s4,  0x0000FFFF      # s4 = 0...0 , k15...k0
    
    #load anf mask for sBox
    nldnl    x0, 0xE394
    nldnl    x0, 0x98F4
    nldnl    x0, 0x21BC
    nldnl    x0, 0x4A80
    
round:
    # key add layer
    # xor key to state
    xor    s10, s10, s2
    xor    s11, s11, s3

    # sBox layer
    nnlanf s10, s10
    nnlanf s11, s11

    # permutation layer
    nldl  x0, 0x8000
    nldl  x0, 0x0000
    nldl  x0, 0x0800
    nldl  x0, 0x0000
    nldl  x0, 0x0080
    nldl  x0, 0x0000
    nldl  x0, 0x0008
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x8000
    nldl  x0, 0x0000
    nldl  x0, 0x0800
    nldl  x0, 0x0000
    nldl  x0, 0x0080
    nldl  x0, 0x0000
    nldl  x0, 0x0008

    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000

    nldl  x0, 0x4000
    nldl  x0, 0x0000
    nldl  x0, 0x0400
    nldl  x0, 0x0000
    nldl  x0, 0x0040
    nldl  x0, 0x0000
    nldl  x0, 0x0004
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x4000
    nldl  x0, 0x0000
    nldl  x0, 0x0400
    nldl  x0, 0x0000
    nldl  x0, 0x0040
    nldl  x0, 0x0000
    nldl  x0, 0x0004

    nmu t0, s11          # m01*a0

    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000

    nma1 t0, s10        # m00*a1 + m01*a0, t0 = Y1

    nldl  x0, 0x2000
    nldl  x0, 0x0000
    nldl  x0, 0x0200
    nldl  x0, 0x0000
    nldl  x0, 0x0020
    nldl  x0, 0x0000
    nldl  x0, 0x0002
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x2000
    nldl  x0, 0x0000
    nldl  x0, 0x0200
    nldl  x0, 0x0000
    nldl  x0, 0x0020
    nldl  x0, 0x0000
    nldl  x0, 0x0002

    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000

    nldl  x0, 0x1000
    nldl  x0, 0x0000
    nldl  x0, 0x0100
    nldl  x0, 0x0000
    nldl  x0, 0x0010
    nldl  x0, 0x0000
    nldl  x0, 0x0001
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x1000
    nldl  x0, 0x0000
    nldl  x0, 0x0100
    nldl  x0, 0x0000
    nldl  x0, 0x0010
    nldl  x0, 0x0000
    nldl  x0, 0x0001

    nmu t1, s11          # m11*a0

    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000
    nldl  x0, 0x0000

    nma1 t1, s10        # m10*a1 + m11*a0, t0 = Y0

    add  s10, zero, t0
    add     s11, zero, t1
   
    # Key schedule layer
    # key1 = s2, key2 = s3, key3 = s4

    # shift key
    # newk1= key1>>19 + key3<<13 + key2<<29
    # newk2= key2>>19 + key1<<13
    # newk3= (key2<<13)>>16 || (key2>>3)[15:0]

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
    
    # pass [k79,k78,k77,k76] through sBox
    nnlanf  t0, s2
    li    t1, 0xF0000000
    and   t0, t0, t1
    li    t1, 0xFFFFFFF
    and    s2, s2, t1
    add    s2, s2, t0
    
    # add round counter to [k19,k18,k17,k16,k15]
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

    # increment round counter
    addi    s0, s0, 1

    addi    t0, zero, 32
    bne     s0, t0, round

end:
    #xor final key to state
    xor    s10, s10, s2
    xor    s11, s11, s3
    
    lw     ra, 0(sp)

    jr    ra
    .size    main, .-main
    .ident    "GCC: (GNU) 11.1.0"
