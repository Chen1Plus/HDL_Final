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

    wire [11:0] acc_x, acc_y, acc_z;
    ACL2Controller acl2(.clk(clk), .rst(rst),
                        .cs(cs), .mosi(mosi), .miso(miso), .sclk(sclk),
                        .acc_x(acc_x), .acc_y(acc_y), .acc_z(acc_z));

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
