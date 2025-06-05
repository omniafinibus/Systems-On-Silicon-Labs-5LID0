################################################################################
##                                                                            ##
##  This confidential and proprietary software may be used only               ##
##  as authorized by a licensing agreement from CoWare, Inc.                  ##
##  In the event of publication, the following notice is applicable:          ##
##                                                                            ##
##      (c) COPYRIGHT 2001-2009 COWARE, INC.                                  ##
##             ALL RIGHTS RESERVED                                            ##
##                                                                            ##
##  The entire notice above must be reproduced on all authorized copies.      ##
##                                                                            ##
################################################################################
##
##  This file was generated automatically by
##  CoWare Processor Generator!
##  Version 2009.1.1 Linux -- May, 2009
## 
##
##      FileName: makefile
##      Date:     Mon Apr 13 2015
## 	Modified: Hailong Jiao
## 
##  Fry Mar 22 2019
##		Modifications by Paul Detterer
################################################################################


export WORKLIB=work

# Technology location
export GPDK045
TOP_MODULE = testbench

# Tool settings
# CLOCK TIME PERIOD IN nanosecond (Can be modifed to automate the flow for different frequency
CLOCK_TIME_PERIOD = 9000
###### For autoamting use make sim or sim_synth arg1=clock_period_value_in_nanosecond
CLOCK_TIME_PERIOD ?= $(arg1)
#
VCOMP = ncvlog
VCOMP_OPTIONS = -nocop -v01 -incdir ${SRC_RTL}/TOP/verilog -w  
VCOMP_OPTIONS1 = -define SYNTH -incdir ${SRC_RTL}/TOP/verilog -nocop -v01 -w 
#-defparam testbench:delay10=20
VELAB = ncelab
VELAB_OPTIONS = -nocop -access +rwc -defparam testbench.delay10=${CLOCK_TIME_PERIOD} -timescale 1ns/1ps -work ${LIB}
VSIM = ncsim
VSIM_OPTIONS = -nocop


# settings for RTL simulation
SRC_RTL    = ../rtl
SCR_NETLIST = ../synth/gate
LIB         = work
SOURCE_TESTBENCH = ${SRC_RTL}/TB/verilog/testbench.v
SOURCES    = ${SRC_RTL}/TOP/verilog/mmips_defines.v   \
	${SRC_RTL}/MMIPS/verilog/add.v \
	${SRC_RTL}/MMIPS/verilog/alu.v \
	${SRC_RTL}/MMIPS/verilog/ctrl.v \
	${SRC_RTL}/MMIPS/verilog/hazard_ctrl.v   \
	${SRC_RTL}/MMIPS/verilog/imm2word.v       \
	${SRC_RTL}/MEM/verilog/MEM1_256X32.v   \
	${SRC_RTL}/MMIPS/verilog/mmips.v   \
	${SRC_RTL}/MMIPS/verilog/register.v   \
	${SRC_RTL}/MMIPS/verilog/shift.v        \
	${SRC_RTL}/MMIPS/verilog/aluctrl.v   \
	${SRC_RTL}/MMIPS/verilog/branch_ctrl.v \
	${SRC_RTL}/MMIPS/verilog/decoder.v   \
	${SRC_RTL}/MMIPS/verilog/hazard.v      \
	${SRC_RTL}/MMIPS/verilog/memdev.v        \
	${SRC_RTL}/TOP/verilog/mMIPS_system.v       \
	${SRC_RTL}/TOP/verilog/MIPS_to_AHB.v       \
	${SRC_RTL}/TOP/verilog/AHB_MUX.v       \
	${SRC_RTL}/MEM/verilog/IMEM.v       \
	${SRC_RTL}/MEM/verilog/DMEM.v       \
	${SRC_RTL}/TOP/verilog/AHB_DECODER.v       \
	${SRC_RTL}/cmsdk_ahb_to_sram/verilog/cmsdk_ahb_to_sram.v \
	${SRC_RTL}/cmsdk_ahb_to_apb/verilog/cmsdk_ahb_to_apb.v \
	${SRC_RTL}/int_ctrl/verilog/int_ctrl.v       \
	${SRC_RTL}/int_ctrl/verilog/int_ctrl_if.v       \
	${SRC_RTL}/int_ctrl/verilog/int_ctrl_reg.v       \
	${SRC_RTL}/MMIPS/verilog/mux.v     \
	${SRC_RTL}/MMIPS/verilog/regfile16.v \
	${SRC_RTL}/MMIPS/verilog/rom.v        \
	${SRC_RTL}/MMIPS/verilog/signextend.v \
	${SRC_RTL}/AES/verilog/aes_core.v  \
	${SRC_RTL}/AES/verilog/aes_w.v  \
        ${SRC_RTL}/AES/verilog/datapath.v \
	${SRC_RTL}/AES/verilog/host_interface.v \
	${SRC_RTL}/AES/verilog/mix_columns.v \
	${SRC_RTL}/AES/verilog/sBox.v \
	${SRC_RTL}/AES/verilog/aes_ip.v \
        ${SRC_RTL}/AES/verilog/control_unit.v \
	${SRC_RTL}/AES/verilog/data_swap.v  \
	${SRC_RTL}/AES/verilog/key_expander.v   \
	${SRC_RTL}/AES/verilog/sBox_8.v   \
	${SRC_RTL}/AES/verilog/shift_rows.v \


NETLIST =    ${SCR_NETLIST}/mMIPS_system.v 

GPDK045 = /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/verilog
SOURCES_STD_LIB	  =   	${SRC_RTL}/MEM/verilog/MEM1_256X32.v \
	     				$(GPDK045)/fast_vdd1v2_basicCells.v \
	     				$(GPDK045)/fast_vdd1v0_extvdd1v2.v \
	     				$(GPDK045)/fast_vdd1v2_extvdd1v0.v


targets:
	@echo "targets: [ dir | comp | elab | gui | comp_synth | elab_synth | gui_synth | tcf | clean ]"

dir:
	@if [ ! -d ${LIB} ]; then mkdir ${LIB} ; fi

comp: dir ${SOURCES} 
	@if [ ! -d ${LIB} ]; then mkdir ${LIB} ; fi
	${VCOMP} ${VCOMP_OPTIONS} ${LIB} ${SOURCES} ${SOURCE_TESTBENCH} 

elab: comp
	${VELAB} ${VELAB_OPTIONS} ${TOP_MODULE} 

sim: elab 	
	${VSIM} ${VSIM_OPTIONS} ${LIB}.${TOP_MODULE} -input run.tcl

gui: elab 	
	${VSIM} -GUI ${VSIM_OPTIONS} ${LIB}.${TOP_MODULE}	

comp_synth: dir ${SOURCES_STD_LIB} ${SOURCE_TESTBENCH}
	@if [ ! -d ${LIB} ]; then mkdir ${LIB} ; fi
	${VCOMP} ${VCOMP_OPTIONS1} ${LIB} ${SOURCES_STD_LIB} ${NETLIST} ${SOURCE_TESTBENCH} 

elab_synth: comp_synth
	${VELAB} ${VELAB_OPTIONS} -initmem0 -initreg0 -ncinitialize  ${TOP_MODULE} 

sim_synth: elab_synth	
	${VSIM} -input run.tcl ${VSIM_OPTIONS} ${LIB}.${TOP_MODULE} -ncinitialize 0 

gui_synth: elab_synth	
	${VSIM} -GUI -input init.tcl ${VSIM_OPTIONS} ${LIB}.${TOP_MODULE} -ncinitialize 0 

tcf: elab_synth
	${VSIM} -input test.tcl  ${LIB}.${TOP_MODULE}

clean:
	rm -rf ${WORKLIB} waves.shm
	rm -rf ncelab.log ncsim.key ncsim.log ncvlog.log simvision* tcf.dump signals* *log ram.dump.hex	
	rm *.X
