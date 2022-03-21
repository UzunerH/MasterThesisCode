/* S-box using all normal bases */
/* case # 4 : [d^16, d], [alpha^8, alpha^2], [Omega^2, Omega] */
/* beta^8 = N^2*alpha^2, N = w^2 */
/* optimized using OR gates and NAND gates */

/* MUX21I is an inverting 2:1 multiplexor */
module MUX21I ( A, B, s, Q );
	input A;
	input B;
	input s;
	output Q;
	
	assign Q = ~ ( s ? A : B ); /* mock-up for FPGA implementation */
endmodule
