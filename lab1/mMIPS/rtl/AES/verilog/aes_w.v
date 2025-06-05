`include "mmips_defines.v"
`define AES_REGS_MASK 32'h0000_0010 
`define AES_REGS_CASE 32'h0000_0000 
`define AES_INTERRUPT_REG_ADDR (32'h0000_0010 | `AESCASE)
`define AES_CTRL_REG_ADDR (32'h0000_0011 | `AESCASE)
module aes_w(
	input		clk,
	input		en,
	input		rst,
	input 	[1:0]	w,
	input	[1:0]	r,
	input	[31:0]	din,
	input	[31:0]	addr,
	output	reg [31:0]  dout,
	output		pready
);

	wire	[31:0]  core_dout;
	reg	[31:0]	ctrl_reg;
	reg	[31:0]	interrupt_reg;
	
	wire		int_ccf;
	wire		int_err;
	wire		dma_req_wr;
	wire		dma_req_rd;
	wire		pslverr;
	wire		psel;
	wire		presetn;
	reg		pen; // Works according to ARM APB Specs
	reg	[3:0]	paddr;
	wire		pw;
	wire		pr;
	wire		ctrl_reg_sel;
	reg		setup_access; //Setup or Access state
	reg		read_flag;
	reg		stall_mmips;
	reg	[1:0]	stall_counter;
	reg		write_flag;
	reg		write_flag_prev; 
	reg		read_flag_prev; 
	reg	[31:0]	write_reg;
	reg	[31:0]	read_reg;
	wire		write_req;
	wire		read_req;
	wire		in_pready;
	
	wire	[31:0]	masked_addr;

	assign pready = (in_pready | (write_flag)) & (~stall_mmips);

	assign	masked_addr = addr & `CASEMASK;

	assign write_req = pw & (masked_addr == `AESCASE) & ( (addr & `AES_REGS_MASK) == `AES_REGS_CASE );
	assign read_req = pr & (masked_addr == `AESCASE) & ( (addr & `AES_REGS_MASK) == `AES_REGS_CASE );


	//always @ (negedge clk or posedge rst)
	always @ (posedge clk or posedge rst)
		if (rst)
			stall_counter <= 0;
		else if (stall_mmips)
			stall_counter <= stall_counter + 1;
		else 
			stall_counter <= 0; 	

	always @ (posedge clk or posedge rst)
//	always @ (negedge clk or posedge rst)
		if (rst)
			stall_mmips <= 0;
		else if (read_req & (~stall_mmips))
			stall_mmips <= 1;
		else if (stall_counter==2'b01)
			stall_mmips <= 0;
		else 
			stall_mmips <= stall_mmips;
			

	always @ (posedge clk or posedge rst)
	begin
		if (rst)
			paddr <= 4'h0;
		else if (~(write_flag | read_flag) )
			paddr <= addr[3:0];
	end
	always @ (posedge clk or posedge rst)
	begin
		if (rst) 
			write_flag <= 0;
		else if (write_flag == 0)
		 begin
			write_flag <=  write_req; 
			write_reg <= din;
		 end
		else
			write_flag <= write_flag & (~in_pready);	
	end
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
			write_flag_prev <= 0;
		else
			write_flag_prev <= write_flag;
	end
	
	assign psel = write_flag | read_flag | pen;


	always @ (posedge clk or posedge rst)
	begin
		if(rst)
			pen <= 0;
		else
			pen <= (write_flag | read_flag);
	end
	

	always @ (posedge clk)
	begin
		if (rst) 
			read_flag <= 0;
		else if (read_flag == 0)
		 begin
			read_flag <= read_req;
		 end
		else
			read_flag <= read_flag & (~in_pready); 
	end

	always @ (posedge clk or posedge rst)
	begin
		if (rst)
			read_flag_prev <=0;
		else
			read_flag_prev <= read_flag;
	end

		

	// Write Signal
	assign pw = | w;
	assign pr = | r;

	
	// Status Register Bits
	// 2:PSLVERR
	// 3:int_ccf
	// 4:int_err
	// 5:dma_req_wr
	// 6_dma_req_rd
	// rest: 0 
	always @(posedge clk or posedge rst) begin
		if (rst)
			interrupt_reg <= 32'h0;
		else if(int_ccf)
		begin
			interrupt_reg[0]<=int_ccf;
			interrupt_reg[31:1] <= 31'h0;
		end
		else if (ctrl_reg[0] & interrupt_reg[0])
		begin
			interrupt_reg[31:0]<=32'h0;
		end	
	end

	//Control Register
	always @(posedge clk or posedge rst)
	begin
		if (rst)
			ctrl_reg <= 32'h0;
		else if((addr == `AES_CTRL_REG_ADDR)&&(pw==1))
			ctrl_reg <= din;	
	end

		
	//Output Mux
	always @(posedge clk or posedge rst)			
	begin
		if (rst)
			dout <= 32'h0;
		else if ( addr==`AES_CTRL_REG_ADDR )
			dout <= ctrl_reg;
		else if (addr == `AES_INTERRUPT_REG_ADDR)
			dout <= interrupt_reg;
		else
			dout <= core_dout;
	end			
	
	
	aes_ip	aes_ip_i(
		 .int_ccf(int_ccf)
		,.int_err(int_err)
		,.dma_req_rd(dma_req_rd)
		,.dma_req_wr(dma_req_wr)
		,.PREADY(in_pready)
		,.PSLVERR(pslverr)
		,.PRDATA(core_dout)
		,.PADDR(paddr)
		,.PWDATA(write_reg)
		,.PWRITE(write_flag | (write_flag_prev & pen))
		,.PENABLE(pen)
		,.PSEL(psel)
		,.PCLK(clk)
		,.PRESETn(~rst)
	);
endmodule
