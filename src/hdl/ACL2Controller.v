module ACL2Controller(
    input wire rst,
    output reg cs,
    output reg mosi,
    input wire miso,
    input wire sclk,
    input wire action_read,
    input wire [7:0] addr,
    input wire [7:0] din,
    output reg finished,
    output reg [11:0] dout
    );

    reg [2:0] state, next_state;
    parameter HOLD = 0;
    parameter SEND_COMMAND = 1;
    parameter SEND_ADDRESS = 2;
    parameter READ_LSB = 3;
    parameter READ_MSB = 4;
    parameter SEND_VALUE = 5;
    parameter FINISH = 6;

    reg [2:0] i, next_i;
    reg [11:0] next_dout;

    always @(negedge sclk) begin
        if (rst) begin
            i <= 0;
            dout <= 0;
            state <= HOLD;
        end else begin
            i <= next_i;
            dout <= next_dout;
            state <= next_state;
        end
    end

    parameter [7:0] COMMAND_READ = 8'b00001011;
    parameter [7:0] COMMAND_WRITE = 8'b00001010;

    always @(*) begin
        next_dout = dout;
        mosi = 0;
        cs = 0;
        finished = 0;
        next_i = i + 1;
        case (state)
            HOLD: begin
                cs = 1;
                next_state = SEND_COMMAND;
                next_i = 0;
            end
            SEND_COMMAND: begin
                mosi = action_read ? COMMAND_READ[7 - i] : COMMAND_WRITE[7 - i];
                next_state = i == 7 ? SEND_ADDRESS : SEND_COMMAND;
            end
            SEND_ADDRESS: begin
                mosi = addr[7 - i];
                next_state = SEND_ADDRESS;
                if (i == 7) begin
                    next_state = action_read ? READ_LSB : SEND_VALUE;
                end
            end
            READ_LSB: begin
                next_dout[7 - i] = miso;
                next_state = i == 7 ? READ_MSB : READ_LSB;
            end
            READ_MSB: begin
                if (i >= 4) begin
                    next_dout[15 - i] = miso;
                end
                next_state = i == 7 ? FINISH : READ_MSB;
            end
            SEND_VALUE: begin
                mosi = din[7 - i];
                next_state = i == 7 ? FINISH : SEND_VALUE;
            end
            FINISH: begin
                finished = 1;
                cs = 1;
                next_state = HOLD;
                next_i = 0;
            end
            default: begin
                cs = 1;
                next_state = HOLD;
                next_i = 0;
            end
        endcase
    end

endmodule
