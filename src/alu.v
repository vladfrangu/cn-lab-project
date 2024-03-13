module alu (
	input clk,
	input reset,
	input [31:0] a,
	input [31:0] b,
	input [3:0] op,
	output [31:0] out
	// TODO: do we want to also output a status for each operation
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

endmodule
