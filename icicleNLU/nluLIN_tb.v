//////////////////////////////////////////////////
`timescale  1 ns / 1 ns
//////////////////////////////////////////////////
// Testbench for linear unit
//
// Testing PRESENT permutation layer, 
// (oriented on paper "A Non-Linear/Linear Instruction Set Extension for Lightweight Ciphers" by Engels et. al.)
//
// Input:
// With A1 = a{63…32} and  A0 = a{31...0}
//
// Output:
// Y1 =	y{63…32} =	a{63,59,55,51,47,43,39,35, 31,27,23,19,15,11,7,3, 62,58,54,50,46,42,38,34, 30,26,22,18,14,10,6,2}		
// Y0 =	y{31…0}	 =	a{61,57,53,49,45,41,37,33, 29,25,21,17,13,9,5,1, 60,56,52,48,44,40,36,32, 28,24,20,16,12,8,4,0}		   
//
//
// In matrix form, 
//
// Y1 = m00*A1 + m01*A0
// Y0 = m10*A1 + m11*A0
//
// m00												m01			
// 10000000	00000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00001000	00000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	10000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00001000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	10000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00001000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	10000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00001000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		10000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00001000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	10000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00001000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	10000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00001000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000000	10000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000000	00001000
// 01000000	00000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000100	00000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	01000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000100	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	01000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000100	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	01000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000100		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		01000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000100	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	01000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000100	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	01000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000100	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000000	01000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000000	00000100
// 			
//								
// m10												m11			
// 00100000	00000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000010	00000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00100000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000010	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00100000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000010	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00100000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000010		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00100000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000010	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00100000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000010	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00100000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000010	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000000	00100000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000000	00000010
// 00010000	00000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000001	00000000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00010000	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000001	00000000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00010000	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000001	00000000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00010000		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000001		00000000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00010000	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000001	00000000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00010000	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000001	00000000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00010000	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000001	00000000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000000	00010000
// 00000000	00000000	00000000	00000000		00000000	00000000	00000000	00000001
module  NLULIN_tb ;


parameter  per  =  10 ; // Clock period for 100 MHz

// Inputs declared as "registers"
reg            ck   		;
reg   [31:0]   dinp 		; // Data input
reg            mode 		; // Mode select -- 0:Nonlinear / 1:Linear
reg            modenl		; // NonLinear Mode select -- 0:ANF / 1:AES
reg            modeAES		; // AES Sbox Mode select -- 0:Encryption / 1:Decryption
reg            pushnl 		; // Push non linear mask
reg            pushl 		; // Push linear mask
reg   [3:0]    sel  		; // Push bits select
reg            acc  		; // Accumulation select
reg            mac  		; // Multiply and accumulate select
reg   [1:0]    sro  		; // Select register output
reg   [31:0]   a1 			; // a1 = a{63...32}
reg   [31:0]   a0 			; // a0 = a{31...}

reg   [31:0]   expout 		; // Expected out for Y1

// Outputs declared as "nets"
wire  [31:0]   dout ; // Data output

// Instantiate device under test (DUT)
nlunit32  dut  (
  .ck   ( ck   ) ,
  .dinp ( dinp ) ,  
  .mode ( mode ) ,
  .modenl ( modenl ) ,
  .modeAES ( modeAES ) ,
  .pushnl ( pushnl ) ,
  .pushl ( pushl ) ,
  .sel  ( sel  ) ,
  .acc  ( acc  ) ,
  .sro  ( sro  ) ,
  .mac  ( mac  ) ,  
  .dout ( dout )
) ;

// Clock
//
initial  ck  <=  1'b1 ;
always  #(per/2)  ck  <=  ~ ck ;

// Other stimulus
//
initial  // Use "initial" to define waveforms
  begin  // starting at zero time.
	#(5*per) ;  // Wait for 5 periods of time
    pushnl  <= #1  1'b0 ; // Initialize mask push
    pushl  	<= #1  1'b0 ; // Initialize mask push
    mode  	<= #1  1'b1 ; // Set mode to linear
    modenl  <= #1  1'b0 ; // Set non linear mode to AES
	modeAES <= #1  1'b0 ; // Set AES Sbox to encryption
	sel   	<= #1  4'd0 ; // Set select
	acc   	<= #1  1'b0 ; // Set accumulation select
	sro   	<= #1  2'd1 ; // Set register output select
	mac   	<= #1  1'b0 ; // Set multiply and accumulate select
	a1		<= #1  32'b01011010100101010101001100101101 ; // Random input, expected output Y1 = 01100001010000001001100101100010
	a0		<= #1  32'b00101101010100110011001101010001 ; // 							   Y0 = 01000110100111001011110101111111
	
	#(2*per) ;  // Wait for 2 periods of time
    pushl  	<= #1  1'b1 ; // Start pushing linear mask, m01
	
	dinp  	<= #1  16'h8000 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0800 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0080 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0008 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h8000 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0800 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0080 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0008 ; #(per) ;	

	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;

	dinp  	<= #1  16'h4000 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0400 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0040 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0004 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h4000 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0400 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0040 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0004 ; #(per) ;	
	
    pushl  	<= #1  1'b0 ; // Stop pushing linear mask
	dinp  	<= #1  a0 	; // m01*a1
	mac   	<= #1  1'b1 ; // Push result into fifo register
    #(per) ;
	mac		<= #1  1'b 0  ; // Stop pushing fifo registers, as we only need the first
	pushl  	<= #1  1'b 1 ; // Start pushing linear mask, m00 is m01 shifted 8 rows up while filling 0's
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;

    pushl  	<= #1  1'b0 ; // Stop pushing linear mask
	acc		<= #1  1  ;   // activate multiply+add for 1 cycle
	dinp  	<= #1  a1 ;	  // m00*a0 + m01*a1 (m01*a1 accumulated in first fifo-registers)
	mac		<= #1  1  ;	  // Push the result of Y1 into the fifo registers for testing purpose, dout should be Y1 now
    #(per) ; //
	mac		<= #1  0  ; // Stop pushing registers to keep result Y1 for testing purposes
	acc		<= #1  0  ; 
	pushl  	<= #1  1'b1 ; // Start pushing linear mask, m11
	
	dinp  	<= #1  16'h2000 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0200 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0020 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0002 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h2000 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0200 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0020 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0002 ; #(per) ;	

	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;

	dinp  	<= #1  16'h1000 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0100 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0010 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0001 ; #(per) ; dinp  	<= #1  16'h0000 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h1000 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0100 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0010 ; #(per) ;	
	dinp  	<= #1  16'h0000 ; #(per) ; dinp  	<= #1  16'h0001 ; #(per) ;	
	
    pushl  	<= #1  1'b0 ; // Stop pushing linear mask
	dinp  	<= #1  a0 	; // m11*a1
	mac   	<= #1  1'b1 ; // Push result into fifo register (Y1 is now in fifo register 1)
    #(per) ;
	mac		<= #1  1'b 0  ; // Stop pushing fifo registers, as we only need the first
	pushl  	<= #1  1'b 1 ; // Start pushing linear mask, m10 is m 11 shifted 8 rows up while filling 0's
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;
	dinp  	<= #1  16'h0000 ; #(per) ;	dinp  	<= #1  16'h0000 ; #(per) ;

    pushl  	<= #1  1'b0 ; // Stop pushing linear mask
	acc		<= #1  1  ;	  // activate multiply+add for 1 cycle
	dinp  	<= #1  a1 ;	  // m10*a0 + m11*a1 (m11*a1 accumulated in first fifo-registers)
	mac		<= #1  1  ;	  // Push the result of Y0 into the fifo registers for testing purpose, dout should be Y0 now, Y1 is in fifo register 3 now
    #(per) ;
	mac		<= #1  0  ;	  // Stop pushing FIFO registers, final result is: Y1 in FIFO rl2, Y0 in FIFO rl0 (in rl1 we have still m11*a1)
	acc		<= #1  0  ;
	#(20*per) ;  // Check to see if output is correct
    $stop ;
  end


endmodule
//////////////////////////////////////////////////

