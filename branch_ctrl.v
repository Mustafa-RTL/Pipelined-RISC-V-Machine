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
**********************************************************************/


module branch_ctrl(
    input [1:0] jorbranch,
    input [2:0] branch_type,
    input        cf, zf, vf, sf,
    output reg [1:0] pc_mux_ctrl
    );
    always @(*)
    begin
        case (jorbranch)
        `BRANCH:
        begin    
            pc_mux_ctrl = `NO_BRANCH; //pc+4
            case(branch_type)
            `BR_BEQ:
            begin
                if (zf)
                    pc_mux_ctrl = `BRANCH;  
            end

            `BR_BNE:
            begin
                if (~zf)
                    pc_mux_ctrl = `BRANCH;  
            end

            `BR_BLT:
            begin
                if (sf != vf)
                    pc_mux_ctrl = `BRANCH;  
            end

            `BR_BGE:
            begin
                if (sf == vf)
                    pc_mux_ctrl = `BRANCH;  
            end

            `BR_BLTU:
            begin
                if (~cf)
                    pc_mux_ctrl = `BRANCH;  
            end

            `BR_BGEU:
            begin
                if (cf)
                    pc_mux_ctrl = `BRANCH;  
            end
            //default: pc_mux_ctrl = `NO_BRANCH;
            endcase
        end
        `JAL:  pc_mux_ctrl = `BRANCH;
        `JALR: pc_mux_ctrl = `JALR;     //Take source from ALU
        default: pc_mux_ctrl = `NO_BRANCH;
        endcase
    end
endmodule