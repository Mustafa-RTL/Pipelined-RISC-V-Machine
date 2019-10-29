`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 03:02:58 PM
// Design Name: 
// Module Name: data_path
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module data_path2(input clk, input rst);
 
 
 //PC wiring     
    wire [31:0]PC_in;  
    wire [31:0]PC_out;
    register program_counter (clk, PC_in, rst, 1'b1, PC_out);
    
    
  //instruction memory wiring  
    
    
    wire [31:0]inst_out;
    InstMem inst_mem ((PC_out >> 2), inst_out);
    
    
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
    
    wire [31:0]read_data_1;
   
    wire [31:0]read_data_2;    
    
    RegFile reg_file (clk, rst, inst_out[19:15], inst_out[24:20], inst_out[11:7], write_data, regwrite, read_data_1, read_data_2);
    
    
    //immediate generator wiring
  
    wire [31:0]imm_out;
 
    rv32_ImmGen IG (inst_out, imm_out);
    
    
    //the mux that determines the second source for ALU wiring
    
    wire [31:0]alu_mux_out;
  
    multiplexer alu_mux (read_data_2, imm_out, alusrc, alu_mux_out);
    
    
    //new added mux wiring (1)
        
     wire [31:0]pc_gen_out;
     wire [31:0]pc_inc_out;
     wire [31:0] c1;
     wire [31:0] d1;
     assign d1=32'b0; // to avoid floating input
        
   mux_4x1 mux0(.a(pc_gen_out), .b(pc_inc_out), .c(c1), .d(d1), .sel(regwritesrc), .y(write_data));     
            
   
    wire [31:0]alu_out;
 
    prv32_ALU alu (read_data_1, alu_mux_out, alu_out, cf,zf,vf,sf,alufn,shamt);
    
    
    wire [31:0]data_mem_out;
    
    DataMem data_mem (clk, alu_out, memwrite, memread, memsizesel[1], memsizesel[0], read_data_2, data_mem_out); // shift adr not readdata
    
    multiplexer wb (alu_out, data_mem_out, memtoreg,c1);
    
    
    //immediate shifter wiring
    wire [31:0]shift_out;
    shift pc_shift (imm_out, shift_out);
    
    
    //branch target adder wiring
   
    wire dummy_carry;
    ripple pc_gen (PC_out, shift_out, pc_gen_out, dummy_carry);
    
    //new mux(2) wiring
    mux_4x1 mux1(.a(pc_inc_out), .b(pc_gen_out), .c(alu_out), .d(d1), .sel(regwritesrc), .y(write_data));   
 
    //pc increment wiring
    wire dummy_carry_2;
    ripple pc_inc (PC_out, 4'b100, pc_inc_out, dummy_carry_2);
    
   

endmodule
