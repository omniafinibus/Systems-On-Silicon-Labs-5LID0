
puts "\033\[33m################################################################"
puts         "#################  Define  CPF   variables #####################"
puts 	     "################################################################/033\[0m\n"
puts "\033\[36mAll the power domain related definitions are usually stored in a \033\[35mcommon power format (\033\[32mcpf\033\[35m)"
puts "\033\[36mThis script is executed from the main synthesis script by the command source script/prepare_CPF.tcl"
puts "\033\[36mIt helps you to prepare your own CPF description for the following syntheis steps.                 "
puts "\033\[36mFirst you need to define the delay and power behaviour of the standard and memory cells in the     "
puts "\033\[36mgiven technology.                                                                                  "
puts "\033\[33mDefine the library sets for the timing analysis"
puts "\033\[36mFor analysis and mitigation of all possible failures, several conditions and process variation corners need to be included."
puts "\033\[36mHence multiple analysis vies are created and multiplie lib models are of same cell are included."
puts "\033\[36mIn our lab only two corners are considered: slowest possible and fastest possible."
puts "\033\[36mYou will have two power domains for voltages of \033\[35m1.2V and  1.0V"
puts "\033\[36m Hence, you need to include \033\[33mfour library sets"
puts "\033\[36m\t* The variable \033\[35mslow_\033\[32mHV\033\[35m_libs \033\[35mdefines the libraries for \033\[32mH\033\[36migher \033\[32mV\033\[36moltage domain"
puts "\t* The variable slow_LV_libs defines the libraties for Lower  voltage domain"
puts "\t* Both variables are lists"
puts "\t\t* In tcl the lists are strings with words inside separated by space"
puts "\t\t* list example: \033\[35mset list1 \"a b c d\""
puts "\t\t* \033\[36madding to the list: \033\[35mlappend list1 \"e f\""
puts "\t* \033\[36mThe libraries needed for every domain through the synthesis:"
puts "\t\ta. library for timing/power behaviour of regular cells under given voltage"
puts "\t\tb. library for timing/power behaviour of memory cells under given voltage"
puts "\t\tc. library for timing/power behaviour of level shifter from this to all other power domains"
puts "\033\[32mTIP   : \033\[36mGPDK45 variable hold the location of the technology folder with all libraries necessary"
puts "\033\[34mHINT 1:\033\[36m Look for worst case conditions, because the product of the synthesis should worst under worst possible conditions"
puts "\033\[34mHINT 2: \033\[36mWhile picking the worst case behaviour libraries remember: \"hold\" violations are not considered yet\033\[0m"
puts "\033\[34mHINT 3: \033\[36mThe lib files are in \$GPDK045/gsclib045_all_v4.4/gsclib045/timing/.\033\[0m"
puts "\033\[33m-----> Set the library for slowest basic cells for voltage of 1.2V in variable \033\[35mslow_HV_a\033\[0m"
#set GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib a
#set $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib a
#set a $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib 
#set a GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib 
suspend
puts "\033\[33m-----> Set the library for slowest level shifter cells from voltage 1.2V to 1.0V (1.0V is exTernal voltage) in \033\[35mslow_HV_b \033\[0m"
#set b GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib 
#set b $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib 
#set $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib b
#set b GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib 
suspend
puts "\033\[33m-----> Set the library for slowest memory cells for voltage of 1.2V in \033\[35mslow_HV_c\033\[0m"
puts "\033\[34mHINT:\033\[36m the lib files of the memory are in lib\033\[0m"
#set c MEM1_256X32_slow.lib 
#set ./lib/MEM1_256X32_slow.lib c
#set c ./lib/MEM1_256X32_slow.lib 
#set c ./lib/MEMx_256X32_slow.lib 
suspend
puts "\033\[33m-----> Bundle all the libraries in a list under name \033\[35mslow_HV_libs\033\[0m"
puts "-----> \033\[32mset slow_HV_lib \"\$slow_HV_a \$slow_HV_b \$slow_HV_c\"\033\[0m"
#set slow_HV_lib "$a $b $c"
suspend
puts "\n\033\[33m------>***<--------\n"
puts "\033\[33m-----> Set the libarary for the slowest basic cells for voltage of 1.0V in variable slow_LV_a\033\[0m"
#set a GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib 
#set $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib a
#set variable $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib
#set a $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib 
suspend
puts "\033\[33m ----> Set the library for the slowest level shifter cells from voltage 1.0V to 1.2V (1.2V is EXTernal voltage) in variable \033\[35mslow_LV_b"
suspend
puts "\033\[33m-----> Set the library for the slowest memory cells for voltage of 1.0V in variable slow_LV_c\033\[0m"
puts "\033\[34mHint:\033\[36m The script is designed to be general, but if you know    \033\[0m"
puts "\033\[36m     you will have no  memory at Low Voltage you may as well skip this  \033\[0m"
puts "\033\[36m     step. Same counts for every of the following steps.                 \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
suspend
puts "\033\[33m-----> Bundle all the libraries in a list under name \033\[35mslow_LV_lib\033\[0m"
#set slow_LV_libs "$a $b $c"
suspend
###################################################################################
puts "\033\[33m-----> Set the library for the fastest basic cells for voltage of 1.2V in variable \033\[35mfast_HV_a\033\[0m"
#set GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib a
#set $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib a
#set a $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib 
#set a GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib 
suspend
puts "\033\[33m-----> Set the library for the fastest level shifter cells from voltage 1.2V to 1.0V (1.0V is EXTernal voltage) in \033\[35mfast_HV_b \033\[0m"
#set b GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib 
#set b $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib 
#set $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib b
#set b GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib 
suspend
puts "\033\[33m-----> Set the library for the fastest memory cells for voltage of 1.2V in \033\[35mfast_HV_c\033\[0m"
#set c MEM1_256X32_slow.lib 
#set ./lib/MEM1_256X32_slow.lib c
#set c ./lib/MEM1_256X32_slow.lib 
#set c ./lib/MEMx_256X32_slow.lib 
suspend
puts "\033\[33m-----> Bundle all the libraries in a list under name fast_HV_lib"
puts "-----> \033\[32mset slow_HV_lib \"\$fast_HV_a \$fast_HV_b \$fast_HV_c\"\033\[0m"
#set slow_HV_lib "$a $b $c"
#set slow_HV_libs "$a $b $c"
suspend
puts "\n\033\[33m------>***<--------\n"
puts "\033\[33m-----> Set the libarary for fastest basic cells for voltage of 1.0V in variable \033\[35mfast_LV_a\033\[0m"
#set a GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib 
#set $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib a
#set variable $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib
#set a $GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib 
suspend
puts "\033\[33m ----> Set the library for fastest level shifter cells from voltage 1.0V to 1.2V (1.2V is EXTernal voltage) in variable \033\[35mfast_LV_b\033\[0m"
suspend
puts "\033\[33m-----> Set the library for fastest memory cells for voltage of 1.0V in variable fast_LV_c\033\[0m"
suspend
puts "\033\[33m-----> Bundle all the libraries in a list under name \033\[35mfast_LV_lib\033\[0m"
#set slow_LV_libs "$a $b $c"
suspend
puts "\033\[36m Now you defined four lists"
puts "\033\[36m Those tcl list variables are used in cpf file to define the library sets"
puts "\033\[36m You can open \033\[35mMIPS.cpf \033\[36mand look how they are used.                      \033\[0m"
puts "\033\[36m The cpf command for this is \033\[35mdefine_libraty_set -name set_name -libraries lib_list.  \033\[0m"
puts "\033\[36m Instead of lib_list you can find there the variables, you just defined     \033\[0m"
suspend

puts "\033\[36m Now you should define the supply voltage net names for voltages of 1.0V and 1.2V     \033\[0m"
puts "\033\[36m A CPF comands  for that in the MIPS.cpf file  are:             \033\[0m"
puts "\033\[36m         * create_power_nets -nets \$VDD1_name -voltage \$VDD1_voltage                    \033\[0m"
puts "\033\[36m         * create_power_nets -nets \$VDD2_name -voltage \$VDD2_voltage \033\[0m"
puts "\033\[36m         * create_ground_nets -nets VSS                         \033\[0m"
puts "\033\[36m                                                                \033\[0m"
puts "\033\[33m Define the variables \$VDD1_name, \$VDD1_voltage and \$VDD2_name, \$VDD2_voltage     \033\[0m"
puts "\033\[34m HINT: \033\[36m For first, make VDD1 to 1.0V and VDD2 to 1.2V           \033\[0m"
suspend
puts "\033\[36m Now define the power domains and associate them with the instances from the design.       \033\[0m"
puts "\033\[36m The CPF commands for this are:                                 \033\[0m"
puts "\033\[36m     create_power_domain -name \$PD1 -default                   \033\[0m"
puts "\033\[36m     create_power_domain -name \$PD2 -instances \$PD2_inst_list     \033\[0m"
puts "\033\[36m The option -default covers all instances                               \033\[0m"
puts "\033\[36m The commands are already written you need to define PD1,PD2, PD2_inst_list. \033\[0m"
puts "\033\[36m         * PD1 and PD2 are just names define them as you wish.          \033\[0m"
puts "\033\[36m         * inst_list must be a tcl list of instance names               \033\[0m"
puts "\033\[36m         * interesting instance names from the top level of MMIPS:      \033\[0m"
puts "\033\[36m           * imem sram cell for instruction memory                      \033\[0m"
puts "\033\[36m           * dmem sram cell for data memory                             \033\[0m"
puts "\033\[36m           * mMIPS the microcotroller                                   \033\[0m"
puts "\033\[36m           * u_aes the AES decryption core                              \033\[0m"
puts "\033\[33m Define PD1, PD2, PD2_inst_list.                                            \033\[0m"
suspend
puts "\033\[36m Now associate the defined domains with defined nets.                   \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m The CPF commands:                                                      \033\[0m"
puts "\033\[35m    update_power_domain -name \$PD1 -primary_power_net \$VDD1_name -primary_ground_net VSS \033\[0m"
puts "\033\[35m    update_power_domain -name \$PD2 -primary_power_net \$VDD2_name -primary_ground_net VSS \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m And for the net connection:                                            \033\[0m"
puts "\033\[35m    create_global_connection -domain \$PD1 -net \$VDD1_name -pins VDD    \033\[0m"
puts "\033\[35m    create_global_connection -domain \$PD2 -net \$VDD2_name -pins VDD    \033\[0m"
puts "\033\[35m    create_global_connection -domain \$PD1 -net \$VDD2_name -pins ExtVDD    \033\[0m"
puts "\033\[35m    create_global_connection -domain \$PD2 -net \$VDD1_name -pins ExtVDD    \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m When there are more than one power supply the tool needs a clear       \033\[0m"
puts "\033\[36m definition how to connect them to the cells.                           \033\[0m"
puts "\033\[36m The pins are taken from the cell definition of the corresponding lib   \033\[0m"
puts "\033\[36m files. ExtVDD are extra power pins of the level shifters, because      \033\[0m"
puts "\033\[36m generally they need to be connected to both power supplies. This step  \033\[0m"
puts "\033\[36m is already well defined and you do not need to do anything. The script \033\[0m"
puts "\033\[36m is stopped for the sake of clarity and function of those commands.   \033\[0m"
puts "\033\[36m  You do not need to do anything here. Proceed with resume command.         \033\[0m"
suspend
puts "\033\[36m The level shifter cells mentioned above are necessary for comain       \033\[0m"
puts "\033\[36m interconnection. Which level shifter cells are used, is defined with   \033\[0m"
puts "\033\[36m following commands:                                                    \033\[0m"
puts "\033\[36m      * define_level_shifter_cell defines the specific cell to use      \033\[0m"
puts "\033\[36m      * create_level_shifter_rule defines the domain connection rule    \033\[0m"
puts "\033\[36m      * update_level_shifter_rules associates a cell with a rule        \033\[0m"
puts "\033\[36m An example definition is aready prepared in CPF file and should be     \033\[0m"
puts "\033\[36m functional. This step is merely for your information                   \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
suspend
puts "\033\[36m Now create the operating conditions and associate them with power      \033\[0m"
puts "\033\[36m domains. This is the point where perviously defined library sets are   \033\[0m"
puts "\033\[36m connected with design over the corresponding power domains.            \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m The CPF commands:                                                      \033\[0m"
puts "\033\[35m  create_nominal_condition -name \$NC1 -voltage \$VDD1_voltage          \033\[0m"
puts "\033\[35m  create_nominal_condition -name \$NC2 -voltage \$VDD2_voltage          \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[35m  update_nominal_condition -name \$NC1 -library_set cadence45_wc_HV_lib \033\[0m"
puts "\033\[35m  update_nominal_condition -name \$NC2 -library_set cadence45_wc_LV_lib \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m  ! cadence45_wc_HV_lib, cadence45_wc_LV_lib library sets are defined  \033\[0m"
puts "\033\[36m    with previously mentioned define_library_set command.               \033\[0m"
puts "\033\[36m And finally, the connection of the condition and power domain is made          \033\[0m"
puts "\033\[36m by following command.                                                  \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[35m  create_power_mode -name PM1 -domain_conditions \"\$PD1@\$NC1 \$PD2@\$NC2\" -default \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m  The definition of power domains, nets and condition is    \033\[0m"
puts "\033\[36m  necessary to express different circuit oprationg conditions and threir\033\[0m"
puts "\033\[36m  ans their proper analysis.                                            \033\[0m"
puts "\033\[33m  Define the names for NC1, NC2. Those are just labels, so everything is okay \033\[0m"
suspend

puts "\033\[36m  The included libraries may define multiple operating corners. Hence \033\[0m"
puts "\033\[36m  the CPF file should also specify which oprating corner should be used \033\[0m"
puts "\033\[36m  for the timing and power analysis during the synthesis process.       \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m  The CPF commands:                                                     \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m   create_operating_corner -name slow_LV_rcworst \                      \033\[0m"
puts "\033\[36m   		-library_set cadence45_wc_LV_lib \                     \033\[0m"
puts "\033\[36m   		-process 1 \                                           \033\[0m"
puts "\033\[36m   		-voltage 0.9  \                                        \033\[0m"
puts "\033\[36m   		-temperature 125                                       \033\[0m"
puts "\033\[36m   create_operating_corner -name fast_LV_rcbest \                       \033\[0m"
puts "\033\[36m   		  -library_set cadence45_bc_LV_lib \                   \033\[0m"
puts "\033\[36m   		  -process 1 \                                         \033\[0m"
puts "\033\[36m   		  -voltage 1.1  \                                      \033\[0m"
puts "\033\[36m   		  -temperature 0                                       \033\[0m"
puts "\033\[36m   create_operating_corner -name slow_HV_rcworst \                      \033\[0m"
puts "\033\[36m   		  -library_set cadence45_wc_HV_lib \                   \033\[0m"
puts "\033\[36m   		  -process 1 \                                         \033\[0m"
puts "\033\[36m   		  -voltage 1.08 \                                      \033\[0m"
puts "\033\[36m   		  -temperature 125                                     \033\[0m"
puts "\033\[36m   create_operating_corner -name fast_HV_rcbest  \                      \033\[0m"
puts "\033\[36m                    -library_set cadence34_wc_HV_lib                                   \033\[0m"
puts "\033\[36m                    -process 1 \                                                       \033\[0m"
puts "\033\[36m                    -voltage 1.32 \                                                    \033\[0m"
puts "\033\[36m                    -temperature 0                                                     \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m  ! Noticed the backslash at the end of lines? This is how you can break\033\[0m"
puts "\033\[36m    a long comand on several lines                                      \033\[0m"
puts "\033\[36m  ! Noticed the voltages are different than specified above? It is      \033\[0m"
puts "\033\[36m    correct. Becous for fastes and slowest cases also a possible        \033\[0m"
puts "\033\[36m    supply voltage variation of 10% is considered.                      \033\[0m"
puts "\033\[36m  ! These commands are already written in CPF file.                     \033\[0m"


puts "\033\[36m  Now the timing/power analysis views need to be created. The slowest   \033\[0m"
puts "\033\[36m  operational corner is considered to ensure that even slowest possible \033\[0m"
puts "\033\[36m  circuit under worst condition does not provide stable output after the\033\[0m"
puts "\033\[36m  register setup time (setup violation). The fastest operational corner \033\[0m"
puts "\033\[36m  is used to identify and correct the hold time violations, the cases   \033\[0m"
puts "\033\[36m  when the circuit is too fast and next output arrives before the       \033\[0m"
puts "\033\[36m  register can stabilize the previous value (hold violation).           \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m  The CPF commands:                                                     \033\[0m"
puts "\033\[36m     create_analysis_view -name AV_slow_setup                        \        \033\[0m"
puts "\033\[36m     	-mode PM1 \                                                    \033\[0m"
puts "\033\[36m     	-domain_corners \"\$PD1@\$slowOC1 \$PD2@\$slowOC2\"                     \033\[0m"
puts "\033\[36m     create_analysis_view -name AV_fast_hold   \        \033\[0m"
puts "\033\[36m     	-mode PM1 \                                                    \033\[0m"
puts "\033\[36m 	-domain_corners \"\$PD1@\$fastOC1 \$PD2@\$fastOC2\"    \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[33m   Use the operating corner names from previous section to define the   \033\[0m"
puts "\033\[33m   variables fastOC1,  fastOC2, slowOC1, slowOC2.                       \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
suspend


puts "\033\[32m  The CPF file definition is complete. Now your input is inserted        \033\[0m"
puts "\033\[32m  in newMIPS.cpf file and this file is loaded by Genus synthesis tool.  \033\[0m"
puts "\033\[32m  after you enter resume. If there are some complications, please       \033\[0m"
puts "\033\[32m  contact the TAs.                                                      \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"



set fid_in [open "cpf/newMIPS_tmpl.cpf" r]
set fid_out [open "cpf/newMIPS.cpf" w]
puts $fid_out [subst -nobackslashes [read $fid_in]]
close $fid_in
close $fid_out

