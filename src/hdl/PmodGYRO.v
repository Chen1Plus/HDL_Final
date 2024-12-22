// Referenced from Digilent's Pmod GYRO example verilog code:
//     https://digilent.com/reference/pmod/pmodgyro/start?srsltid=AfmBOor91e3Js_zrFL9VKoTqcAMjqbupqQyhrsuab8iH9Zj7xSVBp1uQ

module PmodGYRO (
	input            rst,
	input            clk,

	output  reg         tx_begin,
	input            tx_end,
	input [7:0]      rx_data,
	output   reg        cs,
	output reg [7:0]     tx_data,

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
			cs <= 1'b1;
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

			StateTYPE_idle :
			begin
				cs <= 1'b1;
				begin
					byte_count <= 0;
					axis_data <= {48{1'b0}};
					STATE <= StateTYPE_setup;
				end
			end

			StateTYPE_setup:
			if (byte_count < 2) begin
				case (byte_count)
					0: tx_data <= SETUP_GYRO[7:0];
					1: tx_data <= SETUP_GYRO[15:8];
					// 2: send_data <= SETUP_GYRO[23:16];
					// default: send_data <= SETUP_GYRO[31:24];
				endcase
				cs <= 1'b0;
				byte_count <= byte_count + 1'b1;
				tx_begin <= 1'b1;
				previousSTATE <= StateTYPE_setup;
				STATE <= StateTYPE_hold;
			end else begin
				byte_count <= 0;
				previousSTATE <= StateTYPE_setup;
				STATE <= StateTYPE_wait_ss;
			end

			StateTYPE_run :
			if (byte_count == 0)
				begin
					cs <= 1'b0;
					tx_data <= DATA_READ_BEGIN;
					byte_count <= byte_count + 1'b1;
					tx_begin <= 1'b1;
					previousSTATE <= StateTYPE_run;
					STATE <= StateTYPE_hold;
				end
			else if (byte_count <= 6)
				begin
					tx_data <= 8'h00;
					byte_count <= byte_count + 1'b1;
					tx_begin <= 1'b1;
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

			StateTYPE_hold: begin
				tx_begin <= 1'b0;
				if (tx_end == 1'b1) begin
					if (previousSTATE == StateTYPE_run & byte_count != 1) begin
						case (byte_count)
							3'd2 : axis_data[7:0] <= rx_data;
							3'd3 : axis_data[15:8] <= rx_data;
							3'd4 : axis_data[23:16] <= rx_data;
							3'd5 : axis_data[31:24] <= rx_data;
							3'd6 : axis_data[39:32] <= rx_data;
							3'd7 : axis_data[47:40] <= rx_data;
							default : ;
						endcase
					end
					STATE <= previousSTATE;
				end
			end

			StateTYPE_wait_ss :
			begin
				tx_begin <= 1'b0;
				if (ss_count == SS_COUNT_MAX)
					begin
						cs <= 1'b1;
						ss_count <= 0;
						STATE <= StateTYPE_wait_run;
					end
				else
					ss_count <= ss_count + 1'b1;
			end

			StateTYPE_wait_run :
			begin
				tx_begin <= 1'b0;
				if (count_wait == COUNT_WAIT_MAX) begin
					count_wait <= 0;
					STATE <= StateTYPE_run;
				end else
					count_wait <= count_wait + 1'b1;
			end
		endcase
	end

endmodule : PmodGYRO