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
    wire [15:0] data_x;
    wire [15:0] data_y;
    wire [15:0] data_z;

    PmodGYRO pgyro0 (
        .rst   (rst),
        .clk   (clk),
        .cs    (gyro_cs),
        .sclk  (gyro_sclk),
        .mosi  (gyro_mosi),
        .miso  (gyro_miso),
        .data_x(data_x),
        .data_y(data_y),
        .data_z(data_z)
    );

    always @* case (sw)
        2'b00:   led <= data_x;
        2'b01:   led <= data_y;
        default: led <= data_z;
    endcase
endmodule : PmodGYROTest
