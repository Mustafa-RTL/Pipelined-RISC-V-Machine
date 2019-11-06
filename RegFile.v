`timescale 1ns / 1ps
/******************************************************************* *
Module: RegFile.v
Project: Single Cycle RISC-V
Author: Kareem Alansary auckareemalansary@aucegypt.edu
Description:	Register File Module
Change history: 27/10/2019 – Created module
*		5/11/2019  - Re-wrote module (Kareem)
*		5/11/2019  - module debugging (Mustafa, Kareem)
**********************************************************************/
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
            N_bit_reg regriar(.clk(clk), .D(writedata), .rst(rst), .load(load[i]), .Q(out[i]));
        end
    endgenerate
    
    assign rs1 = rs1_addr != 5'b0 ? out[rs1_addr] : 5'b0;
    assign rs2 = rs2_addr != 5'b0 ? out[rs2_addr] : 5'b0;
        
    assign load = regwrite ? 1'b1 << writereg_addr : 0;
    
endmodule

