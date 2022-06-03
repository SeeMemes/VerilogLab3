`timescale 1ns / 1ps

module func(
    input clk,
    input rst,
    input start,
    input [7:0] a_b,
    input [7:0] b_b,
    
    output reg [23:0] m_res,
    output reg [7:0] s_res,
    output [24:0] result_bo,
    output m_end_step,
    output s_end_step,
    output reg [2:0] m_state,
    output [23:0] m_y_bo,
    output reg busy
);

assign result_bo = s_res + m_res;
localparam POWER2 = 2'b0;
localparam POWER3 = 2'b01;
localparam ENDSTATE = 2'b10;
localparam MUL_REFRESH = 2'b11;

wire m_start_i;
wire [7:0] m_a_bi;
wire [15:0] m_b_bi;
wire m_busy_o;
wire m_power_end;

always @( posedge clk ) begin
    if ( rst ) begin
        m_res <= 0;
        m_state <= POWER2;
    end else begin
        if ( start ) begin
            if (m_power_end)
                m_res <= m_y_bo;
        end
    end
    
    case ( m_state )
        POWER2:
            m_state <= (m_power_end) ? MUL_REFRESH : POWER2;
        MUL_REFRESH:
            m_state <= POWER3;
        POWER3:
            m_state <= (m_power_end) ? ENDSTATE : POWER3;
    endcase
end
assign m_end_step = m_state == ENDSTATE;

assign m_start_i = (m_state == POWER2 || m_state == POWER3);
assign m_b_bi = (m_state == POWER3) ? m_res : a_b;
assign m_a_bi = a_b;
mult m(
    .clk_i( clk ),
    .rst_i( rst ),
    .start_i( m_start_i ),
    .a1_bi( m_a_bi ),
    .a2_bi( m_b_bi ),
    
    .y_bo( m_y_bo ),
    .busy_o( m_busy_o ),
    .end_step_bo( m_power_end )
);


reg s_start_i;
wire s_busy_o;
reg [7:0] s_x_bi;
wire [7:0] s_y_bo;

always @( posedge clk ) begin
    if ( rst ) begin
        s_start_i <= 0;
        s_res <= 0;
        s_x_bi <= b_b;
    end else if ( m_end_step && !s_end_step ) begin
        s_start_i <= 1;
    end else if ( s_end_step ) begin
        s_start_i <= 0;
        s_res <= s_y_bo;
    end
end

sqrt s(
    .clk_i( clk ),
    .rst_i( rst ),
    .start_i( s_start_i ),
    .x_bi( s_x_bi ),
    
    .y_bo( s_y_bo ),
    .busy_o( s_busy_o ),
    .end_step_bo( s_end_step )
);

always @( posedge clk ) begin
    if ( rst )
        busy <= 0;
    else if ( start )
        if ( s_end_step ) begin
            busy <= 0;
        end else
            busy <= 1;
end

endmodule