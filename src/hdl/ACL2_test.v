module ACL2_test(
        input wire clk,
        input wire rst,
        input wire [2:0] sw,
        output wire cs,
        output wire mosi,
        input wire miso,
        output wire sclk,
        output wire int1,
        output wire int2,
        output reg [11:0] LED
    );

    assign int1 = 0;
    assign int2 = 0;

    clock_divider #(.n(4)) c4(.clk(clk), .clk_div(sclk));

    reg action_read;
    reg [7:0] addr, din;
    wire [11:0] dout;
    wire finished;
    ACL2Controller acl2(.rst(rst),
                        .cs(cs), .mosi(mosi), .miso(miso), .sclk(sclk),
                        .action_read(action_read), .addr(addr), .din(din),
                        .finished(finished), .dout(dout));

    reg [2:0] state, next_state;
    reg [11:0] acc_x, acc_y, acc_z, next_acc_x, next_acc_y, next_acc_z;
    parameter INIT = 0;
    parameter SET_RANGE = 1;
    parameter GET_ACC_X = 2;
    parameter GET_ACC_Y = 3;
    parameter GET_ACC_Z = 4;
                
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

    wire clk_25;
    clock_divider #(.n(25)) c25(.clk(clk), .clk_div(clk_25));

    always @(posedge clk_25, posedge rst) begin
        if (rst)
            LED <= 12'hfff;
        else begin
            if (sw[0]) begin
                LED <= acc_x;
            end else if (sw[1]) begin
                LED <= acc_y;
            end else if (sw[2]) begin
                LED <= acc_z;
            end else begin
                LED <= 12'hfff;
            end
        end
    end

    // ila_0 ILA(
    //     .clk(clk),
    //     .probe0(sclk),
    //     .probe1(cs),
    //     .probe2(mosi),
    //     .probe3(miso),
    //     .probe4(state),
    //     .probe5(addr),
    //     .probe6(dout[11:4])
    // );
endmodule
