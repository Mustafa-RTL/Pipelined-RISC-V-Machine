`timescale 1ns / 1ps



module FA(
    input operand_a,operand_b,cin,
    output sum,cout
    );
    
    assign cout = (operand_a & operand_b) | (operand_b & cin) | (cin & operand_a);
    assign sum = operand_a ^ operand_b ^ cin;
endmodule
