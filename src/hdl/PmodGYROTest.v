module PmodGYROTest (
    input rst,
    input clk,

    input [1:0] sw,

    output gyro_cs,
    output gyro_sclk,
    output gyro_mosi,
    input  gyro_miso,

    output reg [15:0] led
);

    wire        begin_transmission;
    wire        end_transmission;
    wire  [7:0] send_data;
    wire  [7:0] recieved_data;
    wire [15:0] x_axis_data;
    wire [15:0] y_axis_data;
    wire [15:0] z_axis_data;

    PmodGYRO C0(
        .tx_begin(begin_transmission),
        .tx_end(end_transmission),
        .tx_data(send_data),
        .rx_data(recieved_data),
        .clk(clk),
        .rst(rst),
        .cs(gyro_cs),
        .data_x(x_axis_data),
        .data_y(y_axis_data),
        .data_z(z_axis_data)
    );

    SPI C1(
        .tx_begin(begin_transmission),
        .tx_data(send_data),
        .rx_data(recieved_data),
        .miso(gyro_miso),
        .clk(clk),
        .rst(rst),
        .tx_end(end_transmission),
        .mosi(gyro_mosi),
        .sclk(gyro_sclk)
    );

    always @* case (sw)
        2'b00:   led <= x_axis_data;
        2'b01:   led <= y_axis_data;
        default: led <= z_axis_data;
    endcase
endmodule : PmodGYROTest

module ClkDivider (
    input  clk,
    output clk_div
);
    reg [26:0] cnt;

    always @(posedge clk) begin
        cnt = cnt + 1;
    end
    assign clk_div = cnt[26];
endmodule : ClkDivider

