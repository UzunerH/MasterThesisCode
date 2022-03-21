	.file	"add.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
    # non linear unit test
    # ANF test
    nldnl x0, 0xE394
    nldnl x0, 0x98F4
    nldnl x0, 0x21BC
    nldnl x0, 0x4A80
    li t0, 0xC56B90AD # load expected output for testing
    li t1, 0x01234567 # load input
    nnlanf t2, t1     # call nlu non linear ANF unit
    li t0, 0x3EF84712 # load expected output for testing
    li t1, 0x89ABCDEF # load input
    nnlanf t2, t1     # call nlu non linear ANF unit
    
    # AES test
    li t0, 0xdce6f41e # load expected output for testing
    li t1, 0x93f5bae9 # load input
    nnlaese t2, t1    # call nlu non linear AES encryption unit

    li t0, 0x23979e71 # load expected output for testing
    li t1, 0x26880ba3 # load input
    nnlaesd t2, t1    # call nlu non linear AES decryption unit


    # linear unit test
    li s1, 0x5A95532D # expected output Y1 = 61409962
    li s2, 0x2D533351 # expected output Y0 = 469CBD7F

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

    nmu t0, s2          # call nlu linear unit - multiply

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

    nma1 t0, s1        # call nlu linear unit - multiply and add first FIFO reg, t0 should be result Y1 now


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

    nmu t1, s2          # call nlu linear unit - multiply

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

    nma1 t1, s1        # call nlu linear unit - multiply and add first FIFO reg, t0 should be result Y0 now


	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"