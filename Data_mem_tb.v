`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2019 09:35:28 PM
// Design Name: 
// Module Name: Data_mem_tb
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


module Data_mem_tb();
reg clk;
reg [31:0]addr;
reg MemWrite;
reg MemRead;
reg HalfOperation;		// Added to indicate a half word load/store
reg ByteOperation;		// Added to indicate a Byte load/store
reg [31:0] data_write;
wire  [31:0] data_read;


Data_mem dm(.clk(clk), .addr(addr), .MemWrite(MemWrite), .MemRead(MemRead), .HalfOperation(HalfOperation), .ByteOperation(ByteOperation), .data_write(data_write), .data_read(data_read));
initial
begin      
    clk = 0;       
    forever #5 clk=~clk;  
end
initial begin

//lb for byte 1
addr=32'b0; //mem[0], byte 1
MemWrite=0;
MemRead=1;
HalfOperation=0;
ByteOperation=1;
data_write=0;
#10

addr={32'd1}; //lower half of mem[1]
MemWrite=0;
MemRead=1;
HalfOperation=1;
ByteOperation=0;
data_write=0;

#10
addr={32'd3}; //writing in location mem[3]
MemWrite=1;
MemRead=0;
HalfOperation=0;
ByteOperation=0; // I will begin with normal sw inst. 
data_write= 32'b11111111_00000000_11111111_00000000;

#10
addr={32'd3}; 
MemWrite=0;
MemRead=1;
HalfOperation=0;  //I will check if it's written where expected by reading the location
ByteOperation=0;

#10
addr={32'd7}; //writing byte 1
MemWrite=1;
MemRead=0;
HalfOperation=0;
ByteOperation=1;
data_write= 8'b11110000;
#10
addr={32'd10}; //writing byte 1
MemWrite=1;
MemRead=0;
HalfOperation=0;
ByteOperation=1;
data_write= 8'b11110000;
#10
addr={32'd7} ; //mem[3], reading byte 1
MemWrite=0;
MemRead=1;
HalfOperation=0;
ByteOperation=1;

#10
addr={32'd10} ; //mem[3], reading byte 1
MemWrite=0;
MemRead=1;
HalfOperation=0;
ByteOperation=1;

#10
addr={32'd3}; //reading location three after writing the 4 bytes, should yield = 00000000_11111111_00000000_11111111
MemWrite=0;
MemRead=1;
HalfOperation=0;
ByteOperation=0; 

#10

addr={32'd8}; //lower half 
MemWrite=1;
MemRead=0;
HalfOperation=1;
ByteOperation=0;
data_write=16'b00001111_00001111;
end

endmodule
