/* S-box using all normal bases */
/* case # 4 : [d^16, d], [alpha^8, alpha^2], [Omega^2, Omega] */
/* beta^8 = N^2*alpha^2, N = w^2 */
/* optimized using OR gates and NAND gates */

/* square & scale by nu in GF(2^4)/GF(2^2), normal basis [alpha^8, alpha^2] */
/* nu = beta^8 = N^2*alpha^2, N = w^2 */
module GF_SQ_SCL_4 ( A, Q );
	input [3:0] A;
	output [3:0] Q;
	wire [1:0] a, b, ab2, b2, b2N2;
	
	assign a = A[3:2];
	assign b = A[1:0];
	GF_SQ_2 absq(a ^ b,ab2);
	GF_SQ_2 bsq(b,b2);
	GF_SCLW_2 bmulN2(b2,b2N2);
	assign Q = { ab2, b2N2 };
endmodule
