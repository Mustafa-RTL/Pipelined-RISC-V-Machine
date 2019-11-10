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
	output tick_tock);

reg x;

initial begin 
x = 0;
end

always @ (posedge(clk)) begin
x = ~x; // x = 1 clk 2 x = 0 clk 1
end

assign tick_tock = x;

endmodule
