module multiplier_block (
	input clk, rst,

	input [63:0] a,
	input [63:0] b,

	output reg [63:0] out
);

// Use booth radix-4 algorithm

reg q_minus_1;
reg [64:0] a_register;
reg [63:0] q_register;
reg [63:0] m_register;

reg [63:0] m_register_negated;
reg [64:0] m_register_double;
reg [64:0] m_register_negated_double;

wire [4:0] counter_count;
wire counter_reached;

counter_to_32 counter (
	.clk(clk),
	.reset(rst),
	.count(counter_count),
	.reached(counter_reached)
);

reg [2:0] state;

localparam ShiftOnly = 3'b000;
localparam AddM = 3'b001;
localparam SubM = 3'b010;
localparam Add2M = 3'b011;
localparam Sub2M = 3'b100;
localparam Done = 3'b111;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		q_minus_1 <= 1'b0;
		a_register <= 64'b0;
		q_register <= a;
		m_register <= b;

		m_register_negated <= (~m_register) + 1;
		m_register_double <= m_register << 1;
		m_register_negated_double <= m_register_negated << 1;

		case ({ q_register[1], q_register[0], q_minus_1 })
			3'b000,
			3'b111: begin
				state <= ShiftOnly;
			end

			3'b001,
			3'b010: begin
				state <= AddM;
			end

			3'b011: begin
				state <= Add2M;
			end

			3'b100: begin
				state <= Sub2M;
			end

			3'b101,
			3'b110: begin
				state <= SubM;
			end
		endcase
	end else begin
		if (counter_reached) begin
			state <= Done;
			out = {a_register[63:0], q_register[63:0]};
		end else begin
			case (state)
				ShiftOnly: begin
					// Shift only, cascade into if lower
				end
				AddM: begin
					// TODO: use sum_block
					a_register = a_register + m_register;
				end
				SubM: begin
					// Sub M
					a_register = a_register + m_register_negated;
				end
				Add2M: begin
					// TODO: use sum_block
					a_register = a_register + m_register_double;
				end
				Sub2M: begin
					a_register = a_register + m_register_negated_double;
				end
				Done: begin
					// Do nothing, await reset
				end
			endcase

			if (state != Done) begin
				// Shift
				{a_register[61:0], q_register[63:0], q_minus_1} = {a_register[64:0], q_register[63:1]};
				a_register[62] = a_register[60];
				a_register[63] = a_register[60];

				case ({ q_register[1], q_register[0], q_minus_1 })
					3'b000,
					3'b111: begin
						state <= ShiftOnly;
					end

					3'b001,
					3'b010: begin
						state <= AddM;
					end

					3'b011: begin
						state <= Add2M;
					end

					3'b100: begin
						state <= Sub2M;
					end

					3'b101,
					3'b110: begin
						state <= SubM;
					end
				endcase
			end
		end
	end
end
endmodule

// module multiplier_block_tb;
// 	reg clk, rst;
// 	reg [63:0] a, b;
// 	wire [63:0] out;

// 	multiplier_block uut(.clk(clk), .rst(rst), .a(a), .b(b), .out(out));

// 	initial begin
// 		clk = 0;
// 		rst = 0;
// 		a = 64'h00000000;
// 		b = 64'h00000000;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, out=%h", clk, rst, a, b, out);

// 		a = 64'b1111111111111111111111111111111111111111111111111111111111111101;
// 		b = 64'b1111111111111111111111111111111111111111111111111111111111111101;

// 		#40 rst = 1;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, out=%h", clk, rst, a, b, out);
// 		#40 rst = 0;
// 		$display("clk=%b, rst=%b, a=%h, b=%h, out=%h", clk, rst, a, b, out);

// 		$display("clk=%b, rst=%b, a=%h, b=%h, out=%b", clk, rst, a, b, out);

// 		// Let it cook
// 		#1000 $display("clk=%b, rst=%b, a=%h, b=%h, out=%b", clk, rst, a, b, out);

// 		#20 $finish;
// 	end

// 	always begin
// 		#1 clk = ~clk;
// 	end
// endmodule
