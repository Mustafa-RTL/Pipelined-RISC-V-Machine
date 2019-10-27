 /******************************************************************* *

Module: mux_4x1.v
Project: Single Cycle RISC-V
Author: Haitham Samir
Description: 4x1 32-bit MUX
Change history: Date - Action
**********************************************************************/
module mux_4x1(input[31:0]a,input[31:0]b,input[31:0]c,input[31:0]d, input [1:0]sel, output reg [31:0]y);
always @(*) begin
case(sel)
2'b00: y=a;
2'b01: y=b;
2'b10: y=c;
2'b11: y=d;
default: y=0;
endcase
end

endmodule
