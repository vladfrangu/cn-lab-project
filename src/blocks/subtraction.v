module subtraction_block (
	input clk, rst,

	input [31:0] a,
	input [31:0] b,
	output [32:0] out
);

	wire [32:0] carry_outs;

	generate
		genvar i;

		for (i = 0; i < 32; i = i + 1) begin
			if (i == 0) begin
				fac_block first(.clk(clk), .a(a[i]), .b(~b[i]), .carry_in(1'b1), .out(out[i]), .carry_out(carry_outs[i]));
			end else begin
				fac_block others(.clk(clk), .a(a[i]), .b(~b[i]), .carry_in(carry_outs[i - 1]), .out(out[i]), .carry_out(carry_outs[i]));
			end
		end

		assign carry_out = carry_outs[31];
	endgenerate
endmodule

// module subtraction_block_tb;
// 	reg clk, rst;
// 	reg [31:0] a, b;
// 	reg carry_in;
// 	wire [32:0] out;

// 	sum_block uut(.clk(clk), .rst(rst), .a(a), .b(b), .carry_in(carry_in), .out(out));

// 	initial begin
// 		clk = 0;
// 		rst = 0;
// 		a = 32'h00000000;
// 		b = 32'h00000000;
// 		carry_in = 0;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);

// 		#10 rst = 1;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);
// 		#10 rst = 0;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);

// 		#10
// 		a = 32'b00000000000000000000000000000010;
// 		b = 32'b00000000000000000000000000000001;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);

// 		// Let it cook
// 		#60 $display("clk=%b, rst=%b, a=%h, b=%h, carry_in=%b, out=%b", clk, rst, a, b, carry_in, out);

// 		#20 $finish;
// 	end

// 	always begin
// 		#5 clk = ~clk;
// 	end
// endmodule
