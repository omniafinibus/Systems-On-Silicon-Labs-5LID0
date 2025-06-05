////////////////////////////////////////////////
// ROM.V
//
// TU/e Eindhoven University Of Technology
// Eindhoven, The Netherlands
// 
// Created: 03-12-2013
// Author: Bergmans, G (g.bergmans@student.tue.nl)
// Based on work by Sander Stuijk
// 
// Function:
//  Instruction memory simulator
//
// Version:
//     (27-01-2014): initial version
//
//////////////////////////////////////////////!/

`include "mmips_defines.v"

module rom(
        clk,
        enable,
        rom_dout,
        rom_wait,
        rom_addr,
        rom_r
    );
    
    
    input           clk;
    input           enable;
    output  [31:0]  rom_dout;
    output          rom_wait;
    input   [31:0]  rom_addr;
    input   [0:0]   rom_r;
    reg     [31:0]  addr;
    reg     [31:0]  out;
    
    wire signed [31:0] DO;
    wire signed [31:0] DI;
    reg                EN;
    reg         [7:0] ADDR;
    reg                CLKA;
    
    
    assign rom_dout = out;
    assign rom_wait = 1'b0;
    
    
    always @(clk)
    begin : clock
        CLKA = !clk;
    end
    
    //Handle read requests
    always @(posedge(clk))
    begin
        if (enable) begin
            addr = rom_addr;
            //Make sure the address is word aligned
            addr = addr & 32'h000003FC;
            
            
            ADDR = addr[9:2];
            
            
            //Enable mem for read/write
            if (rom_r) begin
                EN = 1;
            end
	    else
		EN = 0;
        end
    end
    
    always @( DO )
    begin
        out = DO;
    end

    MEM1_256X32 memory_inst(.CK(CLKA), .Q(DO), .CE(EN), .WE(1'b0),.A(ADDR),.D(DI)); 
    /*(* rom_style = "block" *) reg     [7:0]   mem [0:`ROMSIZE]; //ROMSIZE is in bytes: dividing by 4 gives 32 bit words
    
    reg     [31:0]  addr;
    reg     [31:0]  out;
    
    assign rom_dout = out;
    assign rom_wait = 1'b0;
    
    //Read in the memory file
    initial begin
        $readmemh("../memory/rom/mips_rom.hex",mem,0,`ROMSIZE);
    end
    
    //Handle read requests
    always @(posedge(clk))
    begin
        if (enable && rom_r) begin
            addr = rom_addr;
            //Set addr to ROMSIZE range
            addr = addr % `ROMSIZE;
            //Make sure the address is word aligned
            addr = addr & 32'hFFFFFFFC;
            
            if (addr < `ROMSIZE)
            begin
                out = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
            end
        end
    end
    */
endmodule
