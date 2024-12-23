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
