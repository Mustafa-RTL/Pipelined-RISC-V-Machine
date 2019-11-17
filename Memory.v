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
input tick_tock,				// Decides the type of operation (fetch / WB(load/store)) if(tick_tock == 0) Fetch else WB
input [31:0] data_write,
output reg [31:0] data_read); 	// Can be instruction or data
								// If HalfOperation and ByteOperation are LOW then by default the Memory Operation is a word Operation
reg [7:0] mem [0:255];

/*initial begin
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

end*/

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