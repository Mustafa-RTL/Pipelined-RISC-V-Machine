
/*********************************************************************
* Module: N_bit_RCA.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: This is the N-bit Ripple Carry Adder module
* Change history:	25/10/2019 - File Created
*                    	27/10/2019 - Edited and corrected by Haitham Samir
*			6/11/2019 - Edited and corrected by Kareem Alansary and Mahmoud Ghidan
*********************************************************************/
module N_bit_RCA # (parameter N=32) (
	input [N-1:0]operand_a,
	input [N-1:0]operand_b,
	output [N-1:0]sum,
	output cout);
    
    wire [N:0]carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin:adder
            FA adder(.operand_a(operand_a[i]), .operand_b(operand_b[i]), .cin(carry[i]), .sum(sum[i]), .cout(carry[i+1]));
        end 
    endgenerate
    assign cout = carry[N];
endmodule

