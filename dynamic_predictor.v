`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Created by: Haitham Samir 
// Create Date: 11/15/2019 06:45:24 PM
// Module Name: dynamic_predictor
// Project Name: Computer Architecture
// Target Devices: Nexys AT-100
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This version doesn't support subsequent branch instructions
// 
//////////////////////////////////////////////////////////////////////////////////


module dynamic_predictor(input branch_signal, input previous_branch_result, output reg branch_decision);
//branch_signal represents a branch instruction and previous_branch_result is the actual decsision after prediction
wire [3:0]DecisionGradient= {1'b1,1'b1,1'b0, 1'b0}; //this represents four levels of confidence for branches [Confidently Taken, Taken, Not Taken, Confidently not taken]
reg [1:0]i=3; //selector initialized at Confidently taken
reg history=1'b1; //I assumed last decision was right initially
always @(posedge branch_signal) begin
history=previous_branch_result;
if (history && (i != 3)) //increase confidence
i=i+1;
if (!history && (i != 0)) //decrease confidence
i=i-1;
branch_decision = DecisionGradient[i];

end


endmodule
