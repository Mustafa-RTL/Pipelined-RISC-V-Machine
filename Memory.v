`timescale 1ns / 1ps
`include "defines.v"
/*********************************************************************
* Module: Data_mem.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: This is the Memory module
* Change history:	25/10/2019 - File Created (Kareem Alansary)
*			26/10/2019 - Added Half word and byte supporting code
*           27/10/2019 - Edited and corrected by Haitham Samir
*			28/10/2019 - Edited and corrected by Kareem Alansary
*			10/11/2019 - Edited Data_mem module and changed its name to Memory (Kareem Alansary)
*********************************************************************/


module Memory(
input clk,
input [31:0]addr,				// Can be address or ALU output
input MemWrite,
input MemRead,
input HalfOperation,			// Added to indicate a half word load/store
input ByteOperation,			// Added to indicate a Byte load/store
input tick_tock,				// Decides the type of operation (fetch / WB(load/store)) if(tick_tock == 1) Fetch else WB
input [31:0] data_write,
output reg [31:0] data_read); 	// Can be instruction or data
								// If HalfOperation and ByteOperation are LOW then by default the Memory Operation is a word Operation
reg [7:0] mem [0:255];

initial begin
mem[0]= 8'b11111111;
mem[1]= 8'b01010100;
mem[2]= 8'b00000001;
mem[3]= 8'b00000010;
mem[4]= 8'b00000100;
mem[5]= 8'b00001000;
mem[6]= 8'b00010000;
mem[7]= 8'b10000010;
mem[8]= 8'b01000100;
mem[9]= 8'b00101000;
mem[10]= 8'b01010110;
mem[11]= 8'b00011100;
mem[12]= 8'b01111010;

end

always @(posedge clk) begin
	if(tick_tock) begin	
		if(MemWrite & ~MemRead)
			if(!HalfOperation && !ByteOperation) begin // Word operation (standard)
		   		mem[addr] <= data_write[7:0];
		   		mem[addr+1] <= data_write[15:8];
		   		mem[addr+2] <= data_write[23:16];
		   		mem[addr+3] <= data_write[31:24];
			end
		else
			if(HalfOperation)begin
				mem[addr] <=  { data_write[7:0]};
				mem[addr+1] <=  { data_write[15:8]};
			end	
			else	// Byte Operation
				mem[addr] <=  {data_write[7:0]};
	end
end

always @(*) begin
	if(tick_tock)
		if(MemRead & ~MemWrite)
			if(!HalfOperation && !ByteOperation) // Word operation (standard)
		   		data_read = {mem[addr+3] , mem[addr+2], mem[addr+1], mem[addr]};
			else if(HalfOperation) // Half word Operation
				data_read = {16'd0,mem[addr+1],mem[addr]};
			else	// Byte Operation
				data_read = {24'd0,mem[addr]};
		else
			data_read = 32'b0;
	else
		data_read = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
end

endmodule