`timescale 1ns / 1ps

module mult(
    input clk_i,
    input rst_i,
    input start_i,
    input [7:0] a1_bi,
    input [15:0] a2_bi,
    
    output reg [23:0] y_bo,
    output reg end_step_bo
);

localparam CTR_DEFAULT = 4'b0;
localparam CTR_LIMIT = 4'b1111;

reg [3:0] ctr;
wire [3:0] next_ctr;
wire end_step_bo1;

assign next_ctr = ctr + 1;
assign end_step_bo1 = ctr == CTR_LIMIT;

always @( posedge clk_i ) begin
    if ( rst_i ) begin
        ctr <= CTR_DEFAULT;
        y_bo <= 0;
        end_step_bo <= 0;
    end
    else if ( start_i ) begin
        if ( end_step_bo1 ) begin
            ctr <= CTR_DEFAULT;
            end_step_bo <= 1;
        end else if ( !end_step_bo ) begin
            ctr <= next_ctr;
            case ( a2_bi[ ctr ] )
                1: y_bo <= y_bo + ( a1_bi << ctr );
                0: y_bo <= y_bo;
            endcase
        end
    end
    else begin
        end_step_bo <= 0;
        y_bo <= 0;
    end
end

endmodule