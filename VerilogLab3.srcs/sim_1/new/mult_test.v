`timescale 1ns / 1ps


module mult_test( );

reg clk, rst;
reg [7:0] a;
wire busy, end_step, start;
wire [23:0] y;
wire [15:0] part_res;

assign start = ~rst;

mult m(
    .clk_i( clk ),
    .rst_i( rst ),
    .start_i( start ),
    .a1_bi( a ),
    .a2_bi( a ),
    
    .part_res( part_res ),
    .y_bo( y ),
    .busy_o( busy ),
    .end_step_bo( end_step )
);

always #10 clk = ~clk;

reg [15:0] expected_val;

integer i;
initial begin
    clk = 1;
    for ( i = 0; i < 256; i = i + 1 ) begin
        rst = 1;
        a = i;
        
        #20
        expected_val = i * i;
        
        rst = 0;
        #1000
        if ( expected_val == y ) begin
            $display( "CORRECT: actual: %d, expected: %d", y, expected_val );
        end else begin
            $display( "ERROR: actual: %d, expected: %d, a: %d", y, expected_val, a );
        end
    end
    
    rst = 1;
    #80 $stop;
end

endmodule

