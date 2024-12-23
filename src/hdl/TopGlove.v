module TopGlove (
    input clk,
    input rst,
    input [1:0] sw,
    output gyro_cs,
    output gyro_sclk,
    output gyro_mosi,
    input  gyro_miso,
    output reg [15:0] LED,
    output      master_rx,
    input       master_tx,
    output      master_cts
);
    assign master_cts = 0;

    wire send_pulse;
    PulseGen #(.OUT_FREQ(100)) pgglove (
        .rst(rst),
        .clk(clk),
        .out(send_pulse)
    );

    wire [15:0] data_x, data_y, data_z;

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

    wire ready;
    reg send;
    reg [7:0] send_data;

    UART master (
        .rst  (rst),
        .clk  (clk),
        .ready(ready),
        .send (send),
        .data (send_data),
        .tx   (master_rx)
    );

    // left -> y < 0
    // top -> z < 0

    reg [1:0] state;
    localparam SEND_LR = 0;
    localparam SEND_TB = 1;
    localparam RESET_CURSOR = 2;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= RESET_CURSOR;
            send <= 0;
            send_data <= 0;
        end else begin
            case (state)
                RESET_CURSOR: begin
                    send_data <= 8'h63; // c
                    if (send_pulse) begin
                        send <= 1;
                        state <= SEND_LR;
                    end else begin
                        send <= 0;
                        state <= RESET_CURSOR;
                    end
                end
                SEND_LR: begin
                    if ($signed(data_y[15:11]) < $signed(-1)) begin
                        send_data <= 2; // l
                    end else if ($signed(data_y[15:11]) > $signed(1)) begin
                        send_data <= 3; // r
                    end else begin
                        send_data <= 8'hff; // \n
                    end
                    if (send_pulse) begin
                        send <= 1;
                        state <= SEND_TB;
                    end else begin
                        send <= 0;
                        state <= SEND_LR;
                    end
                end
                SEND_TB: begin
                    if ($signed(data_z[15:11]) < $signed(-1)) begin
                        send_data <= 0; // t
                    end else if ($signed(data_z[15:11]) > $signed(1)) begin
                        send_data <= 1; // b
                    end else begin
                        send_data <= 8'hff; // \n
                    end
                    if (send_pulse) begin
                        send <= 1;
                        state <= SEND_LR;
                    end else begin
                        send <= 0;
                        state <= SEND_TB;
                    end
                end
                default: begin
                    state <= RESET_CURSOR;
                end
            endcase
        end
    end

    always @* case (sw)
        2'b00:   LED <= data_x;
        2'b01:   LED <= data_y;
        default: LED <= data_z;
    endcase
    
endmodule : TopGlove