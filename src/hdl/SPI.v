module SPI (
	input rst,
	input clk,

	input            tx_begin,
	output reg       tx_end,
	input      [7:0] tx_data,
	output reg [7:0] rx_data,

	output reg sclk,
	output reg mosi,
	input      miso
);
	reg state;

	localparam IDLE = 1'b0;
	localparam TXRX = 1'b1;

	wire      sclk_next;
	reg [3:0] sclk_cnt;

	always @(posedge clk) begin : SCLK_GEN
		sclk <= sclk_next;
		if (rst) begin
			sclk <= 1'b1;
			sclk_cnt <= 4'hC;
		end else case (state)
			TXRX:    sclk_cnt <= sclk_cnt + 1;
			default: sclk_cnt <= 4'hC;
		endcase
	end
	assign sclk_next = sclk_cnt[3];

	reg [3:0] bit_cnt;
	reg [7:0] shift_reg;

	always @(posedge clk) begin : TX_PROC
		if (rst == 1'b1) begin
			state   <= IDLE;
			tx_end  <= 1'b0;
			rx_data <= 8'h00;
		end else case (state) // @suppress "Default clause missing from case statement"
			IDLE: begin
				tx_end <= 1'b0;
				if (tx_begin == 1'b1) begin
					state     <= TXRX;
					bit_cnt   <= 0;
					shift_reg <= tx_data;
				end
			end
			TXRX: begin
				if (bit_cnt >= 8) begin
					state   <= IDLE;
					tx_end  <= 1'b1;
					rx_data <= shift_reg;
				end else if (sclk && !sclk_next) begin
					mosi <= shift_reg[7];
				end else if (!sclk && sclk_next) begin
					bit_cnt   <= bit_cnt + 1;
					shift_reg <= {shift_reg[6:0], miso};
				end
			end
		endcase
	end
endmodule : SPI