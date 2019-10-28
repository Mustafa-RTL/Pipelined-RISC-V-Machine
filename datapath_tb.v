
module datapath_tb();
reg clk,rst;
data_path2 processor (clk,rst);


 
 
 initial begin
 clk=0;
 forever #5 clk=~clk;
 end
 initial begin
 rst=1;
 #50
 rst=0;
 end
 
endmodule
