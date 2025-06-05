#### Template Script for RTL->Gate-Level Flow (generated from RC 16.12-s027_1) 
source script/tcl_tut.tcl

puts "#######################################################################################"
puts "\033\[36mNow we start with actual synthesis flow                         \033\[0m"
puts "\033\[36mHere you will be guided through the typical steps of digital synthesis. \033\[0m"
puts "\033\[36m      *  Loading of the technology libraries.                     \033\[0m"
puts "\033\[36m      *  Definition of the design power domains and analysis views.      \033\[0m"
puts "\033\[36m      *  Loading and Elaboration of the Design RTL Description.  \033\[0m"
puts "\033\[36m      *  Definition of the clock and timing constraints.         \033\[0m"
puts "\033\[36m      *  Mapping to the generic gates.                           \033\[0m"
puts "\033\[36m      *  Mapping to the real    gates.                         \033\[0m"
puts "\033\[36m      *  Check and preparation for Backend.                       \033\[0m"
  
puts "\033\[36mThe complete interactive execution of this script may take more than one hour.\033\[0m"
puts "\033\[36mAfter execution or partial execution. Your input is recorded in \033\[0mlog/genus.cmd\033\[0m"
puts "\033\[36mIt is recomended to modify the synthesis script \033\[35msynth.tcl\033\[36m with content of \033\[35mgenus.cmd\033\[36m, so that you do not have to stop and re enter commands at the stages you already completed once. \033\[0m"
puts "\033\[36mAfter you figured out which command to enter write it into the script and comment out the \033\[35msuspend\033\[36m command with '#' \033\[0m"
puts "\033\[36mIf something is not clear enough. In genus, you always can use the help  \033\[0m"
puts "\033\[36mcommand. After entering \033\[35mhelp <command/attribute>\033\[36m you get short summary \033\[0m"
puts "\033\[36mof the use and purpose for the requested object.                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36mIf you have problems to advance, please contact the TAs:                \033\[0m"
puts "\033\[33m                   Paul Detterer <p.detterer@tue.nl>                    \033\[0m"
puts "\033\[34m                   Kamlesh Singh <k.k.singh@tue.nl>                     \033\[0m"
puts "\033\[36m                                                                        \033\[0m"

suspend


if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

puts "\033\[33m################################################################"
puts         "#################  Define global variables #####################"
puts 	     "################################################################/033\[0m"

set DESIGN mMIPS_system


set GPDK045 /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4

puts "\033\[36mGenus internal variables are set with \033\[35mset_attribute <variable_name> <content> <scope>"
puts "\033\[36mFor example there is an attribute which defines the location for the tool to look for technology library files: \033\[32minit_lib_search_path "
puts "\033\[36mTo avoid the long path heads later it can be set here with "
puts "\033\[33mEnter: set_attribute init_lib_search_path \"./lib \$GPDK045/\""
puts "\033\[35m\"\"\033\[36m are actually needed here so that tool sees two paths separated by space as one argument"
puts "The variable \033\[35mGPDK045\033\[36m is already set correctly by the script to point at the location of the libraries."
puts "\033\[34mNOTE:\033\[36m the folder names are related to the content inside (obviously)"
puts "      * \033\[35mgsclib\033\35m is abbreviation for GPDK Standard Cells Library"
puts "      * \033\[35msvt\033\[36m stands for \033\[35mS\033\[36mtandard \033\[35mT\033\[36mhreshold \033\[35mV\033\[36moltage" 
puts "      * \033\[35mhvt\033\[36m stands for \033\[35mH\033\[36migh     \033\[35mT\033\[36mhreshold \033\[35mV\033\[36moltage" 
puts "      * \033\[35mlvt\033\[36m stands for \033\[35mL\033\[36mow      \033\[35mT\033\[36mhreshold \033\[35mV\033\[36moltage\033\[0m" 
puts "      * The required svt timing libraries are in \$GPDK045/gsclib045/timing\033\[0m" 
puts "      * The hvt timing libraries are in \$GPDK045/gsclib045_hvt/timing\033\[0m" 
puts "      * The hvt timing libraries are in \$GPDK045/gsclib045_lvt/timing\033\[0m" 
#set_attr      init_lib_search_path "put some libs there" <------ shorting the commands works
#set_attr      init_lib_search_path {put some libs there} <------ works as well if there are no $VARs 
#

suspend




# Script search path
# set_attribute script_search_path {./script } /

puts "\033\[36mSame can be done for  init_hdl_search_path for the RTL description of the design"
puts "\033\[34mNote:\033\[36m all RTL description files are in rtl folder (../rtl)"
puts "\033\[33mset_attribute init_hdl_search_path {. ../rtl} / \033\[0m"
puts "\033\[34mNote:\033\[35m{}\033\[36m have almost same function as \033\[35m\"\"\033\[36m with big difference that inside \033\[35m{} $ \033\[36mand \033\[35m\[\] \033\[36mare just characters\033\[0m"
puts "\033\[36m     Try to enter \033\[0mputs \"\$GPDK045\" \033\[36m and \033\[0m puts {\$GPDK045}"

suspend
set_attribute \
    init_hdl_search_path "../rtl/TOP/verilog \
        [get_attribute init_hdl_search_path]"

source script/prepare_CPF_input.tcl
source script/prepare_CPF_file.tcl
        #
##Uncomment and specify machine names to enable super-threading.
##set_attribute super_thread_servers {<machine names>} /
##For design size of 1.5M - 5M gates, use 8 to 16 CPUs. For designs > 5M gates, use 16 to 32 CPUs
##set_attribute max_cpus_per_server 8 /

##Default undriven/unconnected setting is 'none'.  
##set_attribute hdl_unconnected_input_port_value 0 | 1 | x | none /
##set_attribute hdl_undriven_output_port_value   0 | 1 | x | none /
##set_attribute hdl_undriven_signal_value        0 | 1 | x | none /


##set_attribute wireload_mode <value> /
set_attribute information_level 9 /
##set_attribute retime_reg_naming_suffix __retimed_reg /
read_power_intent -module $DESIGN -cpf cpf/MIPS.cpf

## PLE

puts "\033\[36m For better estimation of gate interconnection delay the tool uses the  \033\[0m"
puts "\033\[36m abstract information of the cells\' layout. In lef file the cell\'s    \033\[0m"
puts "\033\[36m footprint is defined with all the pin connections. The standard cell   \033\[0m"
puts "\033\[36m lef files are located in g\033\[35msclib045/lef/ \033\[36m                               \033\[0m"
puts "\033\[36m Three of the files need to be loaded:                                  \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m      * gsclib045_tech.lef  - for technology definitions                \033\[0m"
puts "\033\[36m      * gsclib045_macro.lef - for the cells                             \033\[0m"
puts "\033\[36m      * ./lef/MEM1_256X32.lef - foot print for memory cells             \033\[0m"
puts "\033\[33m Include the necessary lef files.                                       \033\[0m"
puts "\033\[36m The Genus command for it is:                                           \033\[0m"
puts "\033\[35m         set_attr lef_library \$file_list                               \033\[0m"
puts "\033\[33m Define the list and set lef_library attribute to this list.            \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[34m HINT:\033\[36m The needed folders are under \$GPDK045 path.                     \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
suspend

## Provide either cap_table_file or the qrc_tech_file
puts "\033\[36m For better capacitance estimation the tool may use the cap tables or a techfile.     \033\[0m"
puts "\033\[36m Those captables are connected to the technology.                       \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m GPDK045 technology file is located in \$GPDK045/gsclib045/qrc/qx/gpdk045.tch    \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[33m Set the attribute \033\[35mqrc_tech_file\033\[33m  to the full file path for better      \033\[0m"
puts "\033\[36m synthesis with command set_attr.                                       \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
suspend

#set_attribute cap_table_file $GPDK045/../gpdk045_v_4_0/soce/gpdk045.basic.CapTbl

#set_attribute qrc_tech_file <file> /

##generates <signal>_reg[<bit_width>] format
#set_attribute hdl_array_naming_style %s\[%d\] /  
##


puts "\033\[36m Here is a right spot to configure  optimizations. Though the default   \033\[0m"
puts "\033\[36m configuration is generally sufficient to get a decent design, the best \033\[0m"
puts "\033\[36m design metrics are achieved with right setup of the optimization       \033\[0m"
puts "\033\[36m algorithms. Following techniques are confirmed to improve our labs     \033\[0m"
puts "\033\[36m design correctly:                                                      \033\[0m"
puts "\033\[36m     * Clock gating                                                     \033\[0m"
puts "\033\[36m       * Is activating by setting lp_insert_clock_gating to true.       \033\[0m"
puts "\033\[36m       * Later also the clock gating cells need to be defined.          \033\[0m"
puts "\033\[36m     * Setting priorities                                               \033\[0m"
puts "\033\[36m       * The tool is initially throttled.              \033\[0m"
puts "\033\[36m         * It is to reduce unnecessary computational efforts.         \033\[0m"
puts "\033\[36m         * For example leakage_power_effort attribute is medium.       \033\[0m"
puts "\033\[36m         * To focus more on leakage you can set it to high.             \033\[0m"
puts "\033\[36m         * Look what is set for lp_power_analysis_effort.               \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36mBut for first it is sufficient to continue with resume command.         \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"

## Power root attributes
#set_attribute lp_clock_gating_prefix <string> /
#set_attribute lp_power_analysis_effort <high> /
#set_attribute lp_power_unit mW /
#set_attribute lp_toggle_rate_unit /ns /
## The attribute has been set to default value "medium"
## you can try setting it to high to explore MVT QoR for low power optimization
#set_attribute leakage_power_effort medium /
suspend


puts "\033\[33################################################################"
puts         "#################  Loadin the RTL Files    #####################"
puts 	     "################################################################/033\[0m"

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

puts "\033\[36m  As you may noticed from the tool output some *.v files were loaded    \033\[0m"
puts "\033\[36m  The genus command for this is read_hdl.                               \033\[0m"
puts "\033\[36m  We are almost done with loading the design only the top definition is \033\[0m"
puts "\033\[36m  missing.                                                              \033\[0m"
puts "\033\[33m  Use read_hdl command to load TOP/verilog/mMIPS_system.v file          \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
suspend


puts "\033\[36m After the design is loaded the files need to be elaborated. During this\033\[0m"
puts "\033\[36m process the RTL description is parsed and converted to the data        \033\[0m"
puts "\033\[36m structures which are suitable for the tool to work with.               \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[33m Execute command elaborate \$DESIGN                                     \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
suspend


puts "\033\[36m Now you can check if the loading of design went well:                  \033\[0m"
puts "\033\[36m Use command check_design -unresolved to identify unresolved modules.   \033\[0m"
puts "\033\[36m If everything went well you should have no unresulved instances.       \033\[0m"
suspend

puts "\033\[36m####################################################################\033\[0m"
puts "\033\[36m## Constraints Setup                                               \033\[0m"
puts "\033\[36m####################################################################\033\[0m"

puts "\033\[36mAt this step the timing constraints are defined. For most designs, the  \033\[0m"
puts "\033\[36mmost important timing constraint is connected to maximal clock frequency.\033\[0m"
puts "\033\[36mThis is clock period.                                                   \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m The Genus command for the definition of clock is:                      \033\[0m"
puts "\033\[36m    define_clock -period <clock period> -name <label> <pin_name>        \033\[0m"
puts "\033\[36m The name <label> is just a label how the tool calls your clock.        \033\[0m"
puts "\033\[36m The clock pin name can by found in mMIPS_sim.v and the absolute path   \033\[0m"
puts "\033\[36m to it with \033\[35mfind -port ...\033\[36mcommand.                                               \033\[0m"
puts "\033\[33m Define the clock at input pin 'clk'.                                   \033\[0m"
puts "\033\[36m To use output of one command as input for another you need the special \033\[0m"
puts "\033\[36m function of tcl square brackets (\[\])                                 \033\[0m"
puts "\033\[36m See how it works first type the command \033\[35mfind -port rst\033\[36m.                \033\[0m"
puts "\033\[36m You see the full path of the port? Now type \033\[35mset rst_path \[find -port rst\] .\033\[0m"
puts "\033\[36m Now you have the path inside the rst_path variable                    \033\[0m"

suspend

puts "\033\[36m Clock period is not only time definition needed. Clock period defines  \033\[0m"
puts "\033\[36m the maximum delay between registers in the design. However the maximum \033\[0m"
puts "\033\[36m delay betwen primary ports of the design and registers is not defined  \033\[0m"
puts "\033\[36m yet.                                                                   \033\[0m"
puts "\033\[36m The Genus commands for this purpose are:                               \033\[0m"
puts "\033\[36m     external_delay -input/-output delay -clock label port_pin_list     \033\[0m"
puts "\033\[36m You need to execute the command twice: for input and output.           \033\[0m"
puts "\033\[36m All input output ports can be found in mMIPS_sim.v.                    \033\[0m"
puts "\033\[36m Alternatively, use the commands all_inputs / all_outputs               \033\[0m"
puts "\033\[33m Use external_delay command to specify delay between primary in/outputs \033\[0m"
puts "\033\[33m and registers.                                                         \033\[0m"

suspend

puts "\033\[36m The cell library in combination with technology lefs and cap tables     \033\[0m"
puts "\033\[36m provides usually sufficient information about what happens between the \034\[0m"
puts "\033\[36m cells. However the signal characteristics at the inputs are still     \033\[0m"
puts "\033\[36m unclear. Hence, the information about external drivers and loads is now\033\[0m"
puts "\033\[36m to define.                                                             \033\[0m"
puts "\033\[36m The Genus commands for this purpose are:                               \033\[0m"
puts "\033\[36m     set_attribute external_driver driver_cell_pin  design_input_ports  \033\[0m"
puts "\033\[36m     set_attribute external_pin_cap capacitance design_output_ports     \033\[0m"
puts "\033\[33m Define the external drivers and loads.                                 \033\[0m"
puts "\033\[33m For external driver use DFFX1 cell from slow_vdd1v2 library. (pin: Q)      \033\[0m"
puts "\033\[36m For this purpose you can use find -libcell/find -libpin/ find -library  commands           \033\[0m"

suspend

puts "\033\[36m The reset pin <rst> is asynchron and it is important to announce that   \033\[0m"
puts "\033\[36m the path from the reset pin to sequential cells is unconstrainted.     \034\[0m"
puts "\033\[36m For that purpose use path_disable -from <...> -to <...> command.      \033\[0m"
puts "\033\[36m Instead of <...> enter name of pin/port/clock/instance.                \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"

suspend

set_attribute avoid true [find / -libcell SDFF*]
puts "\033\[36m Now we defined the absolute minimum on constraints needed for a decent \033\[0m"
puts "\033\[36m synthesis. For more control in synthesis you may also set capacitance,  \033\[0m"
puts "\033\[36m fanout and transition limits with attributes max_fanout, max_capacitance,\33\[0m"
puts "\033\[36m max_transition. Look into manuals or ask TAs for more information.     \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m Next the cpf is checked with design information and power domain       \033\[0m"
puts "\033\[36m definitions are applied. In case of errors you should check MIPS.cpf   \033\[0m"
puts "\033\[33m Proceed with resume command                                           \033\[0m"
#set_attribute max_fanout <value> /designs/$DESIGN
#set_attribute max_capacitance <value in fF> /designs/$DESIGN
#set_attribute max_transition <value in ps> /designs/$DESIGN
#path_disable -from <object> -through <object> -to <object> -name <string>
#multi_cycle -from <object> -through <object> -to <object> -name <string>
#path_delay -from <object> -through <object> -to <object> -delay <delay in ps> -name <string>
#puts "The number of exceptions is [llength [find /designs/$DESIGN -exception *]]"
#suspend

#### Read in CPF file.
apply_power_intent

check_design -unresolved

#set_attribute force_wireload <wireload name> "/designs/$DESIGN"


###################################################################################
## Define cost groups (clock-clock, clock-output, input-clock, input-output)
###################################################################################

## Uncomment to remove already existing costgroups before creating new ones.

puts "\033\[36mThe genus algorithms work better if different costgroups are defined\033\[m"
puts "\033\[36mI2C: Input-to-clock logics between primary inputs and registers \033\[m"
puts "\033\[36mC2C: clock-to-clock logics between registers \033\[m"
puts "\033\[36mC2O: Clock-to-output logics between registers and primary outputs \033\[m"
puts "\033\[36mThe group definition commands are aready written see how they work\033\[m"
puts "\033\[33mProceed with resume.                                                    \033\[0m"
suspend
#rm [find /designs/* -cost_group *]

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

puts "\033\[36m At this step you can enable additional synthesis optimization algorithms.    \033\[0m"
puts "\033\[36m Genus supports the following techniques.                               \033\[0m"
puts "\033\[36m             * Retiming with retime attribute                           \033\[0m"
puts "\033\[36m             * Clock gating                                             \033\[0m"
puts "\033\[36m             * Specification of trade-offs                              \033\[0m"
puts "\033\[36m               * Synthesis-effort vs synthesis-result trade-off         \033\[0m"
puts "\033\[36m               * Leakage Power vs Dynamic Power                         \033\[0m"
puts "\033\[36m             * Specification of maximum values                          \033\[0m"
puts "\033\[36m Depending on available cells some of the techniques may be very effective.           \033\[0m"
puts "\033\[36m For detailed information how to apply those techniques, read the       \033\[0m"
puts "\033\[36m Genus Low Power for Legacy UI manual. For first you may be just         \033\[0m"
puts "\033\[36m interested in a functional design and may introduce the optimizations  \033\[0m"
puts "\033\[36m later. \033\33m Proceed, entering resume command.                      \033\[0m"
suspend

#####################################################################################
#### Retime
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


puts "\033\[36m Now commit the power intent: this is final step before synthesis.      \033\[0m"
puts "\033\[33m commit in cpf defined power specification to the deisgn with command   \033\[0m"
puts "\033\[33m    commit_power_intent                                                 \033\[0m"
suspend
#verify_power_structure -lp_only -post_synth -detail > $_REPORTS_PATH/${DESIGN}_verify_power_struct.rpt


puts "\033\[33m####################################################################################################"
puts "\033\[33m## Synthesizing to generic "
puts "\033\[33m####################################################################################################"
puts "\033\[36m Finally the main synthesis process.                                    \033\[0m"
puts "\033\[36m First the abstract structures need to be mapped to generic gates.       \033\[0m"
puts "\033\[36m Execute the command \033\[35msyn_generic\033\[36m for this purpose.                      \033\[0m"
puts "\033\[36m Depending on you objectives you may set the syn_generic_effort to      \033\[0m"
puts "\033\[36m low,medium or high. But keep in mind that it is just an intermediate   \033\[0m"
puts "\033\[36m mapping step and high computational efforts here may not be effective. \033\[0m"

set_attribute preserve true imem
set_attribute preserve true dmem

suspend

#### Build RTL power models
##build_rtl_power_models -design $DESIGN -clean_up_netlist [-clock_gating_logic] [-relative <hierarchical instance>]
#report power -rtl



puts "\033\[33m####################################################################################################"
puts "\033\[33m## Synthesizing to gates"
puts "\033\[33m####################################################################################################"
puts "\033\[33m \nFor mapping to technology gates use syn_map \n                           \033\[0m"
puts "\033\[36m The Genus attribute syn_map_effort is controlling computational efforts\033\[0m"
puts "\033\[36m of this step.                                                          \033\[0m"

suspend


## ungroup -threshold <value>

puts "\033\[33m#######################################################################################################"
puts "\033\[33m## Optimize Netlist"
puts "\033\[33m#######################################################################################################"

## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_attribute remove_assigns true /
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign> 
##set_attribute use_tiehilo_for_const <none|duplicate|unique> /
#set_attribute syn_opt_effort low /

puts "\033\[33m For incremental optimizations of resulting netlist you can execute syn_opt (maybe several times)\033\[0m"
puts "\033\[36m Check the slack with \033\[35mreport timing\033\[36m command.                                                 \033\[0m"
puts "\033\[36m If the slack is still negative after the execution another execution of\033\[0m"
puts "\033\[36m of incremental \033\[35msyn_opt\033\[36m command might fix the timing.                          \033\[0m"
puts "\033\[36m If it does not help then only way is to relax the constraints (clock period or external delays).           \033\[0m"
suspend


puts "\033\[33m################################################################\033\[0m"
puts "\033\[33m################POST SYNTHESIS###################################\033\[0m"
puts "\033\[33m################################################################\033\[0m"

puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m            The synthesis process has finished!                         \033\[0m"
puts "\033\[36m Now check if everthing went well with report comands:                  \033\[0m"
puts "\033\[36m     * report timing gives you the delay on the most critical path.     \033\[0m"
puts "\033\[36m       * The slack should be positive.                                  \033\[0m"
puts "\033\[36m     * report power gives you post syhtesis power report.               \033\[0m"
puts "\033\[36m     * report messages gives you all the messages issued by the tool.   \033\[0m"
puts "\033\[36m       * There should be no error messages, unless you fixed them already.\033\[0m"
puts "\033\[36m If everything went well proceed to the next step with resume.          \033\[0m"
puts "\033\[36m If there are issues try to understand and fix them.                    \033\[0m"
puts "\033\[36m If you cannot fix the issues by yourself, contact the TAs             \033\[0m"
puts "\033\[36m            Paul           p.detterer@tue.nl                            \033\[0m"
puts "\033\[36m            Kamlesh        k.k.singh@tue.nl                             \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m The rest of the script writes the reports and design relevant data      \033\[0m"
puts "\033\[36m to the files. Important files are:                                     \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m    ->./gate/*.v       : the synthesized gate level netlist             \033\[0m"
puts "\033\[36m    ->./gate/*.sdf     : the standard delay format file for delay aware \033\[0m"
puts "\033\[36m                         simulation                                     \033\[0m"
puts "\033\[36m    -> *.sdc           : standard design constrait file for constraint    \033\[0m"
puts "\033\[36m                         definition in innovous. Located in p+r folder  \033\[0m"
puts "\033\[36m We hope you enjoyed your first synthesis run. For the next runs     \033\[0m"
puts "\033\[36m you should remove/comment excessive prints and add the commands     \033\[0m"
puts "\033\[36m you used to synth.scr. You can find them in genus.cmd. Ideally your \033\[0m"
puts "\033\[36m second and next runs are completelly free of suspend commands and run without errors.  \033\[0m"
puts "\033\[36m However we advice to put suspend on critical places and play with      \033\[0m"
puts "\033\[36m Genus commands there. It is also what real IC-Designers do to achieve \033\[0m"
puts "\033\[36m the needed performance. This is last suspended section. Bye bye!:)       \033\[0m"
suspend



puts "######################################################################################################"
puts "## Write reports                                     "
puts "######################################################################################################"

report area         > ./report/${DESIGN}_cpf.area
report timing       > ./report/${DESIGN}_cpf.timing
report gates        > ./report/${DESIGN}_cpf.gates
report design_rules > ./report/${DESIGN}_cpf.rules
report power        > ./report/${DESIGN}_cpf.power
report clock_gating > ./report/${DESIGN}_cpf.gating
report summary      > ./report/${DESIGN}_cpf.summary


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
