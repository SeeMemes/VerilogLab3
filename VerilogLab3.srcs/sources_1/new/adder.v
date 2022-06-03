`timescale 1ns / 1ps

module adder(
    input clk_i,
    input rst_i,
    input start_i,
    input [23:0] a,
    input [7:0] b,
  
    output reg [24:0] out,
    output reg end_step_bo
);

always @( posedge clk_i ) begin
    if ( rst_i ) begin
        out <= 0;
        end_step_bo <= 0;
    end else if ( start_i ) begin
        out = a + b;
        end_step_bo <= 1;
    end
end

endmodule