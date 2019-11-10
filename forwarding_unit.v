module forwarding_unit(
input [4:0]ID_EX_Rs1, 
input [4:0]ID_EX_Rs2,
input [4:0]EX_MEM_Rd,
input [4:0] MEM_WB_Rd,
input EX_MEM_regwrite,
input MEM_WB_regwrite,
output reg[1:0]forwardA,
output reg [1:0]forwardB);

always @(*) begin

	forwardA = 2'b00;
	forwardB = 2'b00;

	if(MEM_WB_regwrite && (MEM_WB_Rd !=0) && (MEM_WB_Rd == ID_EX_Rs1) && (EX_MEM_Rd == ID_EX_Rs1) && !(EX_MEM_regwrite!=0 && EX_MEM_Rd !=0))
		forwardA = 2'b01;

	if(MEM_WB_regwrite &&( MEM_WB_Rd !=0) && (MEM_WB_Rd == ID_EX_Rs2) && (EX_MEM_Rd == ID_EX_Rs2) && !(EX_MEM_regwrite!=0 && EX_MEM_Rd !=0))
		forwardB = 2'b01;

	if(EX_MEM_regwrite &&( EX_MEM_Rd !=0) && (EX_MEM_Rd == ID_EX_Rs1))
		forwardA = 2'b10;

	if(EX_MEM_regwrite && (EX_MEM_Rd !=0) && (EX_MEM_Rd == ID_EX_Rs2))
		forwardB = 2'b10;

end
endmodule
