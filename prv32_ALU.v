`include "defines.v"
module prv32_ALU(
	input   wire [31:0] a, b,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [3:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
		reg [4:0] shamt;
		wire[31:0] sh;


    assign op_b = (~b);

    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);

    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);

		always @(*)
		begin
			if (b > 32'd31)
				shamt = 5'd31;
			else
				shamt = b;
		end

    shifter shifter0(.a(a), .shamt(shamt), .stype(alufn[1:0]),  .r(sh));

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
            `ALU_SRL:  r=sh;
            `ALU_SRA:  r=sh;
            `ALU_SLL:  r=sh;
            // slt & sltu
            `ALU_SLT:  r = {31'b0,(sf != vf)};
            `ALU_SLTU:  r = {31'b0,(~cf)};
        endcase
    end
endmodule
