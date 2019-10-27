`include "defines.v"

/*******************************************************************
*
* Module: CU.v
* Project: Single Cycle RISC-V
* Author: Mustafa Mahmoud mustafamohammed_auc@aucgypt.edu
* Description: This is the control unit of the RISC-V single
              cycle machine.
              **Module still missing data memory size select input**
*
* Change history: 26/10/2019 – File Created
*
**********************************************************************/

module CU(
    input [31:0] IR,
    input        cf, zf, vf, sf,
    output reg [3:0] alufn,
    output reg [1:0] jorbranch,
    output reg [1:0] regwritesrc,
    output reg memread,memtoreg,memwrite,alusrc,regwrite
    );
always @(*)
begin
    case(`OPCODE)
    `OPCODE_Branch:
    begin
      alufn = `ALU_SUB;
      regwritesrc = 2'b10; //write register source is the default
      memread = 1'b0;
      memtoreg = 1'b0;
      memwrite = 1'b0;
      alusrc = 1'b0;
      regwrite = 1'b0;
      case(IR[`IR_funct3])
      `BR_BEQ:
      begin
        if (zf)
          jorbranch = 2'b01;  //branch
        else
          jorbranch = 2'b00; //pc+4
      end

      `BR_BNE:
      begin
        if (~zf)
          jorbranch = 2'b01;  //branch
        else
          jorbranch = 2'b00; //pc+4
      end

      `BR_BLT:
      begin
        if (sf != vf)
          jorbranch = 2'b01;  //branch
        else
          jorbranch = 2'b00; //pc+4
      end

      `BR_BGE:
      begin
        if (sf = vf)
          jorbranch = 2'b01;  //branch
        else
          jorbranch = 2'b00; //pc+4
      end

      `BR_BLTU:
      begin
        if (~cf)
          jorbranch = 2'b01;  //branch
        else
          jorbranch = 2'b00; //pc+4
      end

      `BR_BGEU:
      begin
        if (cf)
          jorbranch = 2'b01;  //branch
        else
          jorbranch = 2'b00; //pc+4
      end
      endcase
    end

    `OPCODE_Load:
    begin
      alufn = `ALU_ADD;
      jorbranch = 2'b00;
      regwritesrc = 2'b10;
      memread = 1'b1;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b1;
      regwrite = 1'b1;
    end

    `OPCODE_Store:
    begin
      alufn = `ALU_ADD;
      jorbranch = 2'b00;
      regwritesrc = 2'b10;
      memread = 1'b0;
      memtoreg = 1'b0;
      memwrite = 1'b1;
      alusrc = 1'b1;
      regwrite = 1'b0;
    end

    `OPCODE_JALR:
    begin
      alufn = `ALU_ADD;
      jorbranch = 2'b10;
      regwritesrc = 2'b01;
      memread = 1'b0;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b1;
      regwrite = 1'b1;
    end

    `OPCODE_JAL:
    begin
      alufn = `ALU_ADD;
      jorbranch = 2'b01;
      regwritesrc = 2'b01;
      memread = 1'b0;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b1;
      regwrite = 1'b1;
    end

    `OPCODE_Arith_I:
    begin

    end

    `OPCODE_Arith_R:
    begin

    end

    `OPCODE_AUIPC:
    begin
      alufn = `ALU_ADD;
      jorbranch = 2'b00;
      regwritesrc = 2'b00;
      memread = 1'b0;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b0;
      regwrite = 1'b1;
    end

    `OPCODE_LUI:
    begin
      alufn = `ALU_PASS;
      jorbranch = 2'b00;
      regwritesrc = 2'b10;
      memread = 1'b0;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b1;
      regwrite = 1'b1;
    end

    default://NOP
    begin
      alufn = `ALU_PASS;
      jorbranch = 2'b00;
      regwritesrc = 2'b10;
      memread = 1'b0;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b0;
      regwrite = 1'b0;
    end
    endcase
end
endmodule
