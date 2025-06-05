`timescale 1ns / 1ps
////////////////////////////////////////////////
// TESTBENCH.V
//
// TU/e Eindhoven University Of Technology
// Eindhoven, The Netherlands
// 
// Created: 21-11-2013
// Author: Bergmans, G (g.bergmans@student.tue.nl)
// Based on work by Sander Stuijk
// 
// Function:
//  Combines the mMIPS with simulated RAM, ROM and Device handler
//  for simulation purposes
//
// Version:
//     (27-01-2014): initial version
//
//////////////////////////////////////////////!/

`include "mmips_defines.v"

module testbench();
    
parameter delay10=20;
    reg clk, en, rst;
    wire dev_wdata;
    wire [31:0] dev_dout;
   
    integer f,l;
 
    integer cycles;
    integer clkgen;
    
    mMIPS_system sys_inst(
        .clk(clk),
        .en(en),
        .rst(rst),
	.dev_wdata(dev_wdata),
	.dev_dout(dev_dout)
    );
   
`ifdef SYNTH
   initial
   $sdf_annotate("../synthesis/gate/mMIPS_sim.sdf",sys_inst,,,"MAXIMUM");
`endif
`ifdef PNR
   initial
   $sdf_annotate("../p+r/data_out/optRoute.sdf",sys_inst,,,"MAXIMUM");
`endif


 
    //Reset and init
    initial begin
	// Read Memory
	//
	$readmemh("ram.hex",sys_inst.dmem.u_mem.mem);
	$readmemh("rom.hex",sys_inst.imem.u_mem.mem);
        clkgen = 0;
        cycles = 0;
        
        //Enable the system
        en = 1;
        #1
        
        //Reset the system
        rst = 1;
        clk = 0;
        #50 //Period/2
        #50 //Period/2
        rst = 0;
        clkgen = 1;
    end
    
    always @(negedge clk) begin
	if (dev_wdata) begin
		$display("<%c%c%c%c> at cycle number %d",dev_dout[31:24],dev_dout[23:16],dev_dout[15:8],dev_dout[7:0],cycles);
	end
    end
    always begin 
    	#(delay10/2.0) clk = ~clk;

	end 	
    always @(posedge clk) begin
        if (clkgen == 1) begin
            cycles = cycles + 1;
	    if (cycles > 1000) begin
                f = $fopen("ram.dump.hex","w");
                for (l=0; l<256; l=l+1) begin $fwrite(f,"%08x\n",sys_inst.dmem.u_mem.mem[l]); end
                $fclose(f);
		$display("< %d is Period Finish after 1000 clock cycles >",delay10); 
		$finish();
	    end
        end
        else
            #1 cycles = 0;
    end

endmodule
