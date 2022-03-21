    .text
    .align    2
    .globl    main
    .type    main, @function
main:
    sw     ra, 0(sp)
    li  s0, 0xf34481ec
    li  s1, 0x3cc627ba
    li  s2, 0xcd5dc3fb
    li  s3, 0x08f273e6
    li   s4, 0x00000000
    li   s5, 0x00000000
    li   s6, 0x00000000
    li   s7, 0x00000000
    li   s10, 0x01000000
    addi s11, zero, 1
    xor  s0, s0, s4 
    xor  s1, s1, s5 
    xor  s2, s2, s6 
    xor  s3, s3, s7 
    call keyscheduleround
round:
    nnlaese s0, s0
    nnlaese s1, s1
    nnlaese s2, s2
    nnlaese s3, s3
    li  t6, 0x00FF0000
    li  t5, 0xFF00FFFF
    and t0, s0, t6 # save a10
    and t1, s1, t6 # get a11
    and s0, s0, t5 # delete a10
    or  s0, s0, t1 # write a11 into a10
    and t1, s2, t6 # get a12
    and s1, s1, t5 # delete a11
    or  s1, s1, t1 # write a12 into a11
    and t1, s3, t6 # get a13
    and s2, s2, t5 # delete a12
    or  s2, s2, t1 # write a13 into a12
    and s3, s3, t5 # delete a13
    or  s3, s3, t0 # write a10 into a13
    li  t6, 0x0000FF00
    li  t5, 0xFFFF00FF    
    and t0, s0, t6 # save a20
    and t1, s2, t6 # get a22
    and s0, s0, t5 # delete a20
    or  s0, s0, t1 # write a22 into a20
    and s2, s2, t5 # delete a22
    or  s2, s2, t0 # write a10 into a22
    and t0, s1, t6 #save a21
    and t1, s3, t6 # get a23
    and s1, s1, t5 # delete a21
    or  s1, s1, t1 # write a23 into a21
    and s3, s3, t5 # delete a23
    or  s3, s3, t0 # write a10 into a13
    li  t6, 0x000000FF
    li  t5, 0xFFFFFF00
    and t0, s0, t6 # save a30
    and t1, s3, t6 # get a33
    and s0, s0, t5 # delete a30
    or  s0, s0, t1 # write a33 into a30
    and t1, s2, t6 # get a32
    and s3, s3, t5 # delete a33
    or  s3, s3, t1 # write a32 into a33
    and t1, s1, t6 # get a31
    and s2, s2, t5 # delete a32
    or  s2, s2, t1 # write a32 into a32
    and s1, s1, t5 # delete a31
    or  s1, s1, t0 # write a30 into a31
    add  a6, zero, s0
    call mixcolumns
    add  s0, zero, a6
    add  a6, zero, s1
    call mixcolumns
    add  s1, zero, a6
    add  a6, zero, s2
    call mixcolumns
    add  s2, zero, a6
    add  a6, zero, s3
    call mixcolumns
    add  s3, zero, a6
    xor s0, s0, s4 
    xor s1, s1, s5 
    xor s2, s2, s6 
    xor s3, s3, s7 
    call keyschedule    
    addi s11, s11, 1
    addi t0, zero, 10
    bltu s11, t0, round
lastround:
    nnlaese s0, s0
    nnlaese s1, s1
    nnlaese s2, s2
    nnlaese s3, s3
    li  t6, 0x00FF0000
    li  t5, 0xFF00FFFF
    and t0, s0, t6 # save a10
    and t1, s1, t6 # get a11
    and s0, s0, t5 # delete a10
    or  s0, s0, t1 # write a11 into a10
    and t1, s2, t6 # get a12
    and s1, s1, t5 # delete a11
    or  s1, s1, t1 # write a12 into a11
    and t1, s3, t6 # get a13
    and s2, s2, t5 # delete a12
    or  s2, s2, t1 # write a13 into a12
    and s3, s3, t5 # delete a13
    or  s3, s3, t0 # write a10 into a13
    li  t6, 0x0000FF00
    li  t5, 0xFFFF00FF    
    and t0, s0, t6 # save a20
    and t1, s2, t6 # get a22
    and s0, s0, t5 # delete a20
    or  s0, s0, t1 # write a22 into a20
    and s2, s2, t5 # delete a22
    or  s2, s2, t0 # write a10 into a22
    and t0, s1, t6 #save a21
    and t1, s3, t6 # get a23
    and s1, s1, t5 # delete a21
    or  s1, s1, t1 # write a23 into a21
    and s3, s3, t5 # delete a23
    or  s3, s3, t0 # write a10 into a13
    li  t6, 0x000000FF
    li  t5, 0xFFFFFF00
    and t0, s0, t6 # save a30
    and t1, s3, t6 # get a33
    and s0, s0, t5 # delete a30
    or  s0, s0, t1 # write a33 into a30
    and t1, s2, t6 # get a32
    and s3, s3, t5 # delete a33
    or  s3, s3, t1 # write a32 into a33
    and t1, s1, t6 # get a31
    and s2, s2, t5 # delete a32
    or  s2, s2, t1 # write a32 into a32
    and s1, s1, t5 # delete a31
    or  s1, s1, t0 # write a30 into a31
    xor s0, s0, s4 
    xor s1, s1, s5 
    xor s2, s2, s6 
    xor s3, s3, s7 
    lw  ra, 0(sp)
    jr  ra
    .size main, .-main
    .ident "GCC: (GNU) 11.1.0"
mixcolumns:
    addi sp, sp, -4
    sw   ra, 0(sp)
    srli a0, a6, 24
    slli a1, a6, 8
    srli a1, a1, 24
    slli a2, a6, 16
    srli a2, a2, 24
    slli a3, a6, 24
    srli a3, a3, 24
    add  a5, zero, a0
    call mult2
    add  t0, zero, a5
    add  a5, zero, a1
    call mult2
    xor  a5, a5, a1
    xor  t0, t0, a5
    xor  t0, t0, a2
    xor  t0, t0, a3
    add  a5, zero, a1
    call mult2
    add  t1, zero, a5
    add  a5, zero, a2
    call mult2
    xor  a5, a5, a2
    xor  t1, t1, a5
    xor  t1, t1, a3
    xor  t1, t1, a0
    add  a5, zero, a2
    call mult2
    add  t2, zero, a5
    add  a5, zero, a3
    call mult2
    xor  a5, a5, a3
    xor  t2, t2, a5
    xor  t2, t2, a0
    xor  t2, t2, a1
    add  a5, zero, a3
    call mult2
    add  t3, zero, a5
    add  a5, zero, a0
    call mult2
    xor  a5, a5, a0
    xor  t3, t3, a5
    xor  t3, t3, a1
    xor  t3, t3, a2    
    slli t0, t0, 24
    slli t1, t1, 16
    slli t2, t2, 8
    add  a6, zero, t3
    add  a6, a6, t2
    add  a6, a6, t1
    add  a6, a6, t0
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret
mult2:
    slli t4, a5, 1
    li   t6, 0x80
    bltu a5, t6, continuemult2
    xori t4, t4, 0x11B
continuemult2:
    add  a5, zero, t4
    ret
keyschedule:
    slli t0, s10, 1
    li   t6, 0x80000000
    bltu s10, t6, continue
    li   t6, 0x1B000000
    xor  t0, t0, t6
continue:
    add  s10, zero, t0
keyscheduleround:
    li   t6, 0xFF000000
    and  t0, s7, t6
    srli t0, t0, 24
    slli t1, s7, 8
    add  t0, t0, t1
    nnlaese t0, t0
    xor  t0, t0, s10
    xor  s4, s4, t0
    xor  s5, s5, s4
    xor  s6, s6, s5
    xor  s7, s7, s6
    ret