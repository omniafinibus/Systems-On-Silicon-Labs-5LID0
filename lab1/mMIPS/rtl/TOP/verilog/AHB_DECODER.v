`include "mmips_defines.v"
module AHB_DECODER(
	input 	[31:0]	HADDR,
	output  	HSEL_RAM,
	output  	HSEL_AES,
	output  	HSEL_INT
);
	assign HSEL_RAM = ((HADDR & `CASEMASK) == `RAMCASE);
	assign HSEL_AES = ((HADDR & `CASEMASK) == `AESCASE);
	assign HSEL_INT = ((HADDR & `CASEMASK) == `INTCASE);
			
endmodule
