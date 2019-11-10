`include "defines.v"

/*******************************************************************
*
* Module: shifter.v
* Project: Single Cycle RISC-V
* Author: Haitham Samir
* Description: This is a shifter for the ALU.
*
* Change history: 24/10/2019 – File Created
				  25/10/2019 – Edits by Mustafa Mahmoud
*
**********************************************************************/
module shifter (
input [31:0] a,
input [5:0] shamt,
input [1:0] stype,
output  reg [31:0] r
);

	always @(*) begin
		case(stype)
		2'b00: r = a >> shamt; //case for logical shifting right
		2'b01: r = a << shamt; //case for logical shifting left
		2'b10:  r = a >>> shamt; //case for arithmetic shifting right
		default: r=a;
		endcase
	end
endmodule
