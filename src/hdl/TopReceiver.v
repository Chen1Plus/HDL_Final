module TopReceiver (
    output pc_tx,
    input  pc_rx,
    output bt2_cts,
    input  bt2_tx,
    output bt2_rx
);
    assign pc_tx   = bt2_tx;
    assign bt2_cts = 1'b0;
    assign bt2_rx  = pc_rx;
endmodule : TopReceiver
