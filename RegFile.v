`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2019 01:43:37 PM
// Design Name: 
// Module Name: reger
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


module RegFile (
	input clk, rst,
	input [4:0] rs1_addr, rs2_addr, writereg_addr,
	input [31:0] writedata,
	input regwrite,
	output [31:0] rs1, rs2 
);

    wire [31:0]load;
    wire [31:0]out[0:31];
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin:RegsFile 
            N_bit_reg regriar(clk.(clk), writedata.(D), rst.(rst), load[i].(load), out[i].(Q));
        end
    endgenerate
    
    assign rs1 = rs1_addr != 5'b0 ? out[rs1_addr] : 5'b0;
    assign rs2 = rs2_addr != 5'b0 ? out[rs2_addr] : 5'b0;
        
    assign load = regwrite ? 1'b1 << writereg_addr : 0;
    
endmodule

