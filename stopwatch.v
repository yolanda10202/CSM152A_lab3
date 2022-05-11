`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:20:18 04/27/2022 
// Design Name: 
// Module Name:    stopwatch 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module stopwatch(clk, btnS, btnR, sw, an, seg);
	// btnS = pause
	// btnR = reset
	// sw0 = adj
	// sw1 = sel
	// input clk is a 100MHz clock
	
	input clk;
	input btnS, btnR;
	input [7:0] sw;
	output reg [3:0] an;
	output reg [7:0] seg;
	
	reg [3:0] seg_num;
	reg [3:0] seg3, seg2, seg1, seg0;
	reg [1:0] setReset;
	reg [1:0] setPause;
	reg [1:0] setSel;
	reg [1:0] setAdj = 2'b00;
	reg pause = 0;
	reg reset = 0;
	reg sel = 0;
	reg adj = 0;
	reg digits_on = 0;
	
	wire one_hz_clk;
	wire two_hz_clk;
	wire segment_clk;
	wire blink_clk;
	wire choose_display_clk;
	wire choose_state_clk;
	
	reg [1:0] state;
	reg [31:0] start_sec = 0;
	reg [31:0] sec;
	reg [1:0] digit_dis = 0;
		
	// instantiate four clocks with clock divider
	clk_div #(.count_from(0), .count_to(100000000)) my_one_hz_clk(.in(clk), .out(one_hz_clk));
	clk_div #(.count_from(0), .count_to(50000000)) my_two_hz_clk(.in(clk), .out(two_hz_clk));
	clk_div #(.count_from(0), .count_to(1000)) my_segment_clk(.in(clk), .out(segment_clk));
	clk_div #(.count_from(0), .count_to(25000000)) my_blink_clk(.in(clk), .out(blink_clk));
	
	
	assign choose_state_clk = adj ? two_hz_clk : one_hz_clk;
	
	
	always @(posedge segment_clk) begin
		// take care of debouncing/metastability
		// reset
		setReset = setReset >> 1;
		if (btnR == 1) begin
			setReset[1] = 1;
		end
		if (setReset == 3) begin
			reset = 1;
		end
		else begin
			reset = 0;
		end
		
		// pause
		setPause = setPause >> 1;
		if (btnS == 1) begin
			setPause[1] = 1;
		end
		if (setPause == 3) begin
			pause = !pause;
		end
		
		// select
		setSel = setSel >> 1;
		if (sw[1] == 1) begin
			setSel[1] = 1;
		end
		if (setSel == 3) begin
			sel = 1;
		end
		else begin
			sel = 0;
		end
		
		// adjust
		setAdj = setAdj >> 1;
		if (sw[0] == 1) begin
			setAdj[1] = 1;
		end
		if (setAdj == 3) begin
			adj = 1;
		end
		else begin
			adj = 0;
		end
		
		// display the next digit
		digit_dis = digit_dis + 1;
		
		// Display digits on the FPGA's seven-segment display
		// digits_on takes care of blinking in adjust mode
		
		an = 4'b1111;	
		// set the digit we want to display to 0
		an[digit_dis] = 0;
	
		// set the number of each digit
		seg0 = (start_sec%60)%10;
		seg1 = (start_sec%60)/10;
		seg2 = (start_sec/60)%10;
		seg3 = (start_sec/600)%10;
		
		if (digits_on) begin
			case (digit_dis)
				0: seg_num = seg0;
				1: seg_num = seg1;
				2: seg_num = seg2;
				3: seg_num = seg3;
			endcase
		end
		else if (sel == 0) begin
			// 10 will take us to the default mode
			case (digit_dis)
				0: seg_num = seg0;
				1: seg_num = seg1;
				2: seg_num = 10;
				3: seg_num = 10;
			endcase
		end
		else begin
			case (digit_dis)
				0: seg_num = 10;
				1: seg_num = 10;
				2: seg_num = seg2;
				3: seg_num = seg3;
			endcase
		end
		
		case (seg_num)
			0: seg = 8'b11000000;
			1: seg = 8'b11111001;
			2: seg = 8'b10100100;
			3: seg = 8'b10110000;
			4: seg = 8'b10011001;
			5: seg = 8'b10010010;
			6: seg = 8'b10000010;
			7: seg = 8'b11111000;
			8: seg = 8'b10000000;
			9: seg = 8'b10010000;
			default: seg = 8'b11111111;
		endcase
	end
	
	always @(posedge choose_state_clk) begin
		
		if (reset) begin
			start_sec = 0;
		end
		else if (!pause && !adj) begin
			start_sec = start_sec + 1;
		end 
		
		// if in adjust mode
		if (adj) begin 
			// set second
			if (sel) begin
				// if second is overflowing
				if(start_sec % 60 == 59) begin
					start_sec = start_sec - 59;
				end
				// else increment second
				else if (!pause && !reset) begin
					start_sec = start_sec + 1;
				end
			end
			
			// set minute
			else begin
				// if minute is overflowing
				if (start_sec/60 == 99) begin
					start_sec = start_sec % 60;
				end
				// else increment minute
				else if (!pause && !reset) begin
					start_sec = start_sec + 60;
				end
			end
		end
	end
	
	always @(posedge blink_clk) begin
		// if in adjust mode, toggle the display of digits
		if (adj) begin
			digits_on = !digits_on;
		end
		// else always display
		else begin
			digits_on = 1;
		end
	end
	
endmodule 
