module subtraction_block (
	input clk, rst,

	input [63:0] a,
	input [63:0] b,
	output [63:0] out
);
	sum_block uut(
		.clk(clk),
		.rst(rst),
		.a(a),
		.b(~b),
		.carry_in(1'b1),
		.out(out)
	);
endmodule

// module subtraction_block_tb;
// 	reg clk, rst;
// 	reg [63:0] a, b;
// 	wire [63:0] out;

// 	subtraction_block uut(.clk(clk), .rst(rst), .a(a), .b(b), .out(out));

// 	initial begin
// 		clk = 0;
// 		rst = 0;
// 		a = 64'h0000000000000000;
// 		b = 64'h0000000000000000;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, out=%b", clk, rst, a, b, out);

// 		#40 rst = 1;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, out=%b", clk, rst, a, b, out);
// 		#40 rst = 0;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, out=%b", clk, rst, a, b, out);

// 		#40
// 		a = 64'b1111111111111111111111111111111111111111111111111111111111111110;
// 		b = 64'b0000000000000000000000000000000000000000000000000000000000000001;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, out=%b", clk, rst, a, b, out);

// 		// Let it cook
// 		#40 $display("clk=%b, rst=%b, a=%h, b=%h, out=%b", clk, rst, a, b, out);

// 		#40 $finish;
// 	end

// 	always begin
// 		#1 clk = ~clk;
// 	end
// endmodule

