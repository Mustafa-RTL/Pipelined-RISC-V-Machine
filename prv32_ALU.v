`include "defines.v"
module prv32_ALU(
	input   wire [31:0] a, b,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [3:0]  alufn,
	input 	wire [5:0] shamt
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;	//What are these??
		wire [31:0] sh;
		reg [5:0] shamtnew;


    assign op_b = (~b);

    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);

    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);

		always @ (*)
		begin
			if (shamt == 6'd32 && b < 32'd32)		//if R-type shift and b < 32, take shamt from b else keep shamt as it is
				shamtnew = b[5:0];
			else
				shamtnew = shamt;
		end

    shifter shifter0(.a(a), .shamt(shamtnew), .stype(alufn[1:0]),  .r(sh));

    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            `ALU_ADD : r = add;
            `ALU_SUB : r = add;
            `ALU_PASS : r = b;
            // logic
            `ALU_OR:  r = a | b;
            `ALU_AND:  r = a & b;
            `ALU_XOR:  r = a ^ b;
            // shift
            `ALU_SRL:	r=sh;
            `ALU_SRA:	r=sh;
            `ALU_SLL:	r=sh;
            // slt & sltu
            `ALU_SLT:  r = {31'b0,(sf != vf)};
            `ALU_SLTU:  r = {31'b0,(~cf)};
        endcase
    end
endmodule
