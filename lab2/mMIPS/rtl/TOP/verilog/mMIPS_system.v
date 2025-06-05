////////////////////////////////////////////////
// MMIPS_SIM.V
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
//     (26-03-2018): synthesiziable viersion combined with AMBA system 
//
//////////////////////////////////////////////!/

`include "mmips_defines.v"

module mMIPS_system(
        clk,
        en,
        rst,
        dev_dout,
        dev_din,
        dev_r,
        dev_w,
        dev_rdyr,
        dev_rdyw,
        dev_wdata,
        dev_waddr,
        dev_send_eop,
        dev_rcv_eop
    );
    
    input           clk;
    input           en;
    input           rst;
    output  [31:0]  dev_dout;
    input   [31:0]  dev_din;
    output          dev_r;
    output          dev_w;
    input           dev_rdyr;
    input           dev_rdyw;
    output          dev_wdata;
    output          dev_waddr;
    output          dev_send_eop;
    input           dev_rcv_eop;
    
    wire [31:0] rom_dout;
    wire        rom_wait;
    wire [31:0] rom_addr;
    wire [0:0]  rom_r;
    wire [31:0] ram_dout;
    wire        ram_wait;
    wire [31:0] ram_din;
    wire [31:0] ram_addr;
    wire [1:0]  ram_r;
    wire [1:0]  ram_w;
    wire	mmips_wait;



    //AHB Bus
    //


  wire	[31:0]	HADDRI;
  wire 		HWRITEI;
  wire [1:0]	HTRANSI;
  wire [2:0]	HSIZEI;
  wire [31:0]	HWDATAI;
  wire  [31:0]	HRDATAI;
  wire		HRESPI;
  wire		HREADYOUTI;
  wire [31:0]	HADDRD;
  wire 		HWRITED;
  wire [1:0]	HTRANSD;
  wire [2:0]	HSIZED;
  wire [31:0]	HWDATAD;
  wire  [31:0]	HRDATAD;
  wire		HRESPD;
  wire		HREADYOUTD;

  // RAM Cell signals
  wire		hsel_ram; // Fore Decoder
  wire [31:0]	ram_D;
  wire [7:0]	ram_A;
  wire [31:0]	ram_Q;
  wire 		ram_CE;
  wire [3:0]	ram_WE;

  wire [31:0]	HRDATA_RAM;
  wire 		HREADYOUT_RAM;
  wire		HRESP_RAM;

  // ROM Cell signals
  wire [31:0]	rom_D;
  wire [7:0]	rom_A;
  wire [31:0]	rom_Q;
  wire 		rom_CE;
  wire [3:0]	rom_WE;

  //AES Signals
  wire		hsel_aes;
  wire		aes_int_err;
  wire		aes_int_ccf;
  wire		aes_dma_req_wr;
  wire		aes_dma_req_rd;
  wire          HREADYOUT_AES; // Device ready
  wire  [31:0]	HRDATA_AES;    // Read data output
  wire          HRESP_AES;     // Device response
  wire	[9:0]	PADDR;     // APB Address
  wire       	PENABLE;   // APB Enable
  wire       	PWRITE;    // APB Write
  wire  [3:0]	PSTRB;     // APB Byte Strobe
  wire  [2:0]	PPROT;     // APB Prot
  wire  [31:0]	PWDATA;    // APB write data
  wire        	PSEL;      // APB Select
  wire          APBACTIVE; // APB bus is active, for clock gating
  wire  [31:0] 	PRDATA;    // Read data for each APB slave
  wire          PREADY;    // Ready for each APB slave
  wire          PSLVERR;  // Error state for each APB slave
  
  // INTERRUPT Controller signals
  wire		hsel_int;
  wire		hreadyout_int;
  wire	[31:0]	hrdata_int;
  wire		hresp_int;


    mMIPS mMIPS(
        .clk(clk),
        .enable(en & ~mmips_wait),
        .rst(rst),
        .rom_dout(rom_dout),
        .rom_wait(rom_wait),
        .rom_addr(rom_addr),
        .rom_r(rom_r),
        .ram_dout(ram_dout),
        .ram_wait(ram_wait),
        .ram_din(ram_din),
        .ram_addr(ram_addr),
        .ram_r(ram_r),
        .ram_w(ram_w),
        .dev_dout(dev_dout),
        .dev_din(dev_din),
        .dev_r(dev_r),
        .dev_w(dev_w),
        .dev_rdyr(dev_rdyr),
        .dev_rdyw(dev_rdyw),
        .dev_wdata(dev_wdata),
        .dev_waddr(dev_waddr),
        .dev_send_eop(dev_send_eop),
        .dev_rcv_eop(dev_rcv_eop)
    );
    
    MIPS_to_AHB uMIPS_IF(
	.HCLK(clk),
	.wait_out(mmips_wait),
	.HRESETn(~rst),
	.rom_dout_out(rom_dout),
	.rom_wait_out(rom_wait),
	.rom_addr_in(rom_addr),
	.rom_r_in({1'b0,rom_r}),
	.ram_dout_out(ram_dout),
	.ram_wait_out(ram_wait),
	.ram_din_in(ram_din),
	.ram_addr_in(ram_addr),
	.ram_r_in(ram_r),
	.ram_w_in(ram_w),
	.HADDRI(HADDRI),
	.HWRITEI(HWRITEI),
	.HTRANSI(HTRANSI),
	.HSIZEI(HSIZEI),
	.HWDATAI(HWDATAI),
	.HRDATAI(HRDATAI),
	.HRESPI(HRESPI),
	.HREADYOUTI(HREADYOUTI),
	.HADDRD(HADDRD),
	.HWRITED(HWRITED),
	.HTRANSD(HTRANSD),
	.HSIZED(HSIZED),
	.HWDATAD(HWDATAD),
	.HRDATAD(HRDATAD),
	.HRESPD(HRESPD),
	.HREADYOUTD(HREADYOUTD)
    );		


    AHB_DECODER uAHB_DECODER(
	.HADDR(HADDRD),
	.HSEL_RAM(hsel_ram),
	.HSEL_AES(hsel_aes),
	.HSEL_INT(hsel_int)
    );

    AHB_MUX uAHB_MUX(
	.HCLK(clk),
	.HRESETn(~rst),
	.HRDATA(HRDATAD),
	.HREADYOUT(HREADYOUTD),
	.HRESP(HRESPD),

	.HSEL_AES(hsel_aes),
	.HRDATA_AES(HRDATA_AES),
	.HREADYOUT_AES(HREADYOUT_AES),
	.HRESP_AES(HRESP_AES),

	.HSEL_RAM(hsel_ram),
	.HRDATA_RAM(HRDATA_RAM),
	.HREADYOUT_RAM(HREADYOUT_RAM),
	.HRESP_RAM(HRESP_RAM),

	.HSEL_INT(hsel_int),
	.HRDATA_INT(hrdata_int),
	.HREADYOUT_INT(hreadyout_int),
	.HRESP_INT(hresp_int)
    );

 
    cmsdk_ahb_to_sram #(.AW(10)) uRAM_IF(
    	.HCLK(clk),
    	.HRESETn(~rst),
    	.HSEL(hsel_ram), 
    	.HADDR(HADDRD[9:0]),
    	.HREADY(1'b1),
    	.HWRITE(HWRITED),
    	.HTRANS(HTRANSD),
    	.HSIZE(HSIZED),
    	.HWDATA(HWDATAD),
    	.HRDATA(HRDATA_RAM),
    	.HRESP(HRESP_RAM),
    	.HREADYOUT(HREADYOUT_RAM),
    	.SRAMRDATA(ram_Q),
    	.SRAMWDATA(ram_D),
    	.SRAMADDR(ram_A),
    	.SRAMWEN(ram_WE),
    	.SRAMCS(ram_CE)
    );

    cmsdk_ahb_to_sram #(.AW(10)) uROM_IF(
    	.HCLK(clk),
    	.HRESETn(~rst),
    	.HSEL(1'b1),  //Always selected
    	.HADDR(HADDRI[9:0]),
    	.HREADY(1'b1),
    	.HWRITE(HWRITEI),
    	.HTRANS(HTRANSI),
    	.HSIZE(HSIZEI),
    	.HWDATA(HWDATAI),
    	.HRDATA(HRDATAI),
    	.HRESP(HRESPI),
    	.HREADYOUT(HREADYOUTI),
    	.SRAMRDATA(rom_Q),
    	.SRAMWDATA(rom_D),
    	.SRAMADDR(rom_A),
    	.SRAMWEN(rom_WE),
    	.SRAMCS(rom_CE)
    );

// Memory Cells
    IMEM imem(
		.CK(clk),
		.CE(rom_CE),
		.WE(|rom_WE),
		.A(rom_A),
		.D(rom_D),
		.Q(rom_Q)
    );

    DMEM dmem(
		.CK(clk),
		.CE(ram_CE),
		.WE(|ram_WE),
		.A(ram_A),
		.D(ram_D),
		.Q(ram_Q)
    );

// AHB to APB controller
    cmsdk_ahb_to_apb #(.ADDRWIDTH(10),.REGISTER_WDATA(1),.REGISTER_RDATA(0)) uAPB_BUS(
		.HCLK(clk),
		.HRESETn(~rst),
		.PCLKEN(1'b1),
		.HSEL(hsel_aes),
		.HADDR(HADDRD[9:0]),
		.HTRANS(HTRANSD),
		.HSIZE(HSIZED),
		.HPROT(4'h0),
		.HWRITE(HWRITED),
		.HREADY(1'b1),
		.HWDATA(HWDATAD),
		.HREADYOUT(HREADYOUT_AES),
		.HRDATA(HRDATA_AES),
		.HRESP(HRESP_AES),
		.PADDR(PADDR),
		.PENABLE(PENABLE),
		.PWRITE(PWRITE),
		.PSTRB(PSTRB),
		.PPROT(PPROT),
		.PWDATA(PWDATA),
		.PSEL(PSEL),
		.APBACTIVE(APBACTIVE),
		.PRDATA(PRDATA),
		.PREADY(PREADY),
		.PSLVERR(PSLVERR)
    );	
  
    aes_ip u_aes(
		.int_ccf(aes_int_ccf),
		.int_err(aes_int_err),
		.dma_req_wr(aes_dma_req_wr),
		.dma_req_rd(aes_dma_req_rd),
		.PREADY(PREADY),
		.PSLVERR(PSLVERR),
		.PRDATA(PRDATA),
		.PADDR(PADDR[5:2]),
		.PWDATA(PWDATA),
		.PWRITE(PWRITE),
		.PENABLE(PENABLE),
		.PSEL(PSEL),
		.PCLK(clk),
		.PRESETn(~rst)
    );

    int_ctrl #(.ADDRWIDTH(12)) u_int_ctrl(
		.HCLK(clk),
		.HRESETn(~rst),
		.ECOREVNUM(4'h0),
		.HSELS(hsel_int),
		.HADDRS(HADDRD[11:0]),
		.HTRANSS(HTRANSD),
		.HSIZES(HSIZED),
		.HWRITES(HWRITED),
		.HREADYS(1'b1),
		.HWDATAS(HWDATAD),
		.HREADYOUTS(hreadyout_int),
		.HRESPS(hresp_int),
		.HRDATAS(hrdata_int),
		.aes_int(aes_int_ccf)
    );
		
    
//    ram 
//    dmem(
//        .clk(clk),
//        .enable(en),
//        .ram_dout(ram_dout),
//        .ram_wait(ram_wait),
//        .ram_din(ram_din),
//        .ram_addr(ram_addr),
//        .ram_r(ram_r),
//        .ram_w(ram_w)
//    );
//
//    rom 
//    imem(
//        .clk(clk),
//        .enable(en),
//        .rom_dout(rom_dout),
//        .rom_wait(rom_wait),
//        .rom_addr(rom_addr),
//        .rom_r(rom_r)
//    );
//
//    aes_w 
//    aes_i(
//        .clk(clk),
//        .en(en),
//	.rst(rst),
//	.pready(aes_ready),
//        .dout(aes_dout),
//        .din(ram_din),
//        .addr(ram_addr),
//        .r(ram_r),
//        .w(ram_w)
//    );
//    

endmodule
