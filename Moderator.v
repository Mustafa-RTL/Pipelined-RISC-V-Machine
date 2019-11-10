module Moderator(input clk,
	output x1);
reg x;
initial begin 
x = 0;
end

always @ (posedge(clk)) begin
x = ~x // x = 1 clk 2 x = 0 clk 1
end
assign x1 = x;
endmodule
