
module RegFile(
    input clk, rst,
    input [4:0] readreg1, readreg2, writereg,
    input [31:0] writedata,
    input regwrite,
    output [31:0] readdata1, readdata2
    );

    reg [31:0] load;
    wire [31:0] dataout[31:0];

    genvar i;
    generate
        for (i=1; i<32; i=i+1)
        begin:RegFile
            reg32 x(clk, rst, load[i], writedata, dataout[i]);
        end
    endgenerate

    reg32 x0(clk, rst, load[0], 32'd0, dataout[0]);

    assign readdata1 = dataout[readreg1];
    assign readdata2 = dataout[readreg2];

    always @(*)
    begin
        load = 0;
        if (regwrite)
          load[writereg] = 1;
    end

endmodule
