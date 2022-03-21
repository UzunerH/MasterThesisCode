//////////////////////////////////////////////////
// Linear unit
//
module  linear32  ( a , m , y ) ;


input   [31:0]      a ;
input   [1023:0]    m ;

output  [31:0]   y ;

wire    [31:0]  coef  [31:0] ;

// Matrix definitions
//
assign  coef[31] = m[1023:992] ;
assign  coef[30] = m[991:960] ;
assign  coef[29] = m[959:928] ;
assign  coef[28] = m[927:896] ;
assign  coef[27] = m[895:864] ;
assign  coef[26] = m[863:832] ;
assign  coef[25] = m[831:800] ;
assign  coef[24] = m[799:768] ;
assign  coef[23] = m[767:736] ;
assign  coef[22] = m[735:704] ;
assign  coef[21] = m[703:672] ;
assign  coef[20] = m[671:640] ;
assign  coef[19] = m[639:608] ;
assign  coef[18] = m[607:576] ;
assign  coef[17] = m[575:544] ;
assign  coef[16] = m[543:512] ;
assign  coef[15] = m[511:480] ;
assign  coef[14] = m[479:448] ;
assign  coef[13] = m[447:416] ;
assign  coef[12] = m[415:384] ;
assign  coef[11] = m[383:352] ;
assign  coef[10] = m[351:320] ;
assign  coef[09] = m[319:288] ;
assign  coef[08] = m[287:256] ;
assign  coef[07] = m[255:224] ;
assign  coef[06] = m[223:192] ;
assign  coef[05] = m[191:160] ;
assign  coef[04] = m[159:128] ;
assign  coef[03] = m[127:96] ;
assign  coef[02] = m[95:64] ;
assign  coef[01] = m[63:32] ;
assign  coef[00] = m[31:0] ;

/*
assign  coef[00] = m[1023:992] ;
assign  coef[01] = m[991:960] ;
assign  coef[02] = m[959:928] ;
assign  coef[03] = m[927:896] ;
assign  coef[04] = m[895:864] ;
assign  coef[05] = m[863:832] ;
assign  coef[06] = m[831:800] ;
assign  coef[07] = m[799:768] ;
assign  coef[08] = m[767:736] ;
assign  coef[09] = m[735:704] ;
assign  coef[10] = m[703:672] ;
assign  coef[11] = m[671:640] ;
assign  coef[12] = m[639:608] ;
assign  coef[13] = m[607:576] ;
assign  coef[14] = m[575:544] ;
assign  coef[15] = m[543:512] ;
assign  coef[16] = m[511:480] ;
assign  coef[17] = m[479:448] ;
assign  coef[18] = m[447:416] ;
assign  coef[19] = m[415:384] ;
assign  coef[20] = m[383:352] ;
assign  coef[21] = m[351:320] ;
assign  coef[22] = m[319:288] ;
assign  coef[23] = m[287:256] ;
assign  coef[24] = m[255:224] ;
assign  coef[25] = m[223:192] ;
assign  coef[26] = m[191:160] ;
assign  coef[27] = m[159:128] ;
assign  coef[28] = m[127:96] ;
assign  coef[29] = m[95:64] ;
assign  coef[30] = m[63:32] ;
assign  coef[31] = m[31:0] ;
*/


// Multiply
//
genvar  i ;
generate
  for  ( i  =  0 ;  i  <  32 ;  i  =  i + 1 )
    begin  :  matmult
       assign  y[i] = ^ ( a & coef[i] ) ;
    end
endgenerate


endmodule

