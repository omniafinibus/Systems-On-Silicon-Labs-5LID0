set regs [find *regs_reg* -absolute -instances -recursive all]
foreach reg $regs {
 #      regsub {[\m\r]} $reg {\\m} tmp;
        #regsub {\.(\w+(?:\[\d+\]){2})} $reg {.\\\1} tmp
	#regsub {\.(\r\w+\[\d+\]\[\d+\])} $reg {.\\\1} tmp
	#puts $reg
	regsub {\r} $reg {\\r} tmp
	
	if {![regexp {\\} $tmp]} {
	    regsub {(\w+\[\d+\]\[\d+\])} $tmp {\\\1} tmp
	}
#
	#puts $tmp
	#regsub {(\w+\[\d+\]\[\d+\])} $tmp {\\\1} tmp
	#puts $tmp
        if {([value "$tmp\ .D"]=="1'hx") ||  ([value "$tmp\ .Q"]=="1'hx") } {
                deposit "$tmp\ .Q" = 1'b0;
                deposit "$tmp\ .D" = 1'b0;
        }

 }; 
#force testbench.mMIPS_sim.mMIPS.dev_din = 32'h0;
#deposit testbench.mMIPS_sim.aes_i.interrupt_reg = 32'h0;
#deposit testbench.mMIPS_sim.aes_i.ctrl_reg = 32'h0;
