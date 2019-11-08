`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2019 12:11:50 AM
// Design Name: 
// Module Name: ss_data_path_tb
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


module ss_data_path_tb();
reg clk,rst;
    
    data_path  dp(clk, rst);
    initial begin
clk=0;
 forever #100 clk=~clk; 
    end
    initial begin
    rst=0;
    
    end
    
     
endmodule
