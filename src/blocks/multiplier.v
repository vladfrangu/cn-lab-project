module multiplier_block (
	input clk, rst,

	input [31:0] a,
	input [31:0] b,

	output [63:0] out
);

// Use booth radix-4 algorithm

reg q_minus_1;
reg [32:0] a_register;
reg [31:0] q_register;
reg [31:0] m_register;

reg [31:0] m_register_negated;
reg [31:0] m_register_double;
reg [31:0] m_register_negated_double;

reg [2:0] state, next_state;
reg [1:0] count;

localparam State_AddM = 3'b000;
localparam State_SubM = 3'b001;
localparam State_Add2M = 3'b010;
localparam State_Sub2M = 3'b011;
localparam State_Shift = 3'b100;

localparam State_Initial = 3'b111;

reg done;

always @(posedge clk, negedge rst) begin
	if (rst == 0) begin
		count <= 2'b0;

		q_minus_1 <= 1'b0;
		a_register <= 32'b0;
		q_register <= a;
		m_register <= b;
		count <= 2'b0;

		m_register_negated <= ~m_register + 1;
		m_register_double <= m_register << 1;
		m_register_negated_double <= m_register_negated << 1;
	end else begin
		count <= count + 1;

		if (count == 2'b11) begin
			done <= 1;
		end
	end
end

always @(count) begin
if (done != 1) begin
	case ({q_register[1], q_register[0], q_minus_1})
		3'b000,
		3'b111: begin
			// Shift only
			{a_register[30:0], q_register, q_minus_1} <= {a_register[32:0], q_register[31:1]};
			a_register[31] <= a_register[32];
			a_register[32] <= a_register[32];
		end

		3'b001,
		3'b010: begin
			// add M
			a_register <= a_register + m_register;
			// Shift
			{a_register[30:0], q_register, q_minus_1} <= {a_register[32:0], q_register[31:1]};
			a_register[31] <= a_register[32];
			a_register[32] <= a_register[32];
		end

		3'b011: begin
			// Add 2M
			a_register <= a_register + m_register_double;
			// Shift
			{a_register[30:0], q_register, q_minus_1} <= {a_register[32:0], q_register[31:1]};
			a_register[31] <= a_register[32];
			a_register[32] <= a_register[32];
		end

		3'b100: begin
			// Sub 2M
			a_register <= a_register + m_register_negated_double;
			// Shift
			{a_register[30:0], q_register, q_minus_1} <= {a_register[32:0], q_register[31:1]};
			a_register[31] <= a_register[32];
			a_register[32] <= a_register[32];
		end

		3'b101,
		3'b110: begin
			// Sub M
			a_register <= a_register + m_register_negated;
			// Shift
			{a_register[30:0], q_register, q_minus_1} <= {a_register[32:0], q_register[31:1]};
			a_register[31] <= a_register[32];
			a_register[32] <= a_register[32];
		end
	endcase
end
end

assign out = {a_register[31:0], q_register};

endmodule
