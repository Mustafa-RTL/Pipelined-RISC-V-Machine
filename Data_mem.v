`timescale 1ns / 1ps
//`include "defines_2.v"
//`include "defines.v"
/*********************************************************************
* Module: Data_mem.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: This is the Data Memory module
* Change history:	25/10/2019 – File Created
*				 	26/10/2019 - Added Half word and byte supporting code
                    27/10/2019 - Edited and corrected by Haitham Samir
*********************************************************************/


module Data_mem(
input clk,
input [31:0]addr,
input MemWrite,
input MemRead,
input HalfOperation,		// Added to indicate a half word load/store
input ByteOperation,		// Added to indicate a Byte load/store
input [31:0] data_write,
output reg [31:0] data_read);
							// If HalfOperation and ByteOperation are LOW then by default the Memory Operation is a word Operation
reg [31:0] mem [0:63];
wire [7:0] address = addr [7:0];
wire [15:0] halfWord;
wire [7:0] byteWord;
initial begin
mem[0]= 32'b11111111_01010100_00000000_10100100;
mem[1]=32'b10010110_01010100_01011110_10100100;
mem[2]= 32'b11111111_11111111_00000000_00000000;
end

always @(posedge clk) begin
if(MemWrite & ~MemRead)
if(!HalfOperation && !ByteOperation) // Word operation (standard)
	   mem[address[7:2]] <= data_write;
else
	if(HalfOperation)
		if(!address[0])  //if LSB is 1, we store in the lower 16 bits
			mem[address[7:2]] <=  {mem[address[7:2]][31:16] , data_write[15:0]};

		else
			mem[address[7:2]] <=  {data_write[15:0], mem[address[7:2]][15:0]};
	else	// Byte Operation
		if(!address[1] && !address[0])
			mem[address[7:2]] <=  {mem[address[7:2]][31:8], data_write[7:0]};
		else
			if(!address[1] && address[0])
				mem[address[7:2]] <=   {mem[address[7:2]][31:16],  data_write[7:0],mem[address[7:2]][7:0]} ;
			else
				if(address[1] && !address[0])
					mem[address[7:2]] <=  {mem[address[7:2]][31:24], data_write[7:0], mem[address[7:2]][15:0]} ;
				else
					mem[address[7:2]] <=  { data_write[7:0],mem[address[7:2]][23:0]};
end
always @(posedge clk) begin
if(MemRead & ~MemWrite)
if(!HalfOperation && !ByteOperation) // Word operation (standard)
	  data_read = mem[address[7:2]];
else
	if(HalfOperation) // Half word Operation
		if(!address[0])
			 data_read = mem[address[7:2]][15:0];
		else
			 data_read = mem[address[7:2]][31:16];
	else	// Byte Operation
		if(!address[1] && !address[0])
			 data_read = mem[address[7:2]][7:0];
		else
			if(!address[1] && address[0])
				 data_read = mem[address[7:2]][15:8];
			else
				if(address[1] && !address[0])
					 data_read = mem[address[7:2]][23:16];
				else
					 data_read = mem[address[7:2]][31:24];
end
endmodule
