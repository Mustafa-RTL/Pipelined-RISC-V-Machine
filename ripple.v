
module ripple(input [7:0]a, input [7:0]b, output [7:0]out, output cout);
    wire [8:0]carry;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            FA adder(a[i], b[i], carry[i], out[i], carry[i+1]);
        end 
    endgenerate
    assign cout = carry[8];
endmodule

