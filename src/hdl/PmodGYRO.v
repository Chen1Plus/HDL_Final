module PmodGYRO (
	input rst,
	input clk,

	output reg cs,
	output     sclk,
	output     mosi,
	input      miso,

	output reg [15:0] data_x,
	output reg [15:0] data_y,
	output reg [15:0] data_z
);
	// Pmod GYRO pre-defined constants ========================================
	// write (0x00) value XX to register YY, format: XX (0x00 | YY)
	localparam SETUP_LEN = 3;
	localparam SETUP_CMD = 48'h0021_1024_0F20;
	// multiple read (0xC0) from OUT_X_L (0x28)
	localparam READ_DATA_CMD = 8'hE8;
	// ========================================================================

	reg        tx_begin;
	wire       tx_end;
	reg  [7:0] tx_data;
	wire [7:0] rx_data;

	SPI s0 (
		.rst     (rst),
		.clk     (clk),
		.tx_begin(tx_begin),
		.tx_end  (tx_end),
		.tx_data (tx_data),
		.rx_data (rx_data),
		.sclk    (sclk),
		.mosi    (mosi),
		.miso    (miso)
	);

	reg [2:0] state;
	reg [2:0] state_next;

	localparam IDLE  = 3'd0;
	localparam SETUP = 3'd1;
	localparam RUN   = 3'd2;
	localparam HOLD  = 3'd3;
	localparam WAIT  = 3'd4;

	reg  [2:0] byte_cnt;
	reg  [1:0] setup_cnt;
	reg [15:0] wait_cnt;
	reg [47:0] data;

	localparam WAIT_CS  = 16'h00FF; // FF
	localparam WAIT_RUN = 16'hFFFF; // FFFF

	always @(posedge clk) begin
		if (rst) begin
			// internal state
			state     <= IDLE;
			setup_cnt <= 0;
			wait_cnt  <= 0;
			// output
			cs     <= 1'b1;
			data_x <= 0;
			data_y <= 0;
			data_z <= 0;
		end else case (state)
			IDLE: begin
				state    <= SETUP;
				byte_cnt <= 0;
			end
			SETUP: begin
				if (byte_cnt < 2) begin
					state      <= HOLD;
					state_next <= SETUP;
					byte_cnt   <= byte_cnt + 1;
					cs         <= 1'b0;
					tx_begin   <= 1'b1;
					tx_data    <= (SETUP_CMD >> (setup_cnt * 8)) >> (byte_cnt * 8);
				end else begin
					if (setup_cnt < SETUP_LEN - 1) begin
						state      <= WAIT;
						state_next <= SETUP;
						setup_cnt  <= setup_cnt + 1;
					end else begin
						state      <= WAIT;
						state_next <= RUN;
						setup_cnt  <= 0;
					end
					byte_cnt <= 0;
				end
			end
			RUN: begin
				if (byte_cnt < 7) begin
					state      <= HOLD;
					state_next <= RUN;
					byte_cnt   <= byte_cnt + 1;
					cs         <= 1'b0;
					tx_begin   <= 1'b1;
					tx_data    <= byte_cnt ? 8'h00 : READ_DATA_CMD;
				end else begin
					state      <= WAIT;
					state_next <= RUN;
					byte_cnt   <= 0;
					data_x     <= data[15:0];
					data_y     <= data[31:16];
					data_z     <= data[47:32];
				end
			end
			HOLD: begin
				tx_begin <= 1'b0;
				if (tx_end == 1'b1) begin
					state <= state_next;
					if (state_next == RUN) case (byte_cnt)
						2: data[7:0]   <= rx_data;
						3: data[15:8]  <= rx_data;
						4: data[23:16] <= rx_data;
						5: data[31:24] <= rx_data;
						6: data[39:32] <= rx_data;
						7: data[47:40] <= rx_data;
						default:; // @suppress "Empty case branch. Add a body or explanatory comment"
					endcase
				end
			end
			WAIT: begin
				tx_begin <= 1'b0;
				if (!cs && wait_cnt == WAIT_CS) begin
					wait_cnt <= 0;
					cs       <= 1'b1;
				end else if (cs && wait_cnt == WAIT_RUN) begin
					state    <= state_next;
					wait_cnt <= 0;
				end else
					wait_cnt <= wait_cnt + 1;
			end
			default: state <= IDLE;
		endcase
	end
endmodule : PmodGYRO
