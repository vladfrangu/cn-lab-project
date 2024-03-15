module sum_block (
	input [31:0] a,
	input [31:0] b,
	output [32:0] out
);

	assign out = a + b;

endmodule
