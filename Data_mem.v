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
if(MemWrite)
	if(HalfOperation)
		if(!address[1])
			mem[address[7:2]] = {16'd0,data_write};
		else
			mem[address[7:2]] = {16'd0,data_write};
	else	// Byte Operation
		if(!address[1] && !address[0])
			mem[address[7:2]] = {24'd0, data_write};
		else
			if(!address[1] && address[0])
				mem[address[7:2]] = {24'd0,data_write};
			else
				if(address[1] && !address[0])
					mem[address[7:2]] = {24'd0, data_write};
				else
					mem[address[7:2]] = {24'd0, data_write};
end
always @(posedge clk) begin
if(MemRead)
if(!HalfOperation && !ByteOperation) // Word operation (standard)
	data_read = mem[address[7:2]];
else
	if(HalfOperation) // Half word Operation
		if(!address[1])
			 data_read = {16'd0,mem[address[7:2]][SECOND_BYTE_OFFSET:0]};
		else
			data_read = {16'd0,mem[address[7:2]][MEM_WIDTH:THIRD_BYTE_OFFSET]};
	else	// Byte Operation
		if(!address[1] && !address[0])
			data_read = {24'd0, mem[address[7:2]][SECOND_BYTE_OFFSET:FIRST_BYTE_OFFSET]};
		else
			if(!address[1] && address[0])
				data_read = {24'd0, mem[address[7:2]][THIRD_BYTE_OFFSET:SECOND_BYTE_OFFSET]};
			else
				if(address[1] && !address[0])
					data_read = {24'd0, mem[address[7:2]][FOURTH_BYTE_OFFSET:THIRD_BYTE_OFFSET]};
				else
					data_read = {24'd0,mem[address[7:2]][MEM_WIDTH:FOURTH_BYTE_OFFSET]};
end

endmodule

