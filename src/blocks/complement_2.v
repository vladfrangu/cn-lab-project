module complement_2_block (
	input [31:0] a,
	output [31:0] out
);

	wire [31:0] negated_a;

	not_gate not_gate_0 (
		.a(a),
		.out(negated_a)
	);

	assign out = negated_a + 1;

endmodule
