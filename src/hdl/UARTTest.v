module UARTTest(
    input       rst,
    input       clk,
    input       btn_up,
    input [7:0] sw,
    output      tx
);
    wire btn_up_d, btn_up_do;

    Debounce d0  (.clk(clk), .in(btn_up),   .out(btn_up_d));
    OnePulse op0 (.clk(clk), .in(btn_up_d), .out(btn_up_do));

    wire ready;

    UART u0 (
        .rst  (rst),
        .clk  (clk),
        .ready(ready),
        .send (btn_up_do),
        .data (sw),
        .tx   (tx)
    );
endmodule : UARTTest

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

