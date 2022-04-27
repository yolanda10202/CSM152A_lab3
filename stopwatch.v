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
module stopwatch(clk, stop, reset, sel, adj, AN3, AN2, AN1, AN0);
	// input clk is a 100MHz clock
	input clk;
	input stop, reset, sel, adj;
	output reg [7:0] AN3, AN2, AN1, AN0;
	
	wire one_hz_clk;
	wire two_hz_clk;
	wire segment_clk;
	wire blink_clk;
	
	reg [31:0] sec;
	wire [3:0] seg3, seg2, seg1, seg0;
	
	// instantiate the other three clocks with clock divider
	clk_div #(.count_from(0), .count_to(100000000)) my_one_hz_clk(.in(clk), .out(one_hz_clk));
	clk_div #(.count_from(0), .count_to(50000000)) my_two_hz_clk(.in(clk), .out(two_hz_clk));
	clk_div #(.count_from(0), .count_to(1000000)) my_segment_clk(.in(clk), .out(segment_clk));
	clk_div #(.count_from(0), .count_to(80000000)) my_blink_clk(.in(clk), .out(blink_clk));

	// selection
	
	// adjustment
	if (adj) begin
		// set seconds
		if (sel == 1) begin
			// increment number with 2 Hz
		end
		
		// set minutes
		else begin
		// increment number with 2 Hz
		
		end
	end
	

	// each iteration is one sec
	always @ (posedge choose_clk, negedge reset) begin
		if (reset == 1) begin
			sec = 0;
		end
		if (stop == 0) begin
			// when one second is hit
			if () begin
				seg0 = (sec%60)%10;
				seg1 = (sec%60)/10;
				seg2 = (sec/60)%10;
				seg3 = (sec/600)%10;
				
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
			else begin
				// increment clock
			end
		end
	end
endmodule
