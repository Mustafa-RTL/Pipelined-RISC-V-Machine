`timescale 1ns / 1ps
/******************************************************************* *
*	Module: data_path.v
*	Project: Single Cycle RISC-V
*	Author: Haitham,Kareem Alansary, Mahmoud Ghidan, Moustafa Mahmoud
*	Description:	The full data_path (integration) module
*	Change history: 28/10/2019 Created module data_path (Haitham)
*			28/10/2019-29/10/2019 Debbugging and submission	(group)
*			5/11/2019 Re-worte entire module (Kareem, Mahmoud)
*			6/11/2019 debugging and code check (Kareem, Mustafa)
**********************************************************************/
module Pipelined(input clk, input rst);


    //PC wiring     
    wire [31:0]pc_in;  
    wire [31:0]pc_out;
    
    //instruction memory wiring  
    wire [31:0]inst_out;
    
    //control unit wiring
    wire  memread, memtoreg, memwrite, alusrc, regwrite;
    wire [1:0]regwritesrc;
    wire[1:0] jorbranch;
    wire [1:0]memsizesel;
    wire [3:0]alufn;
    wire cf,zf,vf,sf;
    wire [5:0]shamt;

    //regfile wiring
    wire [31:0]write_data;
    wire [31:0]rs1;
    wire [31:0]rs2; 

    //immediate generator wiring
    wire [31:0]imm_out;

    //the mux that determines the second source for ALU wiring
    wire [31:0]rs2_mux_out;

    //new added mux wiring (1)
    wire [31:0]pc_gen_out;
    wire [31:0]pc_inc_out;
    wire [31:0]wb_writedata;

    //ALU wiring
    wire [31:0]alu_out;

    //Data Mem Wiring
    wire [31:0]data_mem_out;

    //immediate shifter wiring
    wire [31:0]shift_out;
    

    //for pipelining
    /* wire [31:0] IF_ID_PC, IF_ID_Inst;
    
    N_bit_reg #(64) IF_ID (clk,rst,1'b1,{pc_to_inst_mem, instruction_word},{IF_ID_PC, IF_ID_Inst} );
    
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
    wire [7:0] ID_EX_Ctrl;//aluop, branch,memreg,memtoreg,memwrite,alusrc,regwrite
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    
    N_bit_reg #(155) ID_EX (clk,rst,1'b1
    ,{aluop, branch,memreg,memtoreg,memwrite,alusrc,regwrite, IF_ID_PC, regfile_readdata_1, regfile_readdata_2, imm, IF_ID_Inst[30], IF_ID_Inst[14:12], IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7]}
    ,{ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd}); */


    /* Rs1 and Rs2 are needed later for the forwarding unit
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
    wire [4:0] EX_MEM_Ctrl;// branch,memreg,memtoreg,memwrite,regwrite
    wire [4:0] EX_MEM_Rd;
    wire EX_MEM_Zero;
    Reg_generic #(107) EX_MEM (clk_cpu,rst,1'b1,
     {ID_EX_Ctrl[5:2],ID_EX_Ctrl[0], pcmux_in2, zero_f, alu_result, ID_EX_RegR2, ID_EX_Rd},
     {EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Zero,
     EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd});
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [1:0] MEM_WB_Ctrl;//memtoreg,regwrite
    wire [4:0] MEM_WB_Rd;
    Reg_generic #(71) MEM_WB (clk_cpu,rst,1'b1,
     {EX_MEM_Ctrl[2],EX_MEM_Ctrl[0], datamem_out, EX_MEM_ALU_out, EX_MEM_Rd},
     {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
     MEM_WB_Rd});*/

    
    pc program_counter (.clk(clk), .pc_in(pc_in), .rst(rst), .pc_out(pc_out));
    
    
    InstMem inst_memory (.addr(pc_out >> 2), .data_out(inst_out)); //>> 2
    
    
    CU controlUnit (.IR(inst_out), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(alufn), .jorbranch(jorbranch), .regwritesrc(regwritesrc), .memread(memread),.memtoreg(memtoreg),.memwrite(memwrite),.alusrc(alusrc),.regwrite(regwrite), .memsizesel(memsizesel), .shamt(shamt));
    
       
    RegFile reg_file (.clk(clk), .rst(rst), .rs1_addr(inst_out[19:15]), .rs2_addr(inst_out[24:20]), .writereg_addr(inst_out[11:7]),.writedata(write_data), .regwrite(regwrite), .rs1(rs1), .rs2(rs2));
    
 
    rv32_ImmGen IG (.IR(inst_out), .Imm(imm_out));

  
    //the mux that determines the second source for ALU
    mux_2x1 #(32) alu_in2_mux (.a(rs2), .b(imm_out), .sel(alusrc), .c(rs2_mux_out));
    
    
    wire [31:0] d1;
    assign d1=32'b0; // to avoid floating input
    mux_4x1 mux0(.a1(pc_gen_out), .b1(pc_inc_out), .c1(wb_writedata), .d1(d1), .sel(regwritesrc), .y(write_data));     
            
 
    prv32_ALU alu (.a(rs1), .b(rs2_mux_out), .r(alu_out), .cf(cf),.zf(zf),.vf(vf),.sf(sf),.alufn(alufn),.shamt(shamt));
    
    
    Data_mem data_mem (.clk(clk), .addr(alu_out), .MemWrite(memwrite), .MemRead(memread), .HalfOperation(memsizesel[1]), .ByteOperation(memsizesel[0]), .data_write(rs2), .data_read(data_mem_out)); // shift adr not readdata
    
    
    mux_2x1 #(32) wb (.a(alu_out), .b(data_mem_out), .sel(memtoreg),.c(wb_writedata));  //write data mux
    
    
    shift_1_left pc_shift (.in(imm_out), .out(shift_out));
    
    
    //branch target adder
    wire dummy_carry;
    N_bit_RCA #(32) pc_gen (.operand_a(pc_out), .operand_b(shift_out), .sum(pc_gen_out), .cout(dummy_carry));
    
    //new mux(2) pc mux
    mux_4x1 mux1(.a1(pc_inc_out), .b1(pc_gen_out), .c1(alu_out), .d1(d1), .sel(jorbranch), .y(pc_in));   
 
    //pc increment adder
    wire dummy_carry_2;
    N_bit_RCA #(32) pc_inc (.operand_a(pc_out), .operand_b(32'd4), .sum(pc_inc_out), .cout(dummy_carry_2));
    

endmodule
