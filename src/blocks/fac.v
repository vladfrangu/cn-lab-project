module fac_block(
	input clk, rst,
	input a,
	input b,
	input carry_in,

	output reg out,
	output reg carry_out
);

	always @(posedge clk or negedge rst)
	begin
		if (!rst) begin
			out <= 0;
			carry_out <= 0;
		end else begin
			out <= a ^ b ^ carry_in;
			carry_out <= (a & b) | (b & carry_in) | (carry_in & a) ;
		end
	end

endmodule
