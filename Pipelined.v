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

    //Mem Wiring
    wire [31:0]data_mem_out;
    wire [31:0] address;
    //immediate shifter wiring
    wire [31:0]shift_out;
    
    //Moderator
    wire tick_tock;
    
    //branch_crtl
    wire [2:0] branch_type;
    wire [1:0] pc_mux_ctrl;
    wire pc_inc_or_branch;
    wire [31:0] branch_pc;
    
    //for pipelining
    wire [31:0] IF_ID_pc_inc, IF_ID_PC, IF_ID_Inst_writeData;
    
    N_bit_reg #(96) IF_ID (.clk(clk),.rst(rst),.load(1'b1),.D({pc_inc_out, pc_out, data_mem_out}),.Q({IF_ID_pc_inc, IF_ID_PC, IF_ID_Inst_writeData}));
    
    wire [31:0] ID_EX_pc_inc, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
    wire [12:0] ID_EX_Ctrl;//jorbranch, branch_type, memsizesel, memread,memwrite,memtoreg,regwrite, regwritesrc
    wire [3:0] ID_EX_alufunc;
    wire ID_EX_alusrc;
    wire [5:0] ID_EX_shamt;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    
    N_bit_reg #(199) ID_EX (.clk(clk),.rst(rst),.load(1'b1)
    ,.D({IF_ID_pc_inc, IF_ID_PC, rs1, rs2, imm_out, jorbranch, branch_type, memsizesel, memread, memwrite, memtoreg, regwrite, regwritesrc, alufn, alusrc, shamt, IF_ID_Inst_writeData[19:15], IF_ID_Inst_writeData[24:20], IF_ID_Inst_writeData[11:7]})
    ,.Q({ID_EX_pc_inc, ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm, ID_EX_Ctrl, ID_EX_alufunc, ID_EX_alusrc, ID_EX_shamt,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd}));


     //Rs1 and Rs2 are needed later for the forwarding unit
    wire [31:0] EX_MEM_pc_inc, EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
    wire [3:0] EX_MEM_Ctrl;// memtoreg,regwrite,regwritesrc
    wire [4:0] EX_MEM_Rd;
    wire [1:0] EX_MEM_jorbranch;
    wire [2:0] EX_MEM_branch_type;
    wire [1:0] EX_MEM_memsizesel;
    wire EX_MEM_memread;
    wire EX_MEM_memwrite;
    wire EX_MEM_cf,EX_MEM_zf,EX_MEM_vf,EX_MEM_sf;
    N_bit_reg #(150) EX_MEM (.clk(clk),.rst(rst),.load(1'b1),
     .D({ID_EX_pc_inc, pc_gen_out, alu_out, ID_EX_RegR2, ID_EX_Rd, ID_EX_Ctrl, cf,zf,vf,sf}),
     .Q({EX_MEM_pc_inc, EX_MEM_BranchAddOut,
     EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_jorbranch, EX_MEM_branch_type, EX_MEM_memsizesel, EX_MEM_memread, EX_MEM_memwrite, EX_MEM_Ctrl, EX_MEM_cf,EX_MEM_zf,EX_MEM_vf,EX_MEM_sf}));
   
    wire [31:0] MEM_WB_pc_inc, MEM_WB_BranchAddOut, MEM_WB_branch_pc, MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [1:0] MEM_WB_regwrite_src;
    wire MEM_WB_memtoreg;
    wire MEM_WB_regwrite;
    wire [4:0] MEM_WB_Rd;
    wire [1:0] MEM_WB_pc_mux_ctrl;
    N_bit_reg #(171) MEM_WB (.clk(clk),.rst(rst),.load(1'b1),
     .D({pc_mux_ctrl, EX_MEM_Ctrl, EX_MEM_pc_inc, branch_pc, EX_MEM_BranchAddOut, data_mem_out, EX_MEM_ALU_out, EX_MEM_Rd}),
     .Q({MEM_WB_pc_mux_ctrl, MEM_WB_memtoreg, MEM_WB_regwrite, MEM_WB_regwrite_src, MEM_WB_pc_inc, MEM_WB_branch_pc, MEM_WB_BranchAddOut, MEM_WB_Mem_out, MEM_WB_ALU_out,
     MEM_WB_Rd}));

    
    assign pc_inc_or_branch = MEM_WB_pc_mux_ctrl[0] | MEM_WB_pc_mux_ctrl[1];

    
    mux_2x1 #(32) pc_or_branch(.a(pc_inc_out), .b(MEM_WB_branch_pc), .sel(pc_inc_or_branch),.c(pc_in));
   
    
    pc program_counter (.clk(clk), .pc_in(pc_in), .tick_tock(tick_tock), .rst(rst), .pc_out(pc_out));
    
    
    CU controlUnit (.tick_tock(tick_tock), .IR(IF_ID_Inst_writeData), .alufn(alufn), .branch_type(branch_type), .jorbranch(jorbranch), .regwritesrc(regwritesrc), .memread(memread),.memtoreg(memtoreg),.memwrite(memwrite),.alusrc(alusrc),.regwrite(regwrite), .memsizesel(memsizesel), .shamt(shamt));
    
       
    RegFile reg_file (.clk(clk), .rst(rst), .tick_tock(tick_tock), .rs1_addr(IF_ID_Inst_writeData[19:15]), .rs2_addr(IF_ID_Inst_writeData[24:20]), .writereg_addr(MEM_WB_Rd),.writedata(write_data), .regwrite(MEM_WB_regwrite), .rs1(rs1), .rs2(rs2));
    
 
    rv32_ImmGen IG (.tick_tock(tick_tock), .IR(IF_ID_Inst_writeData), .Imm(imm_out));

  
    //the mux that determines the second source for ALU
    mux_2x1 #(32) alu_in2_mux (.a(ID_EX_RegR2), .b(ID_EX_Imm), .sel(ID_EX_alusrc), .c(rs2_mux_out));
    
    
    wire [31:0] d1;
    assign d1=32'b0; // to avoid floating input**************************************************************
    mux_4x1 wb_mux(.a1(MEM_WB_BranchAddOut), .b1(MEM_WB_pc_inc), .c1(wb_writedata), .d1(d1), .sel(MEM_WB_regwrite_src), .y(write_data));     
            
 
    prv32_ALU alu (.a(ID_EX_RegR1), .b(rs2_mux_out), .r(alu_out), .cf(cf),.zf(zf),.vf(vf),.sf(sf),.alufn(ID_EX_alufunc),.shamt(ID_EX_shamt));
   
    
    mux_2x1 #(32) mem_mux(.a(pc_out), .b(EX_MEM_ALU_out), .sel(tick_tock), .c(address));
    
    
    Memory memory_module(.clk(clk), .tick_tock(tick_tock), .addr(address), .MemWrite(EX_MEM_memwrite), .MemRead(EX_MEM_memread), .HalfOperation(EX_MEM_memsizesel[1]), .ByteOperation(EX_MEM_memsizesel[0]), .data_write(EX_MEM_RegR2), .data_read(data_mem_out)); // shift adr not readdata
    
    
    mux_2x1 #(32) before_wb(.a(MEM_WB_ALU_out), .b(MEM_WB_Mem_out), .sel(MEM_WB_memtoreg),.c(wb_writedata));  //write data mux
    
    
    shift_1_left pc_shift (.in(ID_EX_Imm), .out(shift_out));
    
    
    branch_ctrl BCU(.jorbranch(EX_MEM_jorbranch), .branch_type(EX_MEM_branch_type), .cf(EX_MEM_cf), .zf(EX_MEM_zf), .vf(EX_MEM_vf), .sf(EX_MEM_sf), .pc_mux_ctrl(pc_mux_ctrl));
    
    
    Moderator Maestro(.clk(clk), .rst(rst), .tick_tock(tick_tock));
    
    
    //branch target adder
    wire dummy_carry;
    N_bit_RCA #(32) pc_gen (.operand_a(ID_EX_PC), .operand_b(shift_out), .sum(pc_gen_out), .cout(dummy_carry));
    
    
    //pc mux
    mux_2x1 branching_mux(.a(EX_MEM_ALU_out), .b(EX_MEM_BranchAddOut), .sel(pc_mux_ctrl[0]), .c(branch_pc));   
 
    
    //pc increment adder
    wire dummy_carry_2;
    N_bit_RCA #(32) pc_inc (.operand_a(pc_out), .operand_b(32'd4), .sum(pc_inc_out), .cout(dummy_carry_2));
    

endmodule
