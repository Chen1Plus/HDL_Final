module ACL2Controller(
        input wire clk,
        input wire rst,

        output wire cs,
        output wire mosi,
        input wire miso,
        input wire sclk,

        output reg [11:0] acc_x,
        output reg [11:0] acc_y,
        output reg [11:0] acc_z
    );

    reg action_read;
    reg [7:0] addr, din;
    wire [11:0] dout;
    wire finished;
    ACL2SpiController acl2(.rst(rst),
                        .cs(cs), .mosi(mosi), .miso(miso), .sclk(sclk),
                        .action_read(action_read), .addr(addr), .din(din),
                        .finished(finished), .dout(dout));

    reg [2:0] state, next_state;
    reg [11:0] next_acc_x, next_acc_y, next_acc_z;
    localparam INIT = 0;
    localparam SET_RANGE = 1;
    localparam GET_ACC_X = 2;
    localparam GET_ACC_Y = 3;
    localparam GET_ACC_Z = 4;
                
    always @(posedge sclk, posedge rst) begin
        if (rst) begin
            state <= INIT;
            acc_x <= 0;
            acc_y <= 0;
            acc_z <= 0;
        end else begin
            state <= next_state;
            acc_x <= next_acc_x;
            acc_y <= next_acc_y;
            acc_z <= next_acc_z;
        end
    end

    always @(*) begin
        din = 0;
        next_acc_x = acc_x;
        next_acc_y = acc_y;
        next_acc_z = acc_z;
        next_state = state;
        case (state)
            INIT: begin
                action_read = 0;
                addr = 8'h2d;
                din = 8'h02;
                if (finished) begin
                    next_state = SET_RANGE;
                end
            end
            SET_RANGE: begin
                action_read = 0;
                addr = 8'h2c;
                din = 8'b00010011;
                if (finished) begin
                    next_state = GET_ACC_X;
                end
            end
            GET_ACC_X: begin
                action_read = 1;
                addr = 8'h0e;
                if (finished) begin
                    next_acc_x = dout;
                    next_state = GET_ACC_Y;
                end
            end
            GET_ACC_Y: begin
                action_read = 1;
                addr = 8'h10;
                if (finished) begin
                    next_acc_y = dout;
                    next_state = GET_ACC_Z;
                end
            end
            GET_ACC_Z: begin
                action_read = 1;
                addr = 8'h12;
                if (finished) begin
                    next_acc_z = dout;
                    next_state = GET_ACC_X;
                end
            end
            default: begin
                addr = 8'h0;
                action_read = 0;
                next_state = INIT;
            end
        endcase
    end
endmodule


module ACL2SpiController(
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
    localparam HOLD = 0;
    localparam SEND_COMMAND = 1;
    localparam SEND_ADDRESS = 2;
    localparam READ_LSB = 3;
    localparam READ_MSB = 4;
    localparam SEND_VALUE = 5;
    localparam FINISH = 6;

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

    localparam [7:0] COMMAND_READ = 8'b00001011;
    localparam [7:0] COMMAND_WRITE = 8'b00001010;

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
