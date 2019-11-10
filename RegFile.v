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
    input Moderator_in,
	output [31:0] rs1, rs2 );

    reg [31:0]load;
    wire [31:0]out[0:31];
    
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin:RegsFile 
            N_bit_reg reg_x1_x31(.clk(clk), .D(writedata), .rst(rst), .load(load[i]), .Q(out[i]));
        end
    endgenerate
    N_bit_reg reg_x0(.clk(clk), .D(32'b0), .rst(rst), .load(load[0]), .Q(out[0]));
    always @(posedge clk) begin
        load=32'b0;
        if(~Moderator_in)
            if(regwrite)
                load[writereg_addr]=1;
    end        
    assign rs1 = out[rs1_addr];
    assign rs2 = out[rs2_addr]; 
endmodule

