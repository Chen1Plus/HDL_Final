module TopReceiver(
    input       rst,
    input       clk,
    input       computer_rx,
    output      computer_tx,
    output      bt2_rx,
    input       bt2_tx,
    output      cts
);
    assign cts = 0;
    assign bt2_rx = computer_rx;
    assign computer_tx = bt2_tx;
endmodule : TopReceiver
