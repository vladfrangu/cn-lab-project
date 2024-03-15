module multiply_block (
	input [31:0] a,
	input [31:0] b,
	output [63:0] out
);

	assign out = a * b;

endmodule
