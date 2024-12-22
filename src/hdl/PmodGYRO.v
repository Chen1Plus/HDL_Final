// Referenced from Digilent's Pmod GYRO example verilog code:
//     https://digilent.com/reference/pmod/pmodgyro/start?srsltid=AfmBOor91e3Js_zrFL9VKoTqcAMjqbupqQyhrsuab8iH9Zj7xSVBp1uQ

module PmodGYRO (
	input            rst,
	input            clk,

	output  reg         begin_transmission,
	input            end_transmission,
	input [7:0]      recieved_data,
	output   reg        slave_select,
	output reg [7:0]     send_data,

	output reg [15:0]    x_axis_data,
	output reg [15:0]    y_axis_data,
	output reg [15:0]    z_axis_data
);

	parameter [2:0] StateTYPE_idle = 0,
	StateTYPE_setup = 1,
	StateTYPE_run = 3,
	StateTYPE_hold = 4,
	StateTYPE_wait_ss = 5,
	StateTYPE_wait_run = 6;
	reg [2:0]        STATE;
	reg [2:0]        previousSTATE;

	// setup control register 1 to enable x, y, and z. CTRL_REG1 (0x20)
	// with read and multiple bytes not selected
	// output data rate of 100 Hz
	// will output 8.75 mdps/digit at 250 dps maximum
	parameter [16:0] SETUP_GYRO = 16'h0F20;
	// address of X_AXIS (0x28) with read and multiple bytes selected (0xC0)
	parameter [7:0]  DATA_READ_BEGIN = 8'hE8;

	reg [2:0]        byte_count;

	parameter [11:0] SS_COUNT_MAX = 12'h0FF; // FFF
	reg [11:0]       ss_count;

	parameter [23:0] COUNT_WAIT_MAX = 24'h00FFFF; //X"000FFF"; // 7FFFFF
	reg [23:0]       count_wait;
	reg [47:0]       axis_data;


	always @(posedge clk) begin: spi_interface

		if (rst == 1'b1) begin
			slave_select <= 1'b1;
			byte_count <= 0;
			count_wait <= {24{1'b0}};
			axis_data <= {48{1'b0}};
			x_axis_data <= {16{1'b0}};
			y_axis_data <= {16{1'b0}};
			z_axis_data <= {16{1'b0}};
			ss_count <= {12{1'b0}};
			STATE <= StateTYPE_idle;
			previousSTATE <= StateTYPE_idle;
		end
		else case (STATE)

			// idle
			StateTYPE_idle :
			begin
				slave_select <= 1'b1;
				begin
					byte_count <= 0;
					axis_data <= {48{1'b0}};
					STATE <= StateTYPE_setup;
				end
			end

			// setup
			StateTYPE_setup:
			if (byte_count < 2) begin
				case (byte_count)
					0: send_data <= SETUP_GYRO[7:0];
					1: send_data <= SETUP_GYRO[15:8];
					// 2: send_data <= SETUP_GYRO[23:16];
					// default: send_data <= SETUP_GYRO[31:24];
				endcase
				slave_select <= 1'b0;
				byte_count <= byte_count + 1'b1;
				begin_transmission <= 1'b1;
				previousSTATE <= StateTYPE_setup;
				STATE <= StateTYPE_hold;
			end else begin
				byte_count <= 0;
				previousSTATE <= StateTYPE_setup;
				STATE <= StateTYPE_wait_ss;
			end

			// run
			StateTYPE_run :
			if (byte_count == 0)
				begin
					slave_select <= 1'b0;
					send_data <= DATA_READ_BEGIN;
					byte_count <= byte_count + 1'b1;
					begin_transmission <= 1'b1;
					previousSTATE <= StateTYPE_run;
					STATE <= StateTYPE_hold;
				end
			else if (byte_count <= 6)
				begin
					send_data <= 8'h00;
					byte_count <= byte_count + 1'b1;
					begin_transmission <= 1'b1;
					previousSTATE <= StateTYPE_run;
					STATE <= StateTYPE_hold;
				end
			else
				begin
					byte_count <= 0;
					x_axis_data <= axis_data[15:0];
					y_axis_data <= axis_data[31:16];
					z_axis_data <= axis_data[47:32];
					previousSTATE <= StateTYPE_run;
					STATE <= StateTYPE_wait_ss;
				end

				// hold
			StateTYPE_hold: begin
				begin_transmission <= 1'b0;
				if (end_transmission == 1'b1) begin
					if (previousSTATE == StateTYPE_run & byte_count != 1) begin
						case (byte_count)
							3'd2 : axis_data[7:0] <= recieved_data;
							3'd3 : axis_data[15:8] <= recieved_data;
							3'd4 : axis_data[23:16] <= recieved_data;
							3'd5 : axis_data[31:24] <= recieved_data;
							3'd6 : axis_data[39:32] <= recieved_data;
							3'd7 : axis_data[47:40] <= recieved_data;
							default : ;
						endcase
					end
					STATE <= previousSTATE;
				end
			end

			// wait_ss
			StateTYPE_wait_ss :
			begin
				begin_transmission <= 1'b0;
				if (ss_count == SS_COUNT_MAX)
					begin
						slave_select <= 1'b1;
						ss_count <= {12{1'b0}};
						STATE <= StateTYPE_wait_run;
					end
				else
					ss_count <= ss_count + 1'b1;
			end

			// wait_run
			StateTYPE_wait_run :
			begin
				begin_transmission <= 1'b0;
				if (count_wait == COUNT_WAIT_MAX)
					begin
						count_wait <= 0;
						STATE <= StateTYPE_run;
					end
				else
					count_wait <= count_wait + 1'b1;
			end
		endcase
	end

endmodule : PmodGYRO

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
	wire       sclk_next;
	reg [16:0] sclk_cnt;

	always @(posedge clk) begin : SCLK_GEN
		sclk <= sclk_next;
		if (rst) begin
			sclk <= 1'b1;
			sclk_cnt <= {{15{1'b1}}, 2'b00};
		end
		else if (state == RXTX)
			sclk_cnt <= sclk_cnt + 1;
		else
			sclk_cnt <= {{15{1'b1}}, 2'b00};
	end
	assign sclk_next = sclk_cnt[16];

	reg       state;
	reg [3:0] bit_cnt;
	reg [7:0] shift_reg;

	localparam IDLE = 1'b0;
	localparam RXTX = 1'b1;

	always @(posedge clk) begin : TX_PROC
		if (rst == 1'b1)
			state <= IDLE;
		else case (state)
			IDLE: begin
				tx_end <= 1'b0;
				if (tx_begin == 1'b1) begin
					state     <= RXTX;
					bit_cnt   <= 0;
					shift_reg <= tx_data;
				end
			end
			RXTX: begin
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