module sum_block #(
	parameter w = 64
) (
	input clk, rst,

	input [w-1:0] a,
	input [w-1:0] b,
	input carry_in,
	output [w-1:0] out
);
	generate
		wire [w:0] carry_outs;

		genvar i;

		for (i = 0; i < w; i = i + 1) begin
			if (i == 0) begin
				fac_block first(.clk(clk), .a(a[i]), .b(b[i]), .carry_in(carry_in), .out(out[i]), .carry_out(carry_outs[i]));
			end else begin
				fac_block others(.clk(clk), .a(a[i]), .b(b[i]), .carry_in(carry_outs[i - 1]), .out(out[i]), .carry_out(carry_outs[i]));
			end
		end
	endgenerate
endmodule

// module sum_block_tb;
// 	reg clk, rst;
// 	reg [63:0] a, b;
// 	reg carry_in;
// 	wire [63:0] out;

// 	sum_block uut(.clk(clk), .rst(rst), .a(a), .b(b), .carry_in(carry_in), .out(out));

// 	initial begin
// 		clk = 0;
// 		rst = 0;
// 		a = 64'h0000000000000000;
// 		b = 64'h0000000000000000;
// 		carry_in = 0;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);

// 		#40 rst = 1;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);
// 		#40 rst = 0;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);

// 		#40
// 		a = 64'b0000000000000000000000000000000000000000000000000000000000000011;
// 		b = 64'b0000000000000000000000000000000000000000000000000000000000000001;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);

// 		// Let it cook
// 		#40 $display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);

// 		#40 $finish;
// 	end

// 	always begin
// 		#1 clk = ~clk;
// 	end
// endmodule
