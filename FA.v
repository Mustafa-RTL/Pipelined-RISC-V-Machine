`timescale 1ns / 1ps


/*********************************************************************
* Module: FA.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: This is the Full Adder module
* Change history:	25/10/2019 - File Created
*                    	27/10/2019 - Edited and corrected by Haitham Samir
*			6/11/2019 - Edited and corrected by Kareem Alansary
*			and Mahmoud Ghidan
*********************************************************************/

module FA(
    input operand_a,operand_b,cin,
    output sum,cout
    );
    
    assign cout = (operand_a&operand_b) | (operand_b&cin) | (cin&operand_a);
    assign sum = operand_a ^ operand_b ^ cin;
endmodule
