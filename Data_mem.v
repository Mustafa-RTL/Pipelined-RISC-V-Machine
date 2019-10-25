`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 10:13:50 AM
// Design Name: 
// Module Name: Data_mem
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


module Data_mem(
input clk,
input [31:0]addr, 
input MemWrite, 
input MemRead, 
input [31:0] data_write,
output [31:0] data_read);

reg [31:0] mem [0:63];
wire [7:0] address = addr [7:0];

initial begin
mem[0]=32'd17;
mem[1]=32'd9;
mem[2]=32'd25;
end

always @(posedge   clk) begin
if (MemWrite)
mem[address] <= data_write;
end

assign  data_read = MemRead?mem[address]:0;

endmodule
