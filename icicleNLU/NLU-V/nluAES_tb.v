//////////////////////////////////////////////////
`timescale  1 ns / 1 ns
//////////////////////////////////////////////////
// Testbench for AES module
// Testing Sbox and inverse Sbox with random values from Rijndael LUT https://en.wikipedia.org/wiki/Rijndael_S-box
//
module  NLUAES_tb ;


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

reg   [31:0]   expout 		; // Expected out of Sbox

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
    mode  	<= #1  1'b0 ; // Set mode to non linear
    modenl  <= #1  1'b1 ; // Set non linear mode to AES
	sel   	<= #1  4'd0 ; // Set select
	acc   	<= #1  1'b0 ; // Set accumulation select
	sro   	<= #1  2'd0 ; // Set register output select
	mac   	<= #1  1'b1 ; // Set multiply and accumulate select
	#(2*per) ;  // Wait for 2 periods of time
	modeAES <= #1  1'b0 ; // Set AES Sbox to encryption
	dinp  	<= #1  32'h93f5bae9 ;
	expout	<= #1  32'hdce6f41e ;
    #(per) ;
	modeAES <= #1  1'b1 ; // Set AES Sbox to decryption
    dinp  	<= #1  32'h26880ba3 ;
	expout	<= #1  32'h23979e71 ;
	#(20*per) ;  // Check to see if output is correct
    $stop ;
  end


endmodule
//////////////////////////////////////////////////

