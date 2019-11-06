/*********************************************************************
* Module: N_bit_reg.v
* Project: Single Cycle RISC-V
* Author: Kareem Alansary auckareemalansary@aucgypt.edu
* Description: This is the N-bit Register module
* Change history:	25/10/2019 - File Created
*                    	27/10/2019 - Edited and corrected by Haitham Samir
*			6/11/2019 - Edited and corrected by Kareem Alansary and Mahmoud Ghidan
*********************************************************************/
module N_bit_reg # (parameter N=32)(
    input clk,
    input rst,
    input load,
    input [N-1:0] D,
    output wire [N-1:0] Q
    );
    wire [N-1:0] D_new;
    genvar i;
    generate
        for (i=0; i<N; i=i+1)
        begin:FFs
            mux_2x1 mux(.a(Q[i]), .b(D[i]), .sel(load), .c(D_new[i]));
            DFlipFlop FF(.clk(clk), .rst(rst), .D(D_new[i]), .Q(Q[i]));
        end
    endgenerate
endmodule
