`timescale 1ns / 1ps
/**********************************************************************
* Module: Inst_mem.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: This is the Instruction Memory module
* Change history: 25/10/2019 – File Created
**********************************************************************/



module inst_mem( input [31:0]pc,
 output [31:0] inst);

reg [31:0] instruction [63:0];
wire [5:0] address;
wire [1:0] addressB;
assign address = pc[7:2];
assign inst = instruction[address];

initial begin
        instruction[0]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)  
        instruction[1]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)     
        instruction[2]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)      
        instruction[3]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2      
        instruction[4]=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4 
        instruction[5]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2 
        instruction[6]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2  
        instruction[7]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)   
        instruction[8]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)    
        instruction[9]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1  
        instruction[10]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2   
        instruction[11]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2    
        instruction[12]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
end
endmodule
