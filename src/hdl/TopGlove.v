module TopGlove (
    input clk,
    input rst,
    input [1:0] sw,
    input btn_up,
    input btn_down,
    input btn_left,
    input btn_center,

    output gyro_cs,
    output gyro_sclk,
    output gyro_mosi,
    input  gyro_miso,

    output reg [15:0] LED,

    input       master_rts,
    output      master_rx,
    input       master_tx,
    output      master_cts
);
    wire btn_up_db, btn_down_db, btn_left_db, btn_center_db;
    Debounce db_up(.clk(clk), .in(btn_up), .out(btn_up_db));
    Debounce db_down(.clk(clk), .in(btn_down), .out(btn_down_db));
    Debounce db_left(.clk(clk), .in(btn_left), .out(btn_left_db));
    Debounce db_center(.clk(clk), .in(btn_center), .out(btn_center_db));
    wire btn_up_pulse, btn_down_pulse, btn_left_pulse, btn_center_pulse;
    OnePulse op_up(.clk(clk), .in(btn_up_db), .out(btn_up_pulse));
    OnePulse op_down(.clk(clk), .in(btn_down_db), .out(btn_down_pulse));
    OnePulse op_left(.clk(clk), .in(btn_left_db), .out(btn_left_pulse));
    OnePulse op_center(.clk(clk), .in(btn_center_db), .out(btn_center_pulse));

    assign master_cts = 0;

    wire send_pulse;
    PulseGen #(.OUT_FREQ(100)) pgglove (
        .rst(rst),
        .clk(clk),
        .out(send_pulse)
    );

    wire [15:0] data_x, data_y, data_z;
    wire update;

    PmodGYRO pgyro0 (
        .rst   (rst),
        .clk   (clk),
        .cs    (gyro_cs),
        .sclk  (gyro_sclk),
        .mosi  (gyro_mosi),
        .miso  (gyro_miso),
        .data_x(data_x),
        .data_y(data_y),
        .data_z(data_z),
        .update(update)
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

    reg [3:0][7:0] buffer;
    reg [1:0] head, tail;

    reg [2:0] state;
    localparam SEND_LR = 0;
    localparam SEND_TB = 1;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= SEND_LR;
            send <= 0;
            send_data <= 0;
            head <= 0;
            tail <= 0;
        end else begin
            if (ready && master_rts == 0 && head != tail) begin
                send <= 1;
                send_data <= buffer[head];
                head <= head + 1;
            end else begin
                send <= 0;
            end

            if (tail + 1 != head) begin
                if (btn_left_pulse) begin
                    buffer[tail] <= 4;
                    tail <= tail + 1;
                end else if (btn_center_pulse) begin
                    buffer[tail] <= 8;
                    tail <= tail + 1;
                end else if (btn_up_pulse) begin
                    buffer[tail] <= 6;
                    tail <= tail + 1;
                end else if (btn_down_pulse) begin
                    buffer[tail] <= 7;
                    tail <= tail + 1;
                end else case (state)
                    SEND_LR: begin
                        if (update) begin
                            if ($signed(data_y[15:11]) < $signed(-1)) begin
                                buffer[tail] <= 2; // l
                                tail <= tail + 1;
                            end else if ($signed(data_y[15:11]) > $signed(1)) begin
                                buffer[tail] <= 3; // r
                                tail <= tail + 1;
                            end
                            state <= SEND_TB;
                        end
                    end
                    SEND_TB: begin
                        if (update) begin
                            if ($signed(data_z[15:11]) < $signed(-1)) begin
                                buffer[tail] <= 0; // t
                                tail <= tail + 1;
                            end else if ($signed(data_z[15:11]) > $signed(1)) begin
                                buffer[tail] <= 1; // b
                                tail <= tail + 1;
                            end
                            state <= SEND_LR;
                        end
                    end
                    default: begin
                        state <= SEND_LR;
                    end
                endcase
            end else begin
                state <= SEND_LR;
            end
        end
    end

    // always @* case (sw)
    //     2'b00:   LED <= data_x;
    //     2'b01:   LED <= data_y;
    //     default: LED <= data_z;
    // endcase

    // ila_0 ILA(
    //     .clk(clk),
    //     .probe0(head),
    //     .probe1(tail),
    //     .probe2(ready),
    //     .probe3(update)
    // );

endmodule : TopGlove