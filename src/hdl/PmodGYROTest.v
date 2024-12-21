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
        .begin_transmission(begin_transmission),
        .end_transmission(end_transmission),
        .send_data(send_data),
        .recieved_data(recieved_data),
        .clk(clk),
        .rst(rst),
        .slave_select(gyro_cs),
        .x_axis_data(x_axis_data),
        .y_axis_data(y_axis_data),
        .z_axis_data(z_axis_data)
    );

    PmodGYRO_SPI_IF C1(
        .begin_transmission(begin_transmission),
        .slave_select(gyro_cs),
        .send_data(send_data),
        .recieved_data(recieved_data),
        .miso(gyro_miso),
        .clk(clk),
        .rst(rst),
        .end_transmission(end_transmission),
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

