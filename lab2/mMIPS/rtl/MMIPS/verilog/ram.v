////////////////////////////////////////////////
// RAM.V
//
// TU/e Eindhoven University Of Technology
// Eindhoven, The Netherlands
// 
// Created: 03-12-2013
// Author: Bergmans, G (g.bergmans@student.tue.nl)
// Based on work by Sander Stuijk
// 
// Function:
//  RAM simulator
//
// Version:
//     (27-01-2014): initial version
//
//////////////////////////////////////////////!/

`include "mmips_defines.v"

module ram(
        clk,
        enable,
        ram_dout,
        ram_wait,
        ram_din,
        ram_addr,
        ram_r,
        ram_w
    );
    
    
    input           clk;
    input           enable;
    output  [31:0]  ram_dout;
    reg     [31:0]  ram_dout;
    output          ram_wait;
    input   [31:0]  ram_din;
    input   [31:0]  ram_addr;
    input   [1:0]   ram_r;
    input   [1:0]   ram_w;

    
    reg     [31:0]  addr;
    //reg     [8:0]   bramaddr;
    reg     [1:0]   byteselect_before;
    reg     [1:0]   byteselect;
    reg             lblw;
    reg             lblwout;
    reg     [1:0]   w;
    reg     [1:0]   r;
    
    wire signed [31:0] DOA;
    reg                ENA;
    //reg         [13:0] ADDR;
    reg         [7:0] ADDR; //Size of 256
    reg         [3:0]  WEA;
    wire	       WE;
    reg  signed [31:0] DI;
    reg  signed [31:0] din;
    wire               CLK;
    
    assign WE = | WEA;    
    //assign ram_dout = DOA[bramid];
    assign ram_wait = 1'b0;
    
    //Zeros for bram modules
    
    assign CLK = !clk;
    
    initial begin
        addr = 0;
        r = 0;
        w = 0;
        lblw = 0;
    end
    
    //Handle read requests
    always @(posedge(clk))
    begin
        if (enable) begin
            //Mask for memory map
            addr = ram_addr & `RAMMASK;
            //Before updating!
            if (r == 2'b10)
                lblw = 1;
            else
                lblw = 0;
            r = ram_r;
            w = ram_w;
	    din = ram_din;
            byteselect = byteselect_before;
        end
    end
    
    always @(addr or w or r or din) 
    begin
        if (enable) begin
            if (addr < `RAMSIZE)
            begin
                byteselect_before = addr[1:0];
                //bramaddr = addr[10:2];
                //bramid = addr[31:11];
                
                //ADDR = {bramaddr, 5'b00000};
                ADDR = addr[9:2];
                DI = din;
                
                //Write word
                if (w == 2'b01)
                    WEA = 4'b1111;
                else begin
		    // cadence translate_off
		    $display("Attention! selective byte write operations are not supported");
		    // cadence translate_on
                    if (w == 2'b10)
                    begin
                        //Also shift DIA. The byte to be written is always the 8 least significant bits. Shift to right memloc
                        case(byteselect_before)
                        2'b00: begin
                            WEA = 4'b1000; 
                            DI = DI << 24; 
                            end
                        2'b01: begin 
                            WEA = 4'b0100;
                            DI = DI << 16;
                            end
                        2'b10: begin
                            WEA = 4'b0010; 
                            DI = DI << 8;
                            end
                        2'b11: begin
                            WEA = 4'b0001; 
                            DI = DI << 0;
                            end
                        endcase
                    end
                    else
                        WEA = 4'b0000;
                end
                //Enable mem for read/write
                //if ((w || r) && bramid < RAM_BRAM) 
                if (w || r) 
                    ENA = 1;
                else
		    ENA = 0;
            end
        end
    end
    
    //Output
    //always @(DOA or byteselect or bramid or lblw or addr)
    always @(DOA or byteselect or lblw or addr)
    begin
        if (lblw)
        begin
            case (byteselect)
            2'b00: ram_dout = {24'b0000000000000000, DOA[31:24]};
            2'b01: ram_dout = {24'b0000000000000000, DOA[23:16]};
            2'b10: ram_dout = {24'b0000000000000000, DOA[15: 8]};
            2'b11: ram_dout = {24'b0000000000000000, DOA[ 7: 0]};
            endcase
        end
        else
            ram_dout = DOA;
    end
	MEM1_256X32	SRAM_MEMORY(.CK(CLK),.Q(DOA),.CE(ENA),.WE(WE),.A(ADDR),.D(DI));

    
endmodule
