/* S-box using all normal bases */
/* case # 4 : [d^16, d], [alpha^8, alpha^2], [Omega^2, Omega] */
/* beta^8 = N^2*alpha^2, N = w^2 */
/* optimized using OR gates and NAND gates */

/* square in GF(2^2), using normal basis [Omega^2,Omega] */
/* inverse is the same as square in GF(2^2), using any normal basis */
module GF_SQ_2 ( A, Q );
	input [1:0] A;
	output [1:0] Q;
	
	assign Q = { A[0], A[1] };
endmodule