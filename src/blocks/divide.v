module divide_block (
	input [31:0] a,
	input [31:0] b,
	output [31:0] quatient,
	output [31:0] remainder
);

	assign quatient = a / b;
	assign remainder = a % b;

endmodule
