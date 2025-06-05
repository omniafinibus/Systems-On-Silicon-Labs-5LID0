if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

set DESIGN mMIPS_system

set GPDK045 /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4

set_attribute init_lib_search_path "./lib $GPDK045/"
set_attribute init_hdl_search_path {. ../rtl} /
set_attribute \
    init_hdl_search_path "../rtl/TOP/verilog \
        [get_attribute init_hdl_search_path]"

source script/prepare_CPF_input.tcl
source script/prepare_CPF_file.tcl

set_attribute information_level 9 /
##set_attribute retime_reg_naming_suffix __retimed_reg /
read_power_intent -module $DESIGN -cpf cpf/MIPS.cpf

## PLE   
set_attr lef_library "$GPDK045/gsclib045/lef/gsclib045_tech.lef $GPDK045/gsclib045/lef/gsclib045_macro.lef $GPDK045/gsclib045/lef/gsclib045_multibitsDFF.lef ./lef/MEM1_256X32.lef"
set_attr qrc_tech_file "$GPDK045/gsclib045/qrc/qx/gpdk045.tch"

## OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE
set_attribute lp_insert_clock_gating true
set_attribute leakage_power_effort medium

## Power root attributes
#set_attribute lp_clock_gating_prefix <string> /
#set_attribute lp_power_analysis_effort <high> /
#set_attribute lp_power_unit mW /
#set_attribute lp_toggle_rate_unit /ns /
## The attribute has been set to default value "medium"
## you can try setting it to high to explore MVT QoR for low power optimization


read_hdl MMIPS/verilog/add.v
read_hdl MMIPS/verilog/aluctrl.v  
read_hdl MMIPS/verilog/alu.v  
read_hdl MMIPS/verilog/branch_ctrl.v  
read_hdl MMIPS/verilog/ctrl.v  
read_hdl MMIPS/verilog/decoder.v  
read_hdl MMIPS/verilog/hazard_ctrl.v  
read_hdl MMIPS/verilog/hazard.v  
read_hdl MMIPS/verilog/imm2word.v  
read_hdl MMIPS/verilog/memdev.v  
read_hdl MMIPS/verilog/mmips.v  
read_hdl MMIPS/verilog/mux.v  
read_hdl MMIPS/verilog/regfile16.v  
read_hdl MMIPS/verilog/register.v  
read_hdl MMIPS/verilog/shift.v  
read_hdl MMIPS/verilog/signextend.v  
read_hdl AES/verilog/aes_core.v  
read_hdl AES/verilog/datapath.v  
read_hdl AES/verilog/host_interface.v  
read_hdl AES/verilog/mix_columns.v  
read_hdl AES/verilog/sBox.v  
read_hdl AES/verilog/aes_ip.v  
read_hdl AES/verilog/control_unit.v  
read_hdl AES/verilog/data_swap.v 
read_hdl AES/verilog/key_expander.v  
read_hdl AES/verilog/sBox_8.v  
read_hdl AES/verilog/shift_rows.v  
read_hdl MEM/verilog/DMEM.v
read_hdl MEM/verilog/IMEM.v
read_hdl TOP/verilog/MIPS_to_AHB.v
read_hdl TOP/verilog/AHB_DECODER.v
read_hdl TOP/verilog/AHB_MUX.v
read_hdl cmsdk_ahb_to_apb/verilog/cmsdk_ahb_to_apb.v
read_hdl cmsdk_ahb_to_sram/verilog/cmsdk_ahb_to_sram.v
read_hdl int_ctrl/verilog/int_ctrl.v
read_hdl int_ctrl/verilog/int_ctrl_reg.v
read_hdl int_ctrl/verilog/int_ctrl_if.v

read_hdl TOP/verilog/mMIPS_system.v

elaborate $DESIGN


puts "\033\[36m If everything went well you should have no unresulved instances.       \033\[0m"
check_design -unresolved
# suspend

set rst_path [find -port rst]

set PERIOD 100000.0

define_clock -period $PERIOD -name main_clock [find -port clk]
external_delay -input [expr $PERIOD/1000] -clock main_clock [all_inputs]
set_attribute external_driver [find [find /lib*/*/cadence45_wc_HV_lib/ -libcell DFFRHQX1] -libpin Q] [find /des* -port ports_in/*]
set_attribute external_pin_cap 0.01 [find /des* -port ports_out/*]
set_attribute avoid true [find / -libcell SDFF*]

path_disable -from [find -port rst] -to [all_registers]

#### Read in CPF file.
apply_power_intent

check_design -unresolved
# suspend

define_cost_group -name I2C -design $DESIGN
define_cost_group -name C2O -design $DESIGN
define_cost_group -name C2C -design $DESIGN
define_cost_group -name I2O -design $DESIGN 
path_group -from [all::all_seqs] -to [all::all_seqs] -group C2C -name C2C 
path_group -from [all::all_seqs] -to [all::all_outs] -group C2O -name C2O 
path_group -from [all::all_inps]  -to [all::all_seqs] -group I2C -name I2C
path_group -from [all::all_inps]  -to [all::all_outs] -group I2O -name I2O

set list_mod [find / -mode *]
if {[llength $list_mod] >= 1} {
  foreach mode $list_mod {
    define_cost_group -name I2O_[vbasename $mode] -design $DESIGN
  }
} else {
  define_cost_group -name I2O -design $DESIGN 
}
foreach mode [find / -mode *] {
  path_group -from [all::all_inps]  -to [all::all_outs] -group I2O_[vbasename $mode] -name I2O_[vbasename $mode] -mode $mode
}

#####################################################################################
#### Retime + OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE
#####################################################################################


#set rt_subds {mysub1  mysub2 mysub3}
#foreach subd $rt_subds {
#  set_attribute retime true $subd
  ####Uncomment to prevent registers from being moved across the subdesign boundaries
  ##set_attribute retime_hard_region true $subd 
#}
####Setting 'retime' attribute on the top-level as shown below 
####is not recommended due to possible verification/ECO issues unless for very small designs
##set_attribute retime true   "/designs/$DESIGN"

####set dont_retime on registers which should not be retimed
#set dont_rt_flops "myflop1 myflop2 myflop3 .."
#foreach rtf $rt_flops {
#  set_attribute dont_retime true $rtf
#}
# Enable verification flow 
#set_attribute retime_verification_flow true /
#######################################################################################
## Leakage/Dynamic power/Clock Gating setup.
#######################################################################################


#set_attribute lp_clock_gating_cell [find /lib* -libcell <cg_libcell_name>] "/designs/$DESIGN"
#set_attribute max_leakage_power 0.0 "/designs/$DESIGN"
#set_attribute lp_power_optimization_weight <value from 0 to 1> "/designs/$DESIGN"
#set_attribute max_dynamic_power <number> "/designs/$DESIGN"
## read_tcf <TCF file name>
## read_saif <SAIF file name>
## read_vcd <VCD file name>


#### uniquify the subdesign if it is multiple instantiated
#### and you would like to assign one of the instantiations
#### to a different library domain
#### edit_netlist uniquify <design|subdesign>
check_cpf -detail


#### To turn off sequential merging on the design 
#### uncomment & use the following attributes.
##set_attribute optimize_merge_flops false /
##set_attribute optimize_merge_latches false /
#### For a particular instance use attribute 'optimize_merge_seqs' to turn off sequential merging. 

commit_power_intent
#verify_power_structure -lp_only -post_synth -detail > $_REPORTS_PATH/${DESIGN}_verify_power_struct.rpt

set_attribute preserve true imem
set_attribute preserve true dmem

set_attribute syn_generic_effort high
syn_generic
set_attribute syn_map_effort high
syn_map

#### Build RTL power models
##build_rtl_power_models -design $DESIGN -clean_up_netlist [-clock_gating_logic] [-relative <hierarchical instance>]
#report power -rtl

## ungroup -threshold <value>
## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_attribute remove_assigns true /
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign> 
##set_attribute use_tiehilo_for_const <none|duplicate|unique> /
#set_attribute syn_opt_effort low /

# MAYBE INCREMENTAL? OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE
syn_opt


puts "\033\[33m################################################################\033\[0m"
puts "\033\[33m################POST SYNTHESIS###################################\033\[0m"
puts "\033\[33m################################################################\033\[0m"

# puts "\033\[36m                                                                        \033\[0m"
# puts "\033\[36m            The synthesis process has finished!                         \033\[0m"
# puts "\033\[36m Now check if everthing went well with report comands:                  \033\[0m"
# puts "\033\[36m     * report timing gives you the delay on the most critical path.     \033\[0m"
# puts "\033\[36m       * The slack should be positive.                                  \033\[0m"
# puts "\033\[36m     * report power gives you post syhtesis power report.               \033\[0m"
# puts "\033\[36m     * report messages gives you all the messages issued by the tool.   \033\[0m"
# puts "\033\[36m       * There should be no error messages, unless you fixed them already.\033\[0m"
# puts "\033\[36m If everything went well proceed to the next step with resume.          \033\[0m"
# puts "\033\[36m If there are issues try to understand and fix them.                    \033\[0m"
# puts "\033\[36m If you cannot fix the issues by yourself, contact the TAs             \033\[0m"
# puts "\033\[36m            Paul           p.detterer@tue.nl                            \033\[0m"
# puts "\033\[36m            Kamlesh        k.k.singh@tue.nl                             \033\[0m"
# puts "\033\[36m                                                                        \033\[0m"
# puts "\033\[36m The rest of the script writes the reports and design relevant data      \033\[0m"
# puts "\033\[36m to the files. Important files are:                                     \033\[0m"
# puts "\033\[36m                                                                        \033\[0m"
# puts "\033\[36m    ->./gate/*.v       : the synthesized gate level netlist             \033\[0m"
# puts "\033\[36m    ->./gate/*.sdf     : the standard delay format file for delay aware \033\[0m"
# puts "\033\[36m                         simulation                                     \033\[0m"
# puts "\033\[36m    -> *.sdc           : standard design constrait file for constraint    \033\[0m"
# puts "\033\[36m                         definition in innovous. Located in p+r folder  \033\[0m"
# puts "\033\[36m We hope you enjoyed your first synthesis run. For the next runs     \033\[0m"
# puts "\033\[36m you should remove/comment excessive prints and add the commands     \033\[0m"
# puts "\033\[36m you used to synth.scr. You can find them in genus.cmd. Ideally your \033\[0m"
# puts "\033\[36m second and next runs are completelly free of suspend commands and run without errors.  \033\[0m"
# puts "\033\[36m However we advice to put suspend on critical places and play with      \033\[0m"
# puts "\033\[36m Genus commands there. It is also what real IC-Designers do to achieve \033\[0m"
# puts "\033\[36m the needed performance. This is last suspended section. Bye bye!:)       \033\[0m"
# suspend



puts "######################################################################################################"
puts "## Write reports                                     "
puts "######################################################################################################"

report area             > ./report/${DESIGN}_cpf.area
report timing           > ./report/${DESIGN}_cpf.timing
report gates            > ./report/${DESIGN}_cpf.gates
report design_rules     > ./report/${DESIGN}_cpf.rules
report power            > ./report/${DESIGN}_cpf.power
report clock_gating     > ./report/${DESIGN}_cpf.gating
report summary          > ./report/${DESIGN}_cpf.summary
report power -verbos    > ./report/${DESIGN}_cpf.verbose_power
report gates -power     > ./report/${DESIGN}_cpf.power_gates
report timing -worst 10 > ./report/${DESIGN}_cpf.worst_timing


puts "######################################################################################################"
puts "## write backend file set (verilog, SDC, config, etc.)"
puts "######################################################################################################"

#suspend
write_design -innovus -basename ../p+r/genus_data/${DESIGN}
write_design -basename ./gate/${DESIGN}
write_sdf -edge check_edge > ./gate/${DESIGN}.sdf


puts "============================"
puts "Synthesis Finished ........."
puts "============================"


##quit
