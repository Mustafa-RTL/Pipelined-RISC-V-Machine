`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 03:51:52 PM
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc(
	input clk,
	input rst,
	input [31:0]pc_in,
	output [31:0]pc_out
);
wire D_new;
    N_bit_reg #(32) pc_reg (clk.(clk), rst.(rst), D_new(D),pc_out.(Q));
    mux_2x1 #(32) pc_mux (pc_out.(a) ,pc_in.(b),1'b1.(sel),D_new.(c)); 
endmodule
