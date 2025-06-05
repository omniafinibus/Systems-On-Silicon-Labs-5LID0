#### Template Script for RTL->Gate-Level Flow (generated from RC 16.12-s027_1) 
#source script/tcl_tut.tcl



if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

puts "\033\[33m################################################################"
puts         "#################  Define global variables #####################"
puts 	     "################################################################\033\[0m"

set DESIGN mMIPS_system


set GPDK045 /opt/tools/technology/cadence/gpdk/45nm
set libdir $GPDK045/gsclib045_svt_v4.4/gsclib045/timing

set_attribute init_lib_search_path "./lib \$GPDK045/\gsclib045_all_v4.4/"
set_attribute init_lib_search_path {. ./lib} / 
set_attribute script_search_path {./script } /

set_attribute init_hdl_search_path {. ../rtl} /
set_attribute information_level 9 /
read_power_intent -module $DESIGN -cpf cpf/MIPS_post_syn.cpf

set_attribute lef_library "/opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/lef/gsclib045_tech.lef \ 
				/opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/lef/gsclib045_macro.lef \
				./lef/MEM1_256X32.lef"

#set_attribute cap_table_file "/opt/tools/technology/cadence/gpdk/45nm/gpdk045_v_4_0/soce/gpdk045.basic.CapTbl" /
set_attribute qrc_tech_file "/opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/qrc/qx/gpdk045.tch"


puts "\033\[33m################################################################"
puts         "#################  Loadin the RTL Files    #####################"
puts 	     "################################################################\033\[0m"

read_netlist ./gate/${DESIGN}.v
read_sdc ./gate/$DESIGN.sdc





#### Read in CPF file.
apply_power_intent




commit_power_intent




