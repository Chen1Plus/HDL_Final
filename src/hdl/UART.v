module UART (
    input rst,
    input clk,

    output      ready,
    input       send,
    input [7:0] data,

    output reg tx
);
    wire baud_pulse;

    PulseGen #(.OUT_FREQ(9600)) pg0 (
        .rst(1'b0),
        .clk(clk),
        .out(baud_pulse)
    );

    reg       state;
    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;

    localparam IDLE = 1'b0;
    localparam SEND = 1'b1;

    always @(posedge clk) begin
        if (rst)
            state <= IDLE;
        else case (state) // @suppress "Default clause missing from case statement"
            IDLE: begin
                if (send) begin
                    state     <= SEND;
                    bit_cnt   <= 0;
                    shift_reg <= {1'b1, data, 1'b0};
                end
                tx <= 1'b1;
            end

            SEND: begin
                if (bit_cnt >= 10)
                    state <= IDLE;
                else if (baud_pulse) begin
                    bit_cnt   <= bit_cnt + 1;
                    shift_reg <= shift_reg >> 1;
                    tx        <= shift_reg[0];
                end
            end
        endcase
    end

    assign ready = state == IDLE;
endmodule : UART
