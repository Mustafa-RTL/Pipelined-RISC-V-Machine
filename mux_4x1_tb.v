 /******************************************************************* *

Module: mux_4x1_tb.v
Project: Single Cycle RISC-V
Author: Haitham Samir
Description: test bench for 4x1 mux
Change history: Date - Action
**********************************************************************/

module mux_4x1_tb();

reg [31:0]a;
reg [31:0]b;
reg  [31:0]c;
reg [31:0]d;
reg [1:0]sel;
wire [31:0]y;
mux_4x1 m(.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y));

initial  begin
a=32'd100;
b=32'd200;
c=32'd3000;
d=32'd15000;
sel=2'b11;
#10
sel=2'b01;
#10
sel=2'b10;
#10
sel=2'b00;

end

initial begin
if(y!=32'd15000) 
 $display("MUX is not successful because it produced %d when the selection was %d", y,sel);
 #15
 if(y!=32'd200) 
 $display("MUX is not successful because it produced %d when the selection was %d", y,sel);
  #15
 if(y!=32'd3000) 
  $display("MUX is not successful because it produced %d when the selection was %d", y,sel);
 #15
if(y!=32'd100) 
 $display("MUX is not successful because it produced %d when the selection was %d", y,sel);
 else
 $display("MUX is successful");
  
end
      
endmodule
