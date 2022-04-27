`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:24 04/27/2022 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div #(parameter count_from, parameter count_to) (in, out);
	input in;
	output reg out = 0;
	// Create 32 Bit Counter Variable
	reg [31:0] counter = count_from;
	
	// Put correct signals in trigger sensitivity list
	always @ (posedge in) begin
		if (counter == count_to/2) begin
			// Change variables/outputs under correct conditions
			counter <= 0;
			out = ~out;
		end
		else begin
			// Create default case
			counter <= counter + 1;
		end
	end
	
endmodule
