module not_gate (
	input [31:0] a,
	output [31:0] out
);

	assign out = ~a;

endmodule
