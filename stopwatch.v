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
module stopwatch(clk, btnS, btnR, sel, adj, AN3, AN2, AN1, AN0);
	// btnS = pause
	// btnR = reset

	// input clk is a 100MHz clock
	input clk;
	input btnS, btnR, sel, adj;
	output reg [7:0] AN3, AN2, AN1, AN0;
	
	wire [3:0] seg3, seg2, seg1, seg0;
	
	wire one_hz_clk;
	wire two_hz_clk;
	wire segment_clk;
	wire blink_clk;
	
	reg [1:0] state;
	reg [31:0] start_sec = 0;
	reg [31:0] sec;
	
	// instantiate the other three clocks with clock divider
	clk_div #(.count_from(0), .count_to(100000000)) my_one_hz_clk(.in(clk), .out(one_hz_clk));
	clk_div #(.count_from(0), .count_to(50000000)) my_two_hz_clk(.in(clk), .out(two_hz_clk));
	clk_div #(.count_from(0), .count_to(1000000)) my_segment_clk(.in(clk), .out(segment_clk));
	clk_div #(.count_from(0), .count_to(80000000)) my_blink_clk(.in(clk), .out(blink_clk));
	
	// take care of debouncing/metastability
	
	// determine state based on FPGA inputs
	
	// instantiate fsm, pass in corresponding clock and state
	fsm my_fsm(.state(state), .clk_in(one_hz_clk), .start_sec(start_sec), .end_sec(start_sec));
	

	// Display digits on the FPGA's seven-segment display
	always @(*) begin
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
		
		// set the displays
		seg0 = (start_sec%60)%10;
		seg1 = (start_sec%60)/10;
		seg2 = (start_sec/60)%10;
		seg3 = (start_sec/600)%10;
		
		// seg0
		case (seg0)
			0: AN0 = 8'b11000000;
			1: AN0 = 8'b11111001;
			2: AN0 = 8'b10100100;
			3: AN0 = 8'b10110000;
			4: AN0 = 8'b10011001;
			5: AN0 = 8'b10010010;
			6: AN0 = 8'b10000010;
			7: AN0 = 8'b11111000;
			8: AN0 = 8'b10000000;
			9: AN0 = 8'b10010000;
			default: AN0 = 8'b11111111;
		endcase
		
		// seg1
		case (seg1)
			0: AN1 = 8'b11000000;
			1: AN1 = 8'b11111001;
			2: AN1 = 8'b10100100;
			3: AN1 = 8'b10110000;
			4: AN1 = 8'b10011001;
			5: AN1 = 8'b10010010;
			6: AN1 = 8'b10000010;
			7: AN1 = 8'b11111000;
			8: AN1 = 8'b10000000;
			9: AN1 = 8'b10010000;
			default: AN1 = 8'b11111111;
		endcase
		
		// seg2
		case (seg2)
			0: AN2 = 8'b11000000;
			1: AN2 = 8'b11111001;
			2: AN2 = 8'b10100100;
			3: AN2 = 8'b10110000;
			4: AN2 = 8'b10011001;
			5: AN2 = 8'b10010010;
			6: AN2 = 8'b10000010;
			7: AN2 = 8'b11111000;
			8: AN2 = 8'b10000000;
			9: AN2 = 8'b10010000;
			default: AN2 = 8'b11111111;
		endcase
		
		// seg3
		case (seg3)
			0: AN3 = 8'b11000000;
			1: AN3 = 8'b11111001;
			2: AN3 = 8'b10100100;
			3: AN3 = 8'b10110000;
			4: AN3 = 8'b10011001;
			5: AN3 = 8'b10010010;
			6: AN3 = 8'b10000010;
			7: AN3 = 8'b11111000;
			8: AN3 = 8'b10000000;
			9: AN3 = 8'b10010000;
			default: AN3 = 8'b11111111;
		endcase
	end
endmodule

/*
// when one second is hit
			if () begin
				
			end
*/
