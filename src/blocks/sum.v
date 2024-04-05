module sum_block (
	input clk, rst,

	input [31:0] a,
	input [31:0] b,
	input carry_in,
	output [32:0] out
);

	wire [32:0] carry_outs;
	generate
		genvar i;

		for (i = 0; i < 32; i = i + 1) begin
			if (i == 0) begin
				fac_block first(.clk(clk), .a(a[i]), .b(b[i]), .carry_in(carry_in), .out(out[i]), .carry_out(carry_outs[i]));
			end else begin
				fac_block others(.clk(clk), .a(a[i]), .b(b[i]), .carry_in(carry_outs[i - 1]), .out(out[i]), .carry_out(carry_outs[i]));
			end
		end

		assign carry_out = carry_outs[31];
	endgenerate

endmodule
