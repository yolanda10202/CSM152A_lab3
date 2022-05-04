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
module stopwatch(clk, btnS, btnR, sel, adj, an, seg);
	// btnS = pause
	// btnR = reset

	// input clk is a 100MHz clock
	input clk;
	input btnS, btnR, sel, adj;
	output reg [3:0] an;
	output reg [7:0] seg;
	
	reg [3:0] seg_num;
	reg [3:0] seg3, seg2, seg1, seg0;
	
	wire one_hz_clk;
	wire two_hz_clk;
	wire segment_clk;
	wire blink_clk;
	
	reg [1:0] state;
	reg [31:0] start_sec = 0;
	reg [31:0] sec;
	reg [1:0] digit_dis = 0;
	
	wire [31:0] end_sec;
	
	// instantiate the other three clocks with clock divider
	clk_div #(.count_from(0), .count_to(10000000)) my_one_hz_clk(.in(clk), .out(one_hz_clk));
	//clk_div #(.count_from(0), .count_to(50000000)) my_two_hz_clk(.in(clk), .out(two_hz_clk));
	clk_div #(.count_from(0), .count_to(1000000)) my_segment_clk(.in(clk), .out(segment_clk));
	//clk_div #(.count_from(0), .count_to(80000000)) my_blink_clk(.in(clk), .out(blink_clk));
	
	// take care of debouncing/metastability
	
	// determine state based on FPGA inputs
	
	// instantiate fsm, pass in corresponding clock and state
	fsm my_fsm(.state(state), .clk_in(one_hz_clk), .start_sec(start_sec), .end_sec(end_sec));
	

	// Display digits on the FPGA's seven-segment display
	always @(posedge segment_clk) begin
		digit_dis = digit_dis + 1;
	end
	
	always @(posedge one_hz_clk) begin
		start_sec = start_sec + 1;
	end
	
	always @(posedge clk) begin
		an = 4'b1111;
		an[digit_dis] = 0;
		
		// set the displays
		seg0 = (end_sec%60)%10;
		seg1 = (end_sec%60)/10;
		seg2 = (end_sec/60)%10;
		seg3 = (end_sec/600)%10;
		
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
