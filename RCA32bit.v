
module RCA32bit(
    input cin,
    input [31:0] A,
    input [31:0] B,
    output [31:0] sum,
    output cout
    );
    
    wire [32:0] c;
    
    assign c[0] = cin;
    assign cout = c[32];
    
    genvar i;
    generate
        for (i=0; i<32; i=i+1)
        begin:generated_blocks
            FA x(A[i], B[i], c[i], sum[i], c[i+1]);
        end
    endgenerate
    
endmodule
