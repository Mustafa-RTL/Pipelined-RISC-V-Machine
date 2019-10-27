`timescale 1ns / 1ps
`include "defines_2.v"
`include "defines.v"
/*********************************************************************
* Module: Data_mem.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: This is the Data Memory module
* Change history:	25/10/2019 – File Created
*				 	26/10/2019 - Added Half word and byte supporting code
*********************************************************************/


module Data_mem(
input clk,
input [31:0]addr,
input MemWrite,
input MemRead,
input HalfOperation,		// Added to indicate a half word load/store
input ByteOperation,		// Added to indicate a Byte load/store
input [31:0] data_write,
output [31:0] data_read);
							// If HalfOperation and ByteOperation are LOW then by default the Memory Operation is a word Operation
reg [31:0] mem [0:63];
wire [7:0] address = addr [7:0];
wire [15:0] halfWord;
wire [7:0] byteWord;
initial begin
mem[0]=32'd17;
mem[1]=32'd9;
mem[2]=32'd25;
end

always @(posedge clk) begin
if (MemWrite)
mem[address] <= data_write;
end
if(!HalfOperation && !ByteOperation) // Word operation (standard)
	assign  data_read = MemRead?mem[[7:2]address]:0;
else
	if(HalfOperation) // Half word Operation
		if(!address[1])
			assign data_read = MemRead?{16'b0000000000000000,mem[[7:2]address][SECOND_BYTE_OFFSET]:mem[[7:2]address][FIRST_BYTE_OFFSET]}:0;
		else
			assign data_read = MemRead?{16'b0000000000000000,mem[[7:2]address][MEM_WIDTH]:mem[[7:2]address][THIRD_BYTE_OFFSET]}:0;
	else	// Byte Operation
		if(!address[1] && !address[0])
			assign data_read = MemRead?{24'b000000000000000000000000, mem[[7:2]address][SECOND_BYTE_OFFSET]:mem[[7:2]address][FIRST_BYTE_OFFSET]}:0;
		else
			if(!address[1] && address[0])
				assign data_read = MemRead?{24'b000000000000000000000000, mem[[7:2]address][THIRD_BYTE_OFFSET]:mem[[7:2]address][SECOND_BYTE_OFFSET]}:0;
			else
				if(address[1] && !address[0])
					assign data_read = MemRead?{24'b000000000000000000000000, mem[[7:2]address][FOURTH_BYTE_OFFSET]:mem[[7:2]address][THIRD_BYTE_OFFSET]}:0;
				else
					assign data_read = MemRead?{24'b000000000000000000000000, mem[[7:2]address][MEM_WIDTH]:mem[[7:2]address][FOURTH_BYTE_OFFSET]}:0;
endmodule
