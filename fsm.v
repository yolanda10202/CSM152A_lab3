`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:30:12 05/02/2022 
// Design Name: 
// Module Name:    fsm 
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
module fsm(state, clk_in, start_sec, end_sec);
	input [1:0] state;
	input clk_in;
	input [31:0] start_sec;
	output reg [31:0] end_sec;
	
	localparam STATE0 = 0;
	localparam STATE1 = 1;
	// localparam STATE2 = 2;
	// localparam STATE3 = 3;
	
	reg [31:0] counter = start_sec;

	always @(posedge clk_in) begin
	  case (state)
			// normal (increment)
			(STATE0): 
				 counter = counter + 1;
			// pause
			(STATE1): 
				 counter = counter;
			/*
			// adjust
			(STATE2):
				 state <= (some_input or variable) ? STATE3 : STATE2;
				 outputs <= some value
			
			(STATE3): 
				 state <= (some_input or variable) ? STATE0 : STATE3;
				 output <= some value
			*/
			default:
				 state <= STATE0;
		endcase
		
		end_sec = counter;
	end

	// We can use state in other combinatorial logic
	// ex:
	/*
	assign variable = (state == STATE2) && other_variable;

	// or in a register
	always @(posedge clk) begin
		 variable <= (rst) ? '0:
						 (state == STATE2) ? other_variable : some other variable;
	end*/

endmodule
