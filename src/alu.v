module alu (
	input clk,
	input reset,
	input [63:0] a,
	input [63:0] b,
	input [3:0] op,
	output reg [63:0] out,
	output reg [64:0] division_remainder
);

localparam OP_ADD = 4'b0000;
localparam OP_SUB = 4'b0001;
localparam OP_MUL = 4'b0010;
localparam OP_DIV = 4'b0011;
localparam OP_AND = 4'b0100;
localparam OP_OR = 4'b0101;
localparam OP_XOR = 4'b0110;
localparam OP_NOT = 4'b0111;
localparam OP_SHL = 4'b1000;
localparam OP_SHR = 4'b1001;

wire [63:0] sum_out;
sum_block sum_block_inst (
	.clk(clk),
	.rst(reset),
	.a(a),
	.b(b),
	.carry_in(1'b0),
	.out(sum_out)
);

wire [63:0] subtraction_out;
subtraction_block subtraction_block_inst (
	.clk(clk),
	.rst(reset),
	.a(a),
	.b(b),
	.out(subtraction_out)
);

wire [63:0] multiplication_out;
multiplier_block multiplier_block_inst (
	.clk(clk),
	.rst(reset),
	.a(a),
	.b(b),
	.out(multiplication_out)
);

wire [63:0] division_quatient;
wire [64:0] division_remainder_raw;
division_block division_block_inst (
	.clk(clk),
	.rst(reset),
	.a(a),
	.b(b),
	.quatient(division_quatient),
	.remainder(division_remainder_raw)
);

reg shift_right_enabled;
wire [63:0] shift_right_out;
shift_block shift_right_block_inst (
	.clk(clk),
	.rst(reset),
	.enabled(1'b1),
	.direction(1'b0),
	.a(a),
	.out(shift_right_out)
);

reg shift_left_enabled;
wire [63:0] shift_left_out;
shift_block shift_left_block_inst (
	.clk(clk),
	.rst(reset),
	.enabled(1'b1),
	.direction(1'b1),
	.a(a),
	.out(shift_left_out)
);

always @(posedge clk or posedge reset) begin
	if (reset) begin
		out <= 64'b0;
		shift_right_enabled <= 1'b1;
		shift_left_enabled <= 1'b1;
	end else begin
		if (shift_right_enabled) begin
			shift_right_enabled <= 1'b0;
		end

		if (shift_left_enabled) begin
			shift_left_enabled <= 1'b0;
		end

		case (op)
			OP_ADD: begin
				out <= sum_out;
			end

			OP_SUB: begin
				out <= subtraction_out;
			end

			OP_MUL: begin
				out <= multiplication_out;
			end

			OP_DIV: begin
				out <= division_quatient;
				division_remainder <= division_remainder_raw;
			end

			OP_AND: begin
				out <= a & b;
			end

			OP_OR: begin
				out <= a | b;
			end

			OP_XOR: begin
				out <= a ^ b;
			end

			OP_NOT: begin
				out <= ~a;
			end

			OP_SHL: begin
				out <= shift_left_out;
			end

			OP_SHR: begin
				out <= shift_right_out;
			end
		endcase
	end
end

endmodule

module alu_tb;

	reg clk, reset;
	reg [63:0] a, b;
	reg [3:0] op;
	wire [63:0] out;
	wire [64:0] division_remainder;

	alu alu_inst (
		.clk(clk),
		.reset(reset),
		.a(a),
		.b(b),
		.op(op),
		.out(out),
		.division_remainder(division_remainder)
	);

	initial begin
		clk <= 1'b0;
		reset <= 1'b1;
		a <= 64'b0;
		b <= 64'b0;
		op <= 4'b0000;

		#100 reset <= 1'b0;

		// a <= 64'b1;
		// b <= 64'b1;
		// op <= 4'b0000;

		// #200 $display("out=%d (%b)", out, out);

		// a <= 64'b1;
		// b <= 64'b1;
		// op <= 4'b0001;

		// #200 $display("out=%d (%b)", out, out);

		// a <= 64'b1111111111111111111111111111111111111111111111111111111111111101;
		// b <= 64'b1111111111111111111111111111111111111111111111111111111111111101;
		// op <= 4'b0010;

		// #200 $display("out=%d (%b)", out, out);

		a <= 64'b11;
		b <= 64'd3;
		op <= 4'b0011;

		#200 $display("out=%d (%b), remainder=%d (%b)", out, out, division_remainder, division_remainder);

		#10 $finish;
	end

	always begin
		#1 clk <= ~clk;
	end

endmodule
