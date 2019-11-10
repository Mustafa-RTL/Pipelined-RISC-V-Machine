module Moderator(
	input clk,
	output tick_tock);

reg x;

initial begin 
x = 0;
end

always @ (posedge(clk)) begin
x = ~x; // x = 1 clk 2 x = 0 clk 1
end

assign tick_tock = x;

endmodule
