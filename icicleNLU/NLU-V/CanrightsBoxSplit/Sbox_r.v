/* S-box using all normal bases */
/* case # 4 : [d^16, d], [alpha^8, alpha^2], [Omega^2, Omega] */
/* beta^8 = N^2*alpha^2, N = w^2 */
/* optimized using OR gates and NAND gates */



/* Module to get encryption and decryption sBox */
module Sbox_r ( A, S, Si );
	input [7:0] A;
	output [7:0] S;
	output [7:0] Si;

	
	bSbox sbe(A,1'b1,S);
	bSbox sbd(A,1'b0,Si);
	

endmodule
