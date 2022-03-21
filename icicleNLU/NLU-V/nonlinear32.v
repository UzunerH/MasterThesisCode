//////////////////////////////////////////////////
// Nonlinear unit
//
module  nonlinear32  ( a , m , modenl, modeAES, nlout ) ;

	input   [31:0]  	a ; // Data input
	input   [63:0]  	m ; // ANF mask
    input           modenl; // NonLinear Mode select -- 0:ANF / 1:AES
	input		   modeAES; // AES Sbox Mode select -- 0:Encryption / 1:Decryption
	
	output	[31:0]		nlout;
	
	wire	[31:0]		anfout;
	wire	[31:0]		aesoutenc;
	wire	[31:0]		aesoutdec;
	
	ANFunit anf (
		.a(a),
		.m(m),
		.y(anfout)
	) ;
	
	AESunit aes (
		.a(a),
		.S(aesoutenc),
		.Si(aesoutdec)
	) ;
	
	assign nlout = modenl ? (modeAES ? aesoutdec : aesoutenc) : anfout ;
	
endmodule

//////////////////////////////////////////////////
// AES unit
//
module  AESunit  ( a , S , Si ) ;

	input   [31:0]  	a ;
	
	output [31:0]	S ;
	output [31:0]	Si ;
	
	wire [7:0] S0;
	wire [7:0] S1;
	wire [7:0] S2;
	wire [7:0] S3;
	
	wire [7:0] Si0;
	wire [7:0] Si1;
	wire [7:0] Si2;
	wire [7:0] Si3;
	
	// AES
	Sbox_r  aesSbox0  ( .A ( a[31:24] ) , .S ( S0 ) , .Si ( Si0 ) ) ;

	// AES
	Sbox_r  aesSbox1  ( .A ( a[23:16] ) , .S ( S1 ) , .Si ( Si1 ) ) ;
	
	// AES
	Sbox_r  aesSbox2  ( .A ( a[15:8] ) , .S ( S2 ) , .Si ( Si2 ) ) ;
	
	// AES
	Sbox_r  aesSbox3  ( .A ( a[7:0] ) , .S ( S3 ) , .Si ( Si3 ) ) ;
	
	assign S  = {S0,S1,S2,S3} ;
	assign Si = {Si0,Si1,Si2,Si3} ;
	
endmodule

//////////////////////////////////////////////////
// ANF unit
//
module  ANFunit  ( a , m , y ) ;

	input   [31:0]  a ;
	input   [63:0]  m ;

	output  [31:0]  y ;

	wire    [3:0]   o0 ;
	wire    [3:0]   o1 ;
	wire    [3:0]   o2 ;
	wire    [3:0]   o3 ;
	wire    [3:0]   o4 ;
	wire    [3:0]   o5 ;
	wire    [3:0]   o6 ;
	wire    [3:0]   o7 ;

	ANFSbox c0 (
		.a(a[31:28]),
		.m(m),
		.y(o0)
	) ;
	ANFSbox c1 (
		.a(a[27:24]),
		.m(m),
		.y(o1)
	) ;
	ANFSbox c2 (
		.a(a[23:20]),
		.m(m),
		.y(o2)
	) ;
	ANFSbox c3 (
		.a(a[19:16]),
		.m(m),
		.y(o3)
	) ;
	ANFSbox c4 (
		.a(a[15:12]),
		.m(m),
		.y(o4)
	) ;
	ANFSbox c5 (
		.a(a[11:8]),
		.m(m),
		.y(o5)
	) ;
	ANFSbox c6 (
		.a(a[7:4]),
		.m(m),
		.y(o6)
	) ;
	ANFSbox c7 (
		.a(a[3:0]),
		.m(m),
		.y(o7)
	) ;

	assign y = {o0,o1,o2,o3,o4,o5,o6,o7} ;
                  
endmodule


//////////////////////////////////////////////////
// 4bit ANF-Sbox for Nonlinear unit
//
module  ANFSbox  ( a , m , y ) ;

	input   [3:0]   a ;
	input   [63:0] m ;

	output  [3:0]   y ;

	wire            a0 , a1 , a2 , a3 ;
	wire            p0 , p1 , p2 , p3 , p4 , p5 , p6 , p7 , p8 , p9 , pA , pB , pC , pD , pE , pF ;


	// Split input
	//
	assign  a0  =  a[3] ;
	assign  a1  =  a[2] ;
	assign  a2  =  a[1] ;
	assign  a3  =  a[0] ;

	// ANF bits
	//
	assign p0 = 1'b1 ;
	assign p1 = a3 ;
	assign p2 = a2 ;
	assign p3 = a2 & a3 ;
	assign p4 = a1 ;
	assign p5 = a1 & a3 ;
	assign p6 = a1 & a2 ;
	assign p7 = a1 & a2 & a3 ;
	assign p8 = a0 ;
	assign p9 = a0 & a3 ;
	assign pA = a0 & a2 ;
	assign pB = a0 & a2 & a3 ;
	assign pC = a0 & a1 ;
	assign pD = a0 & a1 & a3 ;
	assign pE = a0 & a1 & a2 ;
	assign pF = a0 & a1 & a2 & a3 ;


	// Form output
	//
	assign  y[3]  = ( m[63] & p0 ) ^ ( m[62] & p1 ) ^ ( m[61] & p2 ) ^ ( m[60] & p3 ) ^ ( m[59] & p4 ) ^ ( m[58] & p5 ) ^ ( m[57] & p6 ) ^ ( m[56] & p7 ) ^
					( m[55] & p8 ) ^ ( m[54] & p9 ) ^ ( m[53] & pA ) ^ ( m[52] & pB ) ^ ( m[51] & pC ) ^ ( m[50] & pD ) ^ ( m[49] & pE ) ^ ( m[48] & pF ) ;
	assign  y[2]  = ( m[47] & p0 ) ^ ( m[46] & p1 ) ^ ( m[45] & p2 ) ^ ( m[44] & p3 ) ^ ( m[43] & p4 ) ^ ( m[42] & p5 ) ^ ( m[41] & p6 ) ^ ( m[40] & p7 ) ^
					( m[39] & p8 ) ^ ( m[38] & p9 ) ^ ( m[37] & pA ) ^ ( m[36] & pB ) ^ ( m[35] & pC ) ^ ( m[34] & pD ) ^ ( m[33] & pE ) ^ ( m[32] & pF ) ;
	assign  y[1]  = ( m[31] & p0 ) ^ ( m[30] & p1 ) ^ ( m[29] & p2 ) ^ ( m[28] & p3 ) ^ ( m[27] & p4 ) ^ ( m[26] & p5 ) ^ ( m[25] & p6 ) ^ ( m[24] & p7 ) ^
					( m[23] & p8 ) ^ ( m[22] & p9 ) ^ ( m[21] & pA ) ^ ( m[20] & pB ) ^ ( m[19] & pC ) ^ ( m[18] & pD ) ^ ( m[17] & pE ) ^ ( m[16] & pF ) ;
	assign  y[0]  = ( m[15] & p0 ) ^ ( m[14] & p1 ) ^ ( m[13] & p2 ) ^ ( m[12] & p3 ) ^ ( m[11] & p4 ) ^ ( m[10] & p5 ) ^ ( m[09] & p6 ) ^ ( m[08] & p7 ) ^
					( m[07] & p8 ) ^ ( m[06] & p9 ) ^ ( m[05] & pA ) ^ ( m[04] & pB ) ^ ( m[03] & pC ) ^ ( m[02] & pD ) ^ ( m[01] & pE ) ^ ( m[00] & pF ) ;
	 
endmodule

