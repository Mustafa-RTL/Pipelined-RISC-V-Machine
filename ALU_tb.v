`include "defines.v"
`timescale 1ns / 1ps

/*******************************************************************
*
* Module: ALU_tb.v
* Project: Single Cycle RISC-V
* Author: Mustafa Mahmoud mustafamohammed_auc@aucgypt.edu
* Description: This is a testbench for the RISC-V ALU to test all R & I type instructions
			   performed by the ALU. Test cases will be random and non-exhaustive; however,
			   there should be at least one test case present for each operation/instruction.
*
* Change history: 25/10/2019 – File Created
*
**********************************************************************/


module ALU_tb();

reg [31:0] a;
reg [31:0] b;
reg [4:0]  shamt;
wire [31:0] r;
wire cf, zf, vf, sf;
reg [3:0]  alufn;

prv32_ALU alu(.a(a), .b(b), .shamt(shamt), .r(r), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(alufn));

reg clk;

initial
begin
    clk = 0;
    forever #5 clk=~clk;
end

initial
// Stimulus
begin
	// arithmetic
	a = 32'd32;
	b = 32'd100;
	shamt = 5'd1;
	alufn = `ALU_ADD;

	#10
	alufn = `ALU_SUB;

	#10
	alufn = `ALU_PASS;

	// logical
	#10
	a = {26'b0, 6'b101010};
	b = {26'b0, 6'b010101};
	alufn = `ALU_OR;

	#10
	alufn = `ALU_AND;

	#10
	alufn = `ALU_XOR;

	// shift
	#10
	a = 255;
	shamt = 1;
	alufn = `ALU_SRL;

	#10
	shamt = 5;
	alufn = `ALU_SRA;

	#10
	shamt = 2;
	alufn = `ALU_SLL;

	// slt & sltu
	#10
	a = 1;
	b = -1;
	alufn = `ALU_SLT;

	#10
	alufn = `ALU_SLTU;

	// zero, carry and overflow
	#10
	a = {1'b1, 31'd0};
	b = {1'b1, 31'd0};
	alufn = `ALU_ADD;
end



initial
// Verification
begin
	// arithmetic
	#5
	if (r == a+b)
		$display("ADD PASSED");
	else begin
		$display("ADD FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a+b));
	end

	#10
	if (r == a-b)
		$display("SUB PASSED");
	else begin
		$display("SUB FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a-b));
	end
	if (sf)
		$display("SIGN FLAG PASSED");
	else
		$display("SIGN FLAG FAILED");

	#10
	if (r == b)
		$display("NOP PASSED");
	else begin
		$display("NOP FAILED");
		$display("The module produced %d while the correct answer is %d", r, b);
	end

	// logical
	#10
	if (r == a|b)
		$display("OR PASSED");
	else begin
		$display("OR FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a|b));
	end

	#10
	if (r == (a&b))
		$display("AND PASSED");
	else begin
		$display("AND FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a&b));
	end

	#10
	if (r == a^b)
		$display("XOR PASSED");
	else begin
		$display("XOR FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a^b));
	end

	// shift
	#10
	if (r == a>>shamt)
		$display("SRL PASSED");
	else begin
		$display("SRL FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a>>shamt));
	end

	#10
	if (r == a>>>shamt)
		$display("SRA PASSED");
	else begin
		$display("SRA FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a>>>shamt));
	end

	#10
	if (r == a<<shamt)
		$display("SLL PASSED");
	else begin
		$display("SLL FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a<<shamt));
	end

	// slt & sltu
	#10
	if (r == (a>b))
		$display("SLT PASSED");
	else begin
		$display("SLT FAILED");
		$display("The module produced %d while the correct answer is %d", r, (a>b));
	end

	#10
	if (r == !(a>b))
		$display("SLTU PASSED");
	else begin
		$display("SLTU FAILED");
		$display("The module produced %d while the correct answer is %d", r, !(a>b));
	end

	// zero, carry and overflow
	#10
	if (cf & zf & vf)
		$display("FLAGS PASSED");
	else begin
		$display("ONE OR MORE FLAGS FAILED");
		$display("CF is %d, ZF is %d, VF is %d", cf, zf, vf);
	end
end
endmodule
