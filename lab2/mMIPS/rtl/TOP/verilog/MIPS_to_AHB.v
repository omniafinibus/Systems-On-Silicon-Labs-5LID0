////////////////////////////////////////////////////////////////
//// MMIPS_to_AHB the interface of the texbook MMIPS processor /////
//// To the realistic memory and other devices over AMBA AHB Bus/////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
//// Author: Paul Detterer /////////////////////////////////////
//// Date:   24/3/2018     /////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

`include "mmips_defines.v"

module MIPS_to_AHB(
//      MIPS Interface
	input 		HCLK,
        output 		wait_out,
	input 		HRESETn,
	output [31:0]	rom_dout_out,
	output 		rom_wait_out,
	input  [31:0]	rom_addr_in,
	input  [1:0]	rom_r_in,
	output [31:0]	ram_dout_out,
	output 		ram_wait_out,
	input  [31:0]	ram_din_in,
	input  [31:0]	ram_addr_in,
	input  [1:0]	ram_r_in,
	input  [1:0]    ram_w_in,
//	APB Master Interface
	output [31:0]	HADDRI,
	output 		HWRITEI,
	output [1:0]	HTRANSI,
	output [2:0]	HSIZEI,
	output [31:0]	HWDATAI,
	input  [31:0]	HRDATAI,
	input		HRESPI,
	input		HREADYOUTI,
	output [31:0]	HADDRD,
	output 		HWRITED,
	output [1:0]	HTRANSD,
	output [2:0]	HSIZED,
	output [31:0]	HWDATAD,
	input  [31:0]	HRDATAD,
	input		HRESPD,
	input		HREADYOUTD
);

	wire 		MIPS_writes_data;
	wire 		MIPS_reads_data;
	wire 		MIPS_reads_instruction;
	reg  		stall_MIPS;
	reg	[31:0]	MIPS_ram_din_prev;
	reg	[31:0]  HADDRD_hold;
	reg	[1:0]	HTRANSD_hold;
	reg		MIPS_reads_data_hold;


	

	assign MIPS_writes_data = | ram_w_in;
	assign MIPS_reads_data = | ram_r_in;

	always @(posedge HCLK or negedge HRESETn)
		if(!HRESETn)
			MIPS_reads_data_hold <= 0;
		else if ( ~HREADYOUTD)
			MIPS_reads_data_hold <= MIPS_reads_data_hold;
		else
			MIPS_reads_data_hold <= MIPS_reads_data;

			

	assign MIPS_data_transfer = MIPS_reads_data | MIPS_writes_data; 

	assign MIPS_reads_instruction = | rom_r_in;

	assign wait_out = 0;//~(HREADYOUTD & HREADYOUTI); // Stall MIPS if write is not ready
	

	// 
	//*****************Instruction Bus
	//
	assign HWRITEI = 0; // We never write in instruction memory	
	assign HTRANSI = {MIPS_reads_instruction, 1'b0}; // Always nonseq instruction read
	assign HSIZEI = 3'b010; // Always Word reads
	assign rom_dout_out = HRDATAI;
	assign HWDATAI = 32'h0; 
	assign HRESPI = 1'b0; // Always OKAY
	assign HREADYOUTI = 1'b1; // Always Ready
	assign HADDRI = rom_addr_in;
	assign rom_wait_out = ~HREADYOUTI;



	// 
	//*****************Data  Bus
	//
	
	assign HWRITED = MIPS_writes_data; 
	assign HSIZED = { ram_w_in | ram_r_in,1'b0}; // ATTENTION Could go wrong
	assign ram_dout_out = HRDATAD;

	
	
	always @(posedge HCLK or negedge HRESETn)
		if(~HRESETn)
			 HTRANSD_hold <= 0;
		else if ( ~HREADYOUTD)
			 HTRANSD_hold <= HTRANSD_hold;
		else
			 HTRANSD_hold <= {MIPS_data_transfer,1'b0};

	always @(posedge HCLK or negedge HRESETn)
		if(~HRESETn)
			 HADDRD_hold <= 0;
		else if ( ~HREADYOUTD)
			 HADDRD_hold <= HADDRD_hold;
		else
			 HADDRD_hold <= ram_addr_in;

	assign HADDRD = (HREADYOUTD | ~MIPS_reads_data_hold)?ram_addr_in:HADDRD_hold;
	assign HTRANSD = (HREADYOUTD | ~MIPS_reads_data_hold)?{MIPS_data_transfer,1'b0}:HTRANSD_hold;

	//Delay the data by 1 cycle
	always @(posedge HCLK or negedge HRESETn)
		if (!HRESETn)
			MIPS_ram_din_prev <= 32'h0;
		else
			MIPS_ram_din_prev <= ram_din_in;
	assign HWDATAD = MIPS_ram_din_prev; 
	assign ram_wait_out = ~HREADYOUTD;
	




endmodule
