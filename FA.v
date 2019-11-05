`timescale 1ns / 1ps



module FA(
    input operand_a,operand_b,cin,
    output sum,cout
    );
    
    assign cout = (a&b) | (b&cin) | (cin&a);
    assign sum = a ^ b ^ cin;
endmodule
