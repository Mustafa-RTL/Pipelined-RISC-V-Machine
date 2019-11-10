

module forwarding_unit_tb();

reg [4:0]ID_EX_Rs1;
reg [4:0]ID_EX_Rs2;
reg [4:0]EX_MEM_Rd;
reg [4:0] MEM_WB_Rd;
reg EX_MEM_regwrite;
reg MEM_WB_regwrite;
wire [1:0]forwardA;
wire [1:0]forwardB;

forwarding_unit fw(ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_regwrite, MEM_WB_regwrite, forwardA, forwardB);
initial begin
ID_EX_Rs1= 4;
ID_EX_Rs2= 0;
EX_MEM_Rd= 4;
MEM_WB_Rd= 0;
EX_MEM_regwrite=0;
 MEM_WB_regwrite=0;
#100
ID_EX_Rs1= 4;
ID_EX_Rs2= 0;
EX_MEM_Rd= 4;
MEM_WB_Rd= 0;
EX_MEM_regwrite=1;
 MEM_WB_regwrite=0;
 #100
 ID_EX_Rs1= 4;
 ID_EX_Rs2= 3;
 EX_MEM_Rd= 3;
 MEM_WB_Rd= 0;
 EX_MEM_regwrite=1;
MEM_WB_regwrite=0;

#100
ID_EX_Rs1= 9;
ID_EX_Rs2= 3;
EX_MEM_Rd= 9;
MEM_WB_Rd= 9;
EX_MEM_regwrite=0;
MEM_WB_regwrite=1;
#100
ID_EX_Rs1= 9;
ID_EX_Rs2= 3;
EX_MEM_Rd= 3;
MEM_WB_Rd= 3;
EX_MEM_regwrite=0;
MEM_WB_regwrite=1;
#100
ID_EX_Rs1= 0;
ID_EX_Rs2= 0;
EX_MEM_Rd= 0;
MEM_WB_Rd= 0;
EX_MEM_regwrite=1;
MEM_WB_regwrite=1;
 








end
endmodule
