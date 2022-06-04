`timescale 1ns / 1ps

module sqrt(
    input clk_i,
    input rst_i,
    input start_i,
    input [7:0] x_bi,
    
    output reg [7:0] y_bo,
    output reg end_step_bo
);

localparam N = 8;
localparam M_DEFAULT = 1 << ( N - 2 );

reg [7:0] m;
reg [7:0] x;
reg busy;

wire end_step_bo0;
wire [7:0] shifted_m;
wire [7:0] b;
wire is_xgeb;
wire [7:0] next_y;
wire [7:0] next_b;


assign shifted_m = m >> 2;
assign b = y_bo | m;
assign is_xgeb = x >= b;
assign end_step_bo0 = m == 0;
assign next_y = y_bo >> 1;
assign next_b = next_y | m;

always @( posedge clk_i ) begin
    if ( rst_i || start_i ) begin
        y_bo <= 0;
        end_step_bo <= 0;
        
        m <= M_DEFAULT;
        x <= x_bi;
    end else if ( busy ) begin
        if ( end_step_bo0 ) begin
            end_step_bo <= 1;
            
            m <= M_DEFAULT;
        end else if ( !end_step_bo ) begin
            m <= shifted_m;
        
            if ( is_xgeb ) begin
                y_bo <= next_b;
                x <= x - b;
            end else
                y_bo <= next_y;
        end
    end
end

always @( * ) begin
    if ( start_i )
        busy <= 1;
    else if ( end_step_bo )
        busy <= 0;
end

endmodule