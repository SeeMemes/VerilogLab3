`timescale 1ns / 1ps


module adder_test( );

reg clk, rst;
reg [7:0] a;
reg [23:0] b;
wire start, end_step;
wire [24:0] y;

assign start = ~rst;

adder add(
    .clk_i( clk ),
    .rst_i( rst ),
    .start_i( start ),
    .a( a ),
    .b( b ),
    .out( y ),
    .end_step_bo( end_step )
);

always #10 clk = ~clk;

reg [15:0] expected_val;

integer i, j;
initial begin
    clk = 1;
    for ( i = 1; i < 256; i = i + 1 ) begin
        for ( j = 0; j < 16; j = j + 1 ) begin
            b = j;
            a = i;
            rst = 1;
            
            #10
            expected_val = i + j;
            rst = 0;
            
            #1000
            if ( expected_val == y ) begin
                $display( "CORRECT: actual: %d, expected: %d", y, expected_val );
            end else begin
                $display( "ERROR: actual: %d, expected: %d, a: %d, b: %d", y, expected_val, i, j );
            end
        end
    end
    
    rst = 1;
    #80 $stop;
end

endmodule
