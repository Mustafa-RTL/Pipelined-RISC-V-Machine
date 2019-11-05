
module N_bit_RCA # (parameter N=32) (
	input [N-1:0]operand_a,
	input [N-1:0]operand_b,
	output [N-1:0]sum,
	output cout);
    
    wire [N:0]carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin:adder
            FA adder(.operand_a(operand_a[i]), .operand_b(operand_b[i]), .cin(carry[i]), .sum(sum[i]), .cout(carry[i+1]));
        end 
    endgenerate
    assign cout = carry[N];
endmodule

