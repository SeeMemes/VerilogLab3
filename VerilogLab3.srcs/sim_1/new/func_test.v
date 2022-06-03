`timescale 1ns / 1ps


module func_test( );

reg clk, rst;
reg [7:0] a;
reg [7:0] b;
wire start, f_busy;
wire [24:0] y;
wire [23:0] a3_test;
wire [7:0] sqrtb_test;
wire s_end_step;
wire m_end_step;

assign start = ~rst;

func f(
    .clk( clk ),
    .rst( rst ),
    .start( start ),
    .a_b( a ),
    .b_b( b ),
    
    .result_bo( y ),
    .m_res( a3_test ),
    .s_res( sqrtb_test ),
    .m_end_step ( m_end_step ),
    .s_end_step ( s_end_step ),
    .busy( f_busy )
);

always #10 clk = ~clk;

reg [24:0] expected_val;

integer i, j;
initial begin
    clk = 1;
    for ( i = 2; i < 256; i = i + 1 ) begin
        for ( j = 0; j < 16; j = j + 1 ) begin
            b = j * j;
            a = i;
            rst = 1;
            
            #50
            expected_val = i * i * i + j;
            rst = 0;
            
            #1000
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
