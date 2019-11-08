`timescale 1ns / 1ps
/******************************************************************* *
Module: RegFile.v
Project: Single Cycle RISC-V
Author: Kareem Alansary auckareemalansary@aucegypt.edu
Description:	Register File Module
Change history: 27/10/2019 – Created module
*		5/11/2019  - Re-wrote module (Kareem)
*		5/11/2019  - module debugging (Mustafa, Kareem)
*       9/11/2019  - editing    (Mustafa)
**********************************************************************/
module RegFile (
	input clk, rst,
	input [4:0] rs1_addr, rs2_addr, writereg_addr,
	input [31:0] writedata,
	input regwrite,
	output [31:0] rs1, rs2 
);

    wire [31:0] load;
    wire [31:0] out [0:31];
    
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin:RegsFile 
            N_bit_reg X(.clk(clk), .D(writedata), .rst(rst), .load(load[i]), .Q(out[i]));
        end
    endgenerate
    
    N_bit_reg X0(.clk(clk), .D(32'b0), .rst(rst), .load(1'b1), .Q(out[i]));

    assign rs1 = out[rs1_addr];
    assign rs2 = out[rs2_addr];
        
    always @(*)
    begin
        load = 32'b0;
        if (regwrite)
          load[writereg_addr] = 1;
    end
    
endmodule

