module AHB_MUX(
	input		HCLK,
	input 		HRESETn,
	input 		HSEL_AES,
	input 		HSEL_RAM,
	input		HSEL_INT,
	
	input			HREADYOUT_AES,
	input		[31:0]	HRDATA_AES,
	input			HRESP_AES,

	input 			HREADYOUT_RAM,
	input		[31:0]	HRDATA_RAM,
	input			HRESP_RAM,

	input 			HREADYOUT_INT,
	input		[31:0]	HRDATA_INT,
	input			HRESP_INT,

	output reg		HREADYOUT,
	output reg	[31:0]	HRDATA,
	output reg		HRESP
);

	// LATCH HSEL
	//
	reg hsel_ram_reg, hsel_aes_reg, hsel_int_reg;
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) 
		 begin
			hsel_int_reg <= 0;
			hsel_aes_reg <= 0;
			hsel_ram_reg <= 0;
		 end
		else
		 begin
			hsel_ram_reg <= HSEL_RAM;
			hsel_aes_reg <= HSEL_AES;
			hsel_int_reg <= HSEL_INT;
		 end	
	always @*
		if(hsel_ram_reg & ~hsel_aes_reg & ~hsel_int_reg)
		  begin
			HRESP=HRESP_RAM;
			HRDATA=HRDATA_RAM;
			HREADYOUT=HREADYOUT_RAM;
		  end
		else if (hsel_aes_reg & ~hsel_ram_reg & ~hsel_int_reg)
		  begin
			HRESP=HRESP_AES;
			HRDATA=HRDATA_AES;
			HREADYOUT=HREADYOUT_AES;
		  end
		else if (hsel_int_reg & ~hsel_aes_reg & ~hsel_ram_reg)
		  begin
			HRESP=HRESP_INT;
			HRDATA=HRDATA_INT;
			HREADYOUT=HREADYOUT_INT;
		  end
		else
		  begin
			HRESP=0;
			HRDATA=0;
			HREADYOUT=1;
		  end
	
endmodule 

