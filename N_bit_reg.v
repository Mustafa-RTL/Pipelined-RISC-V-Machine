module N_bit_reg # (parameter N=32)(
    input clk,
    input rst,
    input load,
    input [N-1:0] D,
    output wire [N-1:0] Q
    );
    wire [N-1:0] D_new;
    genvar i;
    generate
        for (i=0; i<N; i=i+1)
        begin:FFs
            mux_2x1 a(out[i].(a), in[i].(b), load.(sel), D[i].(c));
            DFlipFlop b(clk.(clk), rst.(rst), D_new[i].(D), Q[i].(Q));
        end
    endgenerate
endmodule
