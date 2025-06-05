set regs [find \\registers_reg* -absolute -instances -recursive all]
foreach reg $regs {
 	regsub {[\r]} $reg {\\r} tmp;
	if {([value $tmp\ .D]=="1'hx") ||  ([value $tmp\ .Q]=="1'hx") } {
		deposit $tmp\ .Q = 1'h1;
 		deposit $tmp\ .D = 1'h1;
	}

 }; 
#force testbench.mMIPS_sim.mMIPS.dev_din = 32'h0;
#deposit testbench.mMIPS_sim.aes_i.interrupt_reg = 32'h0;
#deposit testbench.mMIPS_sim.aes_i.ctrl_reg = 32'h0;
