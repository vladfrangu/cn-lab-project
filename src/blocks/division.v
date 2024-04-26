module division_block (
	input clk, rst,

	input [63:0] a, b,

	output reg [63:0] quatient,
	output reg [64:0] remainder
);

reg sign_bit;
reg [63:0] a_register;
reg [63:0] q_register;
reg [63:0] m_register;

wire [5:0] counter_count;
wire counter_reached;

counter_to_64 counter (
	.clk(clk),
	.reset(rst),
	.count(counter_count),
	.reached(counter_reached)
);

reg [1:0] state;

localparam Processing = 2'b00;
localparam Done = 2'b11;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		sign_bit <= 1'b0;
		{sign_bit, a_register, q_register} <= {a, 1'd0};
		m_register <= b;
		sign_bit <= a[63];
		state <= Processing;
	end else begin
		if (counter_reached) begin
			state <= Done;

			if (sign_bit) begin
				a_register = a_register + m_register;
			end

			quatient <= q_register >> 1;
			remainder <= a_register >> 1;
		end else begin
			case (state)
				Processing: begin
					if (sign_bit) begin
						{sign_bit, a_register} = {sign_bit, a_register} + {1'd0, m_register};
					end else begin
						{sign_bit, a_register} = {sign_bit, a_register} - {1'd0, m_register};
					end

					if (sign_bit) begin
						q_register[0] = 1'b0;
					end else begin
						q_register[0] = 1'b1;
					end

					{sign_bit, a_register, q_register} = {sign_bit, a_register, q_register} << 1;
				end
				Done: begin
					// Do nothing
				end
			endcase
		end
	end
end
endmodule

// module division_tb;
// 	reg clk, rst;
// 	reg [63:0] a, b;
// 	wire [63:0] quatient;
// 	wire [64:0] remainder;

// 	division_block division_block (
// 		.clk(clk),
// 		.rst(rst),
// 		.a(a),
// 		.b(b),
// 		.quatient(quatient),
// 		.remainder(remainder)
// 	);

// 	initial begin
// 		clk = 0;
// 		rst = 0;

// 		a = 64'd11;
// 		b = 64'd3;

// 		#10 rst = 1;
// 		#10 rst = 0;

// 		#1000 $display("clk=%b, rst=%b, a=%d, b=%d, quatient=%b, remainder=%b", clk, rst, a, b, quatient, remainder);

// 		#20 $finish;
// 	end

// 	always begin
// 		#1 clk = ~clk;
// 	end
// endmodule
