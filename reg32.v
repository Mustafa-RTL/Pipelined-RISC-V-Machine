module reg32(
    input clk,
    input rst,
    input load,
    input [31:0] in,
    output wire [31:0] out
    );
    wire [31:0] D;
    genvar i;
    generate
        for (i=0; i<32; i=i+1)
        begin:FFs
            mux2x1 a(out[i], in[i], load, D[i]);
            DFlipFlop b(clk, rst, D[i], out[i]);
        end
    endgenerate
endmodule
