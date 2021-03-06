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
*                 27/10/2019 – Added JALR, JAL, LUI, AUIPC, NOP
*                 28/10/2019 – CU completed
                  10/11/2019 - Edited for Pipelining
**********************************************************************/

module CU(
    input [31:0] IR,
    output reg [3:0] alufn,
    output reg [1:0] jorbranch,
    output reg [2:0] branch_type,
    output reg [1:0] regwritesrc,
    output reg memread,memtoreg,memwrite,alusrc,regwrite,
    output reg [1:0] memsizesel,
    output reg [5:0] shamt
    );
always @(*)
begin
    shamt = 6'b0;   //default no shift
    memsizesel = 2'b00; // default size is one word
    branch_type = IR[`IR_funct3];
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
      jorbranch = `BRANCH;
    end

    `OPCODE_Load:
    begin
      alufn = `ALU_ADD;
      jorbranch = `NO_BRANCH;
      regwritesrc = 2'b10;
      memread = 1'b1;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b1;
      regwrite = 1'b1;
      case(IR[`IR_funct3])
      `F3_B:  memsizesel = 2'b01;
      `F3_H:  memsizesel = 2'b10;
      `F3_W:  memsizesel = 2'b00;
      `F3_BU: memsizesel = 2'b01;
      `F3_HU: memsizesel = 2'b10;
      default:  memsizesel = 2'b00;
      endcase
    end

    `OPCODE_Store:
    begin
      alufn = `ALU_ADD;
      jorbranch = `NO_BRANCH;
      regwritesrc = 2'b10;
      memread = 1'b0;
      memtoreg = 1'b0;
      memwrite = 1'b1;
      alusrc = 1'b1;
      regwrite = 1'b0;
      case(IR[`IR_funct3])
      `F3_B:  memsizesel = 2'b01;
      `F3_H:  memsizesel = 2'b10;
      `F3_W:  memsizesel = 2'b00;
      `F3_BU: memsizesel = 2'b01;
      `F3_HU: memsizesel = 2'b10;
      default:  memsizesel = 2'b00;
      endcase
    end

    `OPCODE_JALR:
    begin
      alufn = `ALU_ADD;
      jorbranch = `JALR;
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
      jorbranch = `JAL;
      regwritesrc = 2'b01;
      memread = 1'b0;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b1;
      regwrite = 1'b1;
    end

    `OPCODE_Arith_I:
    begin
      shamt = {1'b0, IR[`IR_rs2]};
      case(IR[`IR_funct3])
      `F3_ADD:  alufn = `ALU_ADD;
      `F3_SLL:  alufn = `ALU_SLL;
      `F3_SLT:  alufn = `ALU_SLT;
      `F3_SLTU:  alufn = `ALU_SLTU;
      `F3_XOR:  alufn = `ALU_XOR;
      `F3_SRL:
      begin
        if (IR[`IR_funct7] == 7'b0)
          alufn = `ALU_SRL;
        else
          alufn = `ALU_SRA;
      end
      `F3_OR:  alufn = `ALU_OR;
      `F3_AND:  alufn = `ALU_AND;
      default:  alufn = `ALU_PASS;
      endcase
      jorbranch = `NO_BRANCH;
      regwritesrc = 2'b10;
      memread = 1'b0;
      memtoreg = 1'b0;
      memwrite = 1'b0;
      alusrc = 1'b1;
      regwrite = 1'b1;
    end

    `OPCODE_Arith_R:
    begin
      shamt = 6'd32;
      case(IR[`IR_funct3])
      `F3_ADD:
      begin
        if (IR[`IR_funct7] == 7'b0)
          alufn = `ALU_ADD;
        else
          alufn = `ALU_SUB;
      end
      `F3_SLL:  alufn = `ALU_SLL;
      `F3_SLT:  alufn = `ALU_SLT;
      `F3_SLTU:  alufn = `ALU_SLTU;
      `F3_XOR:  alufn = `ALU_XOR;
      `F3_SRL:
      begin
        if (IR[`IR_funct7] == 7'b0)
          alufn = `ALU_SRL;
        else
          alufn = `ALU_SRA;
      end
      `F3_OR:  alufn = `ALU_OR;
      `F3_AND:  alufn = `ALU_AND;
      default:  alufn = `ALU_PASS;
      endcase
      jorbranch = `NO_BRANCH;
      regwritesrc = 2'b10;
      memread = 1'b0;
      memtoreg = 1'b0;
      memwrite = 1'b0;
      alusrc = 1'b0;
      regwrite = 1'b1;
    end

    `OPCODE_AUIPC:
    begin
      alufn = `ALU_ADD;
      jorbranch = `NO_BRANCH;
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
      jorbranch = `NO_BRANCH;
      regwritesrc = 2'b10;
      memread = 1'b0;
      memtoreg = 1'b1;
      memwrite = 1'b0;
      alusrc = 1'b1;
      regwrite = 1'b1;
    end

    default: //NOP
    begin
      alufn = `ALU_PASS;
      jorbranch = `NO_BRANCH;
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
