module counter_to_32 (
    input wire clk,
    input wire reset,
    output reg [4:0] count,
    output reg reached
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
        reached <= 0;
    end else begin
        if (count == 31) begin
            reached = 1;
        end else begin
            count = count + 1;
            reached = 0;
        end
    end
end

endmodule

// module counter_32b_tb;
//     // Parameters
//     parameter CLK_PERIOD = 10;

//     // Signals
//     reg clk;
//     reg reset;
//     wire [4:0] count;
//     wire reached;

//     // Instantiate the module
//     counter_to_32 uut(
//         .clk(clk),
//         .reset(reset),
//         .count(count),
//         .reached(reached)
//     );

//     // Clock generation
//     always begin
//         #(CLK_PERIOD / 2) clk = ~clk;
//     end

//     // Reset generation
//     initial begin
//         clk = 0;
//         reset = 1;
//         #20 reset = 0;
//         #400 $finish;
//     end

//     // Monitor
//     always @(posedge clk) begin
//         $display("Time = %0t, Count = %d, Reached Max = %b", $time, count, reached);
//     end

// endmodule
