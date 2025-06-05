module DMEM(
	input CK,
	input CE,
	input WE,
	input [7:0] A,
	input [31:0] D,
	output [31:0] Q
);

	MEM1_256X32 u_mem(
		.CK(CK),
		.CE(CE),
		.WE(WE),
		.A(A),
		.D(D),
		.Q(Q)
	);
endmodule
