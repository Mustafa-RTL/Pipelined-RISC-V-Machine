`timescale 1ns / 1ps
/******************************************************************* *
*	Module: module_name.v
*	Project: Single Cycle RISC-V
*	Author: Haitham,Kareem Alansary, Mahmoud Ghidan, Moustafa Mahmoud
*	Description:
*	Change history: 28/10/2019 Created module data_path (Haitham)
*			28/10/2019-29/10/2019 Debbugging and submission
*			(group)
*			5/11/2019 Re-worte entire module (Kareem, Mahmoud)
**********************************************************************/
module data_path(input clk, input rst);
 
 
 //PC wiring     
    wire [31:0]pc_in;  
    wire [31:0]pc_out;
    pc program_counter (clk.(clk), pc_in.(pc_in), rst.(rst), pc_out.(pc_out));
    
    
  //instruction memory wiring  
    
    
    wire [31:0]inst_out;
    InstMem inst_memory (.(pc_out >> 2)(addr), .inst_out(data_out)); //>> 2
    
    
    //control unit wiring
   
    wire  memread, memtoreg, memwrite, alusrc, regwrite;
    wire [1:0]regwritesrc;
     wire[1:0] jorbranch;
     wire [1:0]memsizesel;
     wire [3:0]alufn;
    wire cf,zf,vf,sf;
    wire [5:0]shamt;
   
    CU controlUnit (.IR(inst_out), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(alufn), .jorbranch(jorbranch), .regwritesrc(regwritesrc), .memread(memread),.memtoreg(memtoreg),.memwrite(memwrite),.alusrc(alusrc),.regwrite(regwrite), .memsizesel(memsizesel), .shamt(shamt));
    
    //regfile wiring
    
    wire [31:0]write_data;
    
    wire [31:0]rs1;
   
    wire [31:0]rs2;    
    
    RegFile reg_file (.clk(clk), .rst(rst), .rs1_addr(inst_out[19:15]), .rs2_addr(inst_out[24:20]), .writereg_addr(inst_out[11:7]),.writedata(write_data), .regwrite(regwrite), .rs1(rs1), .rs2(rs2));
    
    
    //immediate generator wiring
  
    wire [31:0]imm_out;
 
    rv32_ImmGen IG (.IR(inst_out), .Imm(imm_out));
    
    
    //the mux that determines the second source for ALU wiring
    
    wire [31:0]rs2_mux_out;
  
    mux_2x1 #(32) alu_in2_mux (.a(rs2), .b(imm_out), .sel(alusrc), .c(rs2_mux_out));
    
    
    //new added mux wiring (1)
        
     wire [31:0]pc_gen_out;
     wire [31:0]pc_inc_out;
     wire [31:0]wb_writedata;
     wire [31:0] d1;
     assign d1=32'b0; // to avoid floating input
        
   mux_4x1 mux0(.a1(pc_gen_out), .b1(pc_inc_out), .c2(wb_writedata), .d1(d1), .sel(regwritesrc), .y(write_data));     
            
   
    wire [31:0]alu_out;
 
    prv32_ALU alu (.rs1(a), .rs2_mux_out(b), .alu_out(r), .cf(cf),.zf(zf),.vf(vf),.sf(sf),.alufn(alufn),.shamt(shamt));
    
    
    wire [31:0]data_mem_out;
    
    Data_mem data_mem (.clk(clk), .alu_out(addr), .memwrite(MemWrite), .memread(MemRead), .memsizesel[1](HalfOperation), .memsizesel[0](ByteOperation), .rs2(data_write), .data_mem_out(data_read)); // shift adr not readdata
    
    mux_2x1 #(32) wb (.a(alu_out), .b(data_mem_out), .sel(memtoreg),.c(wb_writedata));
    
    
    //immediate shifter wiring
    wire [31:0]shift_out;
    shift_1_left pc_shift (.imm_out(in), .shift_out(out));
    
    
    //branch target adder wiring
   
    wire dummy_carry;
    N_bit_RCA #(32) pc_gen (.pc_out(operand_a), .shift_out(operand_b), .pc_gen_out(sum), .dummy_carry(cout));
    
    //new mux(2) wiring
    mux_4x1 mux1(.a1(pc_inc_out), .b1(pc_gen_out), .c1(alu_out), .d1(d1), .sel(jorbranch), .y(pc_in));   
 
    //pc increment wiring
    wire dummy_carry_2;
    N_bit_RCA #(32) pc_inc (.pc_out(operand_a), .32'd4(operand_b), .pc_inc_out(sum), .dummy_carry_2(cout));
    
   

endmodule
