//////////////////////////////////////////////////
`timescale  1 ns / 1 ns
//////////////////////////////////////////////////
// Nonlinear/linear unit top module
//
module  nlunit32  ( ck , dinp , mode, modenl , modeAES, sel , pushnl, pushl , acc , mac , sro , dout ) ;


input            ck   		;
input   [31:0]   dinp 		; // Data input
input            mode 		; // Mode select -- 0:Nonlinear / 1:Linear
input            modenl		; // NonLinear Mode select -- 0:ANF / 1:AES
input            modeAES	; // AES Sbox Mode select -- 0:Encryption / 1:Decryption
input            pushnl 	; // Push non linear mask
input            pushl 		; // Push linear mask
input   [3:0]    sel  		; // Push bits select
input            acc  		; // Accumulation select
input            mac  		; // Multiply and accumulate select
input   [1:0]    sro  		; // Select register output

output  [31:0]   dout 		; // Data output

wire    [31:0]   lo  		; // linear unit out
wire    [31:0]   xlo 		;
wire    [31:0]   nlout 	; // linear unit ANF out
wire    [31:0]   aesout     ; // linear unit AES/inverse-AES out

reg     [63:0]   nlrg 		; // config register for non linear unit
reg     [1023:0] lrg = 1024'b0		; // config register for linear unit
reg     [31:0]   rl , rl0 , rl1 , rl2 , rl3 ;



// Register
//
always  @ ( posedge ck )
  if  ( pushnl )  
     case ( sel )
        4'd0  :  nlrg  <= #1  { nlrg[47:00] , dinp[15:0]  } ;
	    4'd1  :  nlrg  <= #1  { nlrg[62:00] , dinp[15]    } ;
        4'd2  :  nlrg  <= #1  { nlrg[61:00] , dinp[15:14] } ;
        4'd3  :  nlrg  <= #1  { nlrg[60:00] , dinp[15:13] } ;
        4'd4  :  nlrg  <= #1  { nlrg[59:00] , dinp[15:12] } ;
        4'd5  :  nlrg  <= #1  { nlrg[58:00] , dinp[15:11] } ;
        4'd6  :  nlrg  <= #1  { nlrg[57:00] , dinp[15:10] } ;
        4'd7  :  nlrg  <= #1  { nlrg[56:00] , dinp[15:9]  } ;
        4'd8  :  nlrg  <= #1  { nlrg[55:00] , dinp[15:8]  } ;
        4'd9  :  nlrg  <= #1  { nlrg[54:00] , dinp[15:7]  } ;
        4'd10 :  nlrg  <= #1  { nlrg[53:00] , dinp[15:6]  } ;
        4'd11 :  nlrg  <= #1  { nlrg[52:00] , dinp[15:5]  } ;
        4'd12 :  nlrg  <= #1  { nlrg[51:00] , dinp[15:4]  } ;
        4'd13 :  nlrg  <= #1  { nlrg[50:00] , dinp[15:3]  } ;
        4'd14 :  nlrg  <= #1  { nlrg[49:00] , dinp[15:2]  } ;
        4'd15 :  nlrg  <= #1  { nlrg[48:00] , dinp[15:1]  } ;
     endcase
	 
always  @ ( posedge ck )	 
  if  ( pushl )  
     case ( sel )
        4'd0  :  lrg  <= #1  { lrg[1007:00] , dinp[15:0]  } ;
	    4'd1  :  lrg  <= #1  { lrg[1022:00] , dinp[15]    } ;
        4'd2  :  lrg  <= #1  { lrg[1021:00] , dinp[15:14] } ;
        4'd3  :  lrg  <= #1  { lrg[1020:00] , dinp[15:13] } ;
        4'd4  :  lrg  <= #1  { lrg[1019:00] , dinp[15:12] } ;
        4'd5  :  lrg  <= #1  { lrg[1018:00] , dinp[15:11] } ;
        4'd6  :  lrg  <= #1  { lrg[1017:00] , dinp[15:10] } ;
        4'd7  :  lrg  <= #1  { lrg[1016:00] , dinp[15:9]  } ;
        4'd8  :  lrg  <= #1  { lrg[1015:00] , dinp[15:8]  } ;
        4'd9  :  lrg  <= #1  { lrg[1014:00] , dinp[15:7]  } ;
        4'd10 :  lrg  <= #1  { lrg[1013:00] , dinp[15:6]  } ;
        4'd11 :  lrg  <= #1  { lrg[1012:00] , dinp[15:5]  } ;
        4'd12 :  lrg  <= #1  { lrg[1011:00] , dinp[15:4]  } ;
        4'd13 :  lrg  <= #1  { lrg[1010:00] , dinp[15:3]  } ;
        4'd14 :  lrg  <= #1  { lrg[1009:00] , dinp[15:2]  } ;
        4'd15 :  lrg  <= #1  { lrg[1008:00] , dinp[15:1]  } ;
     endcase

// Linear unit
//
linear32  u_l  ( .a( dinp ) , .m( lrg ) , .y( lo ) ) ;

// Nonlinear unit
nonlinear32  u_nl  ( .a( dinp ) 	  , .m( nlrg ) , .modenl( modenl ), .modeAES( modeAES ),
				     .nlout( nlout ) ) ;


// Accumulation registers
//
always  @ ( posedge ck )  if( mac )  rl0  <= #1  xlo ;

always  @ ( posedge ck )  if( mac )  rl1  <= #1  rl0 ;
  
always  @ ( posedge ck )  if( mac )  rl2  <= #1  rl1 ;
  
always  @ ( posedge ck )  if( mac )  rl3  <= #1  rl2 ;

always  @ ( * )
  case  ( sro )
    2'h0  :  rl  =  rl3 ;
    2'h1  :  rl  =  rl0 ;
    2'h2  :  rl  =  rl1 ;
    2'h3  :  rl  =  rl2 ;
  endcase

assign  xlo  =  ( acc  ?  rl  :  32'd0 ) ^ lo ;
  
// Output
//
assign  dout  =  mode  ?  xlo  :  nlout ;


endmodule

