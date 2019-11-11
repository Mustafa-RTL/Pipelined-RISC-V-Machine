`timescale 1ns / 1ps
/******************************************************************* *
Module: RegFile.v
Project: Single Cycle RISC-V
Author: Kareem Alansary auckareemalansary@aucegypt.edu
Description:	Register File Module
Change history: 10/11/2019 – Created module	(Kareem)
*
**********************************************************************/

module Moderator(
	input clk,
	input rst,
	output tick_tock);

reg x;

/*always @(*) begin 
if (rst)
    x = 1'b1;
end*/

always @ (posedge(clk) or posedge(rst)) begin
    if (rst)
        x = 1'b1;
    else
        x = ~x; // x = 1 clk 2 x = 0 clk 1
end

assign tick_tock = x;

endmodule
