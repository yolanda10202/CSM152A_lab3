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
	reg [1:0] setAdj;
	reg pause = 0;
	reg reset = 0;
	reg sel = 0;
	reg adj = 0;
	
	wire one_hz_clk;
	wire two_hz_clk;
	wire segment_clk;
	wire blink_clk;
	reg choose_display_clk;
	reg choose_state_clk;
	
	reg [1:0] state;
	reg [31:0] start_sec = -1;
	reg [31:0] sec;
	reg [1:0] digit_dis = 0;
	
	wire [31:0] end_sec;
	
	// instantiate the other three clocks with clock divider
	clk_div #(.count_from(0), .count_to(100000000)) my_one_hz_clk(.in(clk), .out(one_hz_clk));
	clk_div #(.count_from(0), .count_to(50000000)) my_two_hz_clk(.in(clk), .out(two_hz_clk));
	clk_div #(.count_from(0), .count_to(1000)) my_segment_clk(.in(clk), .out(segment_clk));
	clk_div #(.count_from(0), .count_to(10000000)) my_blink_clk(.in(clk), .out(blink_clk));
	
	
	assign choose_state_clk = adj ? two_hz_clk : one_hz_clk;
	assign choose_display_clk = adj ? blink_clk : segment_clk;
	/*
	// choose the display clock based on the state
		if (adj == 1) begin
			choose_display_clk = blink_clk;
			choose_state_clk = two_hz_clk;
		end 
		else begin
			choose_display_clk = segment_clk;
			choose_state_clk = one_hz_clk;
		end
	*/
	
	
	// instantiate fsm, pass in corresponding clock and state
	//fsm my_fsm(.state(state), .clk_in(choose_state_clk), .start_sec(start_sec), .end_sec(end_sec));
	

	// Display digits on the FPGA's seven-segment display
	// take care of debouncing/metastability
	always @(posedge segment_clk) begin
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
		
		// selection
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
		
		
		
		digit_dis = digit_dis + 1;
	end
	
	always @(posedge choose_state_clk) begin
		if (adj == 0) begin
			if (reset == 1) begin
				start_sec = -1;
			end
			else if (pause == 0) begin
				start_sec = start_sec + 1;
			end
		end
		else begin // adj == 1
			// set second
			if (sel == 1) begin
				// if second is overflowing
				if(start_sec % 59) begin
					start_sec = start_sec - 59;
				end
				// else increment second
				start_sec = start_sec + 1;
			end
			
			// set minute
			else begin
				// if minute is overflowing
				if (start_sec/60 == 99) begin
					start_sec = start_sec % 60;
				end
				// else increment minute
				start_sec = start_sec + 60;
			end
		end
	end
	
	always @(posedge choose_display_clock) begin
		an = 4'b1111;
		an[digit_dis] = 0;
		
		// set the displays
		seg0 = (start_sec%60)%10;
		seg1 = (start_sec%60)/10;
		seg2 = (start_sec/60)%10;
		seg3 = (start_sec/600)%10;
		
		case (digit_dis)
			0: seg_num = seg0;
			1: seg_num = seg1;
			2: seg_num = seg2;
			3: seg_num = seg3;
		endcase
		
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
	
endmodule 
/*
		// reset
		if (btnR == 1) begin
			start_sec = 0;
			state = 2'b00;
		end
		// pause state
		if (btnS == 1) begin
			state = 2'b01;
		end 
		// increment state
		else begin
			state = 2'b00;
		end
	*/
	
/*
always @(posedge clk) begin
			an = 4'b1111;
		end
		
		// set the displays
		seg0 = (200%60)%10;
		seg1 = (200%60)/10;
		seg2 = (200/60)%10;
		seg3 = (200/600)%10;
		
		
		// seg0
		if(an[0]) 
		begin
			case (seg0)
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
			an = 4'b0010;
		end
		
		// seg1
		if(an[1]) 
		begin
			case (seg1)
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
			an = 4'b0100;
		end
		
		// seg2
		if(an[2]) 
		begin
			case (seg2)
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
			an = 4'b1000;
		end
		
		// seg3
		if(an[3]) 
		begin
			case (seg3)
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
			an = 4'b0001;
		end
*/
