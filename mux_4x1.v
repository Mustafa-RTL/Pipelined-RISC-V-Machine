 /******************************************************************* *

Module: mux_4x1.v
Project: Single Cycle RISC-V
Author: Haitham Samir
Description: 4x1 32-bit MUX
Change history: Date - Action
**********************************************************************/
module mux_4x1 #(parameter N =32)(
	input[N-1:0]a1,
	input[N-1:0]b1,
	input[N-1:0]c1,
	input[N-1:0]d1,
	input [1:0]sel,
	output reg [N-1:0]y
);
always @(*) begin
case(sel)
2'b00: y=a1;
2'b01: y=b1;
2'b10: y=c1;
2'b11: y=d1;
default: y=0;
endcase
end

endmodule
