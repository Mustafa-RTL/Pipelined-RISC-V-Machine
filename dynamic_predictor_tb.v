`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2019 07:11:27 PM
// Design Name: 
// Module Name: dynamic_predictor_tb
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


module dynamic_predictor_tb();
reg branch_signal, previous_branch_result;
wire branch_decision;
dynamic_predictor dbp_tb(.branch_signal(branch_signal), .previous_branch_result(previous_branch_result), .branch_decision(branch_decision));

initial begin

#100
branch_signal = 1;
previous_branch_result=1;
#50
branch_signal = 0;
previous_branch_result=1;
#50
branch_signal = 1;
previous_branch_result=0;
#50
branch_signal = 0;
previous_branch_result=0;
#50
branch_signal = 1;
previous_branch_result=0;
#50
branch_signal = 0;
previous_branch_result=0;
#50
branch_signal = 1;
previous_branch_result=0;
#50
branch_signal = 0;
previous_branch_result=0;
#50
branch_signal = 1;
previous_branch_result=0;
#50
branch_signal = 0;
previous_branch_result=1;
#50
branch_signal = 1;
previous_branch_result=1;
#50
branch_signal = 0;
previous_branch_result=1;
#50
branch_signal = 1;
previous_branch_result=1;
#50
branch_signal = 0;
previous_branch_result=1;
end

endmodule
