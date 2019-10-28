`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 02:22:39 PM
// Design Name: 
// Module Name: inst_memory
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


module InstMem (input [31:0] addr, output [31:0] data_out);
    reg [31:0] mem [0:63];
    assign data_out = mem[addr];
    
    
    
    initial begin
    mem[0]=32'b00000000_00000000_00000000_10000011;
    mem[1]=32'b00000000001000000001000100000011;
    mem[2]=32'b00000000000000000010000110000011;
    mem[3]=32'b00000000001000001000001000110011;
    mem[4]=32'b01000000001000011000001010110011;
    mem[5]=32'b00000000001000001111001100110011;
    mem[6]=32'b00000000000000011110001110110011;
    mem[7]=32'b00000000000000001100010000110011;
    mem[8]=32'b00000000000100010001010010110011;
    mem[9]=32'b00000000010000001010010100110011;
    mem[10]=32'b00000000001000100011010110110011;
    mem[11]=32'b00000000000100010101011000110011;
    mem[12]=32'b01000000000100010101011010110011;
    mem[13]=32'b00000000001000001000011100010011;
    mem[14]=32'b11111111111100001111011110010011;
    mem[15]=32'b11111111111100011110100000010011;
    mem[16]=32'b11111111111100001100100010010011;
    mem[17]=32'b00000000000100010001100100010011;
    mem[18]=32'b00000000000000001010100110010011;
    mem[19]=32'b11111111111100100011101000010011;
    mem[20]=32'b00000000001000010101101010010011;
    mem[21]=32'b01000000001100010101101100010011;
    mem[22]=32'b00000001011100000000001000100011;
    mem[23]=32'b00000001100000000001001010100011;
    mem[24]=32'b00000001100100000010001100100011;
    mem[25]=32'b00000000100000000000110101101111;
    mem[26]=32'b00000000000000000000000000000000;
    mem[27]=32'b00000111100000000000110111100111;
    mem[28]=32'b00000000000000000000000000000000;
    mem[29]=32'b00000000000000000000000000000000;
    mem[30]=32'b00000000000011111111111000110111;
    mem[31]=32'b00000000000000000100111010010111;
    mem[32]=32'b00000010000000000000010001100011;
    mem[33]=32'b00000000000100000001010001100011;
    mem[34]=32'b11111110000010000100111011100011;
    mem[35]=32'b00000000000000010101010001100011;
    mem[36]=32'b11111111000000000110111011100011;
    mem[37]=32'b00000000000010000111010001100011;
    mem[38]=32'b00000000000000000000000000000000;
    mem[39]=32'b00000000000000000000000000000000;
    end

endmodule

