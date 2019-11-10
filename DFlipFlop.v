`timescale 1ns / 1ps
/********************************************************************
*	Module: DFlipFlop.v
*	Project: Single Cycle RISC-V
*	Author: Kareem Alansary  auckareemalansary@aucegypt.edu
*	Description:	D-Flip-Flop module
*	Change history: 26/10/2019 – Created Module
**********************************************************************/

module DFlipFlop (input clk, input rst, input D, output reg Q);
     always @ (posedge clk or posedge rst) begin // Asynchronous Reset
         if (rst)
            Q <= 1'b0;
         else
            Q <= D;
     end
endmodule
