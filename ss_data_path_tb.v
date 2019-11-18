`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mustafa Mohammed
// 
// Create Date: 08/11/2019 12:11:50 AM
// Design Name: 
// Module Name: ss_data_path_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:     17/11/2019      adding verification
// 
//////////////////////////////////////////////////////////////////////////////////


module ss_data_path_tb();
reg clk,rst;
/*integer counter = 0;

wire [3:0] alufn;
wire [1:0] jorbranch;
wire [2:0] branch_type;
wire [1:0] regwritesrc;
wire memread,memtoreg,memwrite,alusrc,regwrite;
wire [1:0] memsizesel;
wire [5:0] shamt;

wire  [31:0] result;
wire cf, zf, vf, sf;*/
    
    Pipelined  cpu(clk, rst);
    
    /*CU cu(
    .tick_tock(cpu.tick_tock),
    .IR(cpu.memory_module.mem[counter-1]),
    .alufn(alufn),
    .jorbranch(jorbranch),
    .branch_type(branch_type),
    .regwritesrc(regwritesrc),
    .memread(memread),
    .memtoreg(memtoreg),
    .memwrite(memwrite),
    .alusrc(alusrc),
    .regwrite(regwrite),
    .memsizesel(memsizesel),
    .shamt(shamt)
    );*/
    
    /*prv32_ALU alu(
    .a(cpu.reg_file.reg_x1_x31[cpu.memory_module.mem[counter-1][19:15]]), .b(cpu.reg_file.reg_x1_x31[cpu.memory_module.mem[counter-1]]),
	.r(result),
	.cf(cf), .zf(zf), .vf(vf), .sf(sf),
	.alufn(alufn),
	.shamt(shamt)
    );
*/
    initial begin
        clk=0;
        rst=1;
        #25
        rst=0;
        forever #25 clk=~clk; 
    end
    
    
    /*always @(negedge cpu.tick_tock) begin: Verify_moderator_0
        counter = counter +1;
        #25
        if (cpu.data_mem_out != cpu.memory_module.mem[cpu.pc_out])
            $display("Fetching Error");
        
        if (cpu.MEM_WB_Rd != 5'b0)
            if (cpu.MEM_WB_regwrite && cpu.reg_file.reg_x1_x31[cpu.MEM_WB_Rd]!=cpu.write_data)
                $display("Writeback Error");
        
        if (result != cpu.alu_out || cf != cpu.cf || zf != cpu.zf || vf != cpu.vf || sf != cpu.sf)
            $display("ALU Error");
    end
    
    always @(posedge cpu.tick_tock) begin: Verify_moderator_1
        #25
        if (cpu.alufn != alufn |
            cpu.jorbranch != jorbranch |
            cpu.branch_type != branch_type |
            cpu.regwritesrc != regwritesrc |
            cpu.memread != memread |
            cpu.memtoreg != memtoreg |
            cpu.memwrite != memwrite |
            cpu.alusrc != alusrc |
            cpu.regwrite != regwrite |
            cpu.memsizesel != memsizesel |
            cpu.shamt != shamt)
            $display("CU Error");
        
        if (cpu.reg_file.reg_x1_x31[cpu.memory_module.mem[counter-1][19:15]]!=cpu.rs1 || cpu.reg_file.reg_x1_x31[cpu.memory_module.mem[counter-1]]!=cpu.rs2)
            $display("Regfile Decoding Error");
            
        if (cpu.EX_MEM_memread)
            if (cpu.memory_module.mem[counter-2] != cpu.data_mem_out)       //memory addressing has to be adjusted to the data segment part in the memory
                $display("Loading Error");
        if (cpu.EX_MEM_memwrite)
            if (cpu.reg_file.reg_x1_x31[cpu.memory_module.mem[counter-2][19:15]] != cpu.memory_module.mem[cpu.reg_file.reg_x1_x31[cpu.memory_module.mem[counter-2]]])
                $display("Storing Error");
    end*/
    
     
endmodule
