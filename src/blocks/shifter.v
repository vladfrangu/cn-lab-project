module shift_block (
	input [31:0] a,
	input direction,
	output [31:0] out
);

	assign out = (direction) ? a << 1 : a >> 1;

endmodule
