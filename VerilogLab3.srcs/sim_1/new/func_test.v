`timescale 1ns / 1ps


module func_test( );

reg clk, rst, start;
reg [7:0] a;
reg [7:0] b;
wire f_busy;
wire [24:0] y;

func f(
    .clk( clk ),
    .rst( rst ),
    .start( start ),
    .a_b( a ),
    .b_b( b ),
    
    .result_bo( y ),
    .busy( f_busy )
);

always #10 clk = ~clk;

reg [24:0] expected_val;

integer i, j;
initial begin
    clk = 1;
    rst = 1;
    
    #50
    rst = 0;
    
    for ( i = 3; i < 4; i = i + 1 ) begin
        for ( j = 2; j < 9; j = j + 1 ) begin
            b = j * j;
            a = i;
            start = 1;
            
            #50
            expected_val = i * i * i + j;
            start = 0;
            
            #670
            if ( expected_val == y ) begin
                $display( "CORRECT: actual: %d, expected: %d", y, expected_val );
            end else begin
                $display( "ERROR: actual: %d, expected: %d, a: %d, b: %d", y, expected_val, i, j * j );
            end
        end
    end
    rst = 1;
    #80 $stop;
end

endmodule
