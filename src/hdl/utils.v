module Debounce (
    input  clk,
    input  in,
    output out
);
    reg [9:0] shift_reg;

    always @(posedge clk) begin
        shift_reg <= {shift_reg[8:0], in};
    end
    assign out = &shift_reg;
endmodule : Debounce

module OnePulse(
    input  clk,
    input  in,
    output out
);
    reg in_d;

    always @(posedge clk) begin
        in_d <= in;
    end
    assign out = in & ~in_d;
endmodule : OnePulse

module PulseGen #(
    parameter CLK_FREQ = 100_000_000,
    parameter OUT_FREQ = 9600
)(
    input      rst,
    input      clk,
    output reg out
);
    localparam CNT_MAX   = CLK_FREQ / OUT_FREQ;
    localparam CNT_WIDTH = $clog2(CNT_MAX);

    reg [CNT_WIDTH - 1:0] cnt;

    always @(posedge clk) begin
        if (rst) begin
            cnt <= 0;
            out <= 1'b0;
        end else if (cnt >= CNT_MAX - 1) begin
            cnt <= 0;
            out <= 1'b1;
        end else begin
            cnt <= cnt + 1;
            out <= 1'b0;
        end
    end
endmodule : PulseGen
