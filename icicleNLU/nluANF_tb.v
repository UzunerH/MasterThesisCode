//////////////////////////////////////////////////
`timescale  1 ns / 1 ns
//////////////////////////////////////////////////
// Testbench for non linear ANF module
// Testing PRESENT Sbox (according to Sbox found in paper 
// "PRESENT: An Ultra-Lightweight Block Cipher" by Bogdanov et. al.)
//
module  NLUANF_tb ;


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

reg   [31:0]   exp 			; // Expected result


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
    modenl  <= #1  1'b0 ; // Set non linear mode to ANF
	sel   	<= #1  4'd0 ; // Set select
	acc   	<= #1  1'b0 ; // Set accumulation select
	sro   	<= #1  2'd0 ; // Set register output select
	mac   	<= #1  1'b1 ; // Set multiply and accumulate select
	#(2*per) ;  // Wait for 2 periods of time
    pushnl  <= #1  1'b1 ; // Push mask
	dinp  	<= #1  16'hE394 ;
    #(per) ;
	dinp  	<= #1  16'h98F4 ;
    #(per) ;
	dinp  	<= #1  16'h21BC ;
    #(per) ;
	dinp  	<= #1  16'h4A80 ;
    #(per) ;
    pushnl  <= #1  1'b0 ; // Stop pushing mask
	dinp  	<= #1  32'h01234567 ;
	exp		<= #1  32'hC56B90AD ;
    #(per) ;
	dinp  	<= #1  32'h89ABCDEF ;
	exp		<= #1  32'h3EF84712	;
    #(20*per) ;  // Check to see if output is correct
    $stop ;
  end


endmodule
//////////////////////////////////////////////////

