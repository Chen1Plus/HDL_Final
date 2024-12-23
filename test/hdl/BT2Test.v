// module BT2Test(
//     input       rst,
//     input       clk,
//     input [7:0] sw,
//     output reg [7:0] LED,
//     output      master_rts,
//     input       master_rx,
//     output      master_tx,
//     input       master_cts,
//     output      slave_rts,
//     input       slave_rx,
//     output      slave_tx,
//     input       slave_cts
// );
//     wire master_ready, master_end_transmission;

//     BT2Master master(
//         .clk(clk),
//         .rst(rst),
//         .send(1),
//         .ready(master_ready),
//         .send_data(sw),
//         .end_transmission(master_end_transmission),
//         .rts(master_rts),
//         .rx(master_rx),
//         .tx(master_tx),
//         .cts(master_cts)
//     );

//     wire slave_ready, slave_end_transmission;
//     wire [7:0] receive_data;
//     BT2Slave slave(
//         .clk(clk),
//         .rst(rst),
//         .ready(slave_ready),
//         .receive_data(receive_data),
//         .end_transmission(slave_end_transmission),
//         .rts(slave_rts),
//         .rx(slave_rx),
//         .tx(slave_tx),
//         .cts(slave_cts)
//     );

//     always @(posedge clk, posedge rst) begin
//         if (rst)
//             LED <= 0;
//         else if (slave_ready && slave_end_transmission)
//             LED <= receive_data;
//     end

//     wire baud_pulse;

//     PulseGen #(.OUT_FREQ(9600)) pgtest (
//         .rst(rst),
//         .clk(clk),
//         .out(baud_pulse)
//     );

//     ila_0 ILA(
//         .clk(clk),
//         .probe0(master_rx),
//         .probe1(master_tx),
//         .probe2(slave_rx),
//         .probe3(slave_tx),
//         .probe4(master_ready),
//         .probe5(slave_ready),
//         .probe6(receive_data),
//         .probe7(baud_pulse)
//     );

// endmodule : BT2Test

module BT2Test(
    input       rst,
    input       clk,
    input [7:0] sw,
    input       connect_master,
    input       connect_slave,
    input       computer_rx,
    output reg  computer_tx,
    output reg  master_rx,
    input       master_tx,
    output      master_cts,
    output reg  slave_rx,
    input       slave_tx,
    output      slave_cts
);
    assign master_cts = 0;
    assign slave_cts = 0;

    wire baud_pulse;

    PulseGen #(.OUT_FREQ(115200)) pgtest (
        .rst(rst),
        .clk(clk),
        .out(baud_pulse)
    );
    
    wire uart_output;
    UART master(
        .clk(clk),
        .rst(rst),
        .ready(ready),
        .send(1),
        .data(sw),
        .tx(uart_output)
    );

    ila_0 ILA(
        .clk(clk),
        .probe0(master_rx),
        .probe1(slave_tx),
        .probe2(baud_pulse)
    );

    always @(*) begin
        if (connect_master) begin
            master_rx = computer_rx;
            computer_tx = master_tx;
            slave_rx = 1;
        end else begin
            master_rx = uart_output;
            if (connect_slave) begin
                slave_rx = computer_rx;
                computer_tx = slave_tx;
            end else begin
                slave_rx = 1;
                computer_tx = 1;
            end
        end
    end

endmodule : BT2Test
