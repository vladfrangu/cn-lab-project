module shift_block (
	input clk, rst,
	input enabled,
	input direction,

	input [31:0] a,

	output reg [31:0] out
);

	always @(posedge clk) begin
		if (rst) begin
			out <= 0;
		end else begin
			if (enabled) begin
				if (direction) begin
					out <= {a[30:0], 32'b0};
				end else begin
					out <= {32'b0, a[31:1]};
				end
			end else begin
				out <= out;
			end
		end
	end

endmodule

