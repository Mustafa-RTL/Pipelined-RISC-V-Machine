`timescale 1ns / 1ps
/*********************************************************************
* Module: pc.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: This is the program counter module
* Change history:	25/10/2019 - File Created
*                    	27/10/2019 - Edited and corrected by Haitham Samir
*			6/11/2019 - Edited and corrected by Kareem Alansary and Mahmoud Ghidan
*********************************************************************/
module program_counter(
	input clk,
	input rst,
	input [31:0]pc_in,
	output [31:0]pc_out
);
    N_bit_reg #(32) pc_reg (clk.(clk), rst.(rst), .1'b1(load).pc_in(D),pc_out.(Q));
endmodule
