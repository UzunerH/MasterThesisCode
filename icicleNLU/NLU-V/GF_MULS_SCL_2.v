/* S-box using all normal bases */
/* case # 4 : [d^16, d], [alpha^8, alpha^2], [Omega^2, Omega] */
/* beta^8 = N^2*alpha^2, N = w^2 */
/* optimized using OR gates and NAND gates */

/* multiply & scale by N in GF(2^2), shared factors, basis [Omega^2,Omega] */
module GF_MULS_SCL_2 ( A, ab, B, cd, Q );
	input [1:0] A;
	input ab;
	input [1:0] B;
	input cd;
	output [1:0] Q;
	wire t, p, q;
	
	assign t = ~(A[0] & B[0]); /* note: ~& syntax for NAND won’t compile */
	assign p = (~(ab & cd)) ^ t;
	assign q = (~(A[1] & B[1])) ^ t;
	assign Q = { p, q };
endmodule
