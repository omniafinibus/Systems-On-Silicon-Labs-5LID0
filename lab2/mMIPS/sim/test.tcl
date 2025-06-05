
source init.tcl
dumptcf -scope testbench.sys_inst -output tcf.dump -overwrite
run
dumptcf -end
exit
