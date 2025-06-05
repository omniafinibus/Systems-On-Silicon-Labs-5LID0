set libdir /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing

set slow_HV_a $GPDK045/gsclib045_hvt/timing/slow_vdd1v2_basicCells_hvt.lib
set slow_HV_b $GPDK045/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib
set slow_HV_c /home/sos23/sos23019/lab2/mMIPS/synth/lib/MEM1_256X32_slow.lib
set slow_HV_lib "$slow_HV_a $slow_HV_b $slow_HV_c"

set slow_HV_lib "$libdir/slow_vdd1v2_basicCells.lib $libdir/slow_vdd1v2_extvdd1v0.lib $libdir/slow_vdd1v2_extvdd1v2.lib ./lib/MEM1_256X32_slow.lib"

set slow_LV_a $GPDK045/gsclib045_lvt/timing/slow_vdd1v0_basicCells_lvt.lib
set slow_LV_b $GPDK045/gsclib045/timing/slow_vdd1v0_extvdd1v2.lib
set slow_LV_lib "$slow_LV_a $slow_LV_b"

set slow_LV_lib "$libdir/slow_vdd1v0_basicCells.lib $libdir/slow_vdd1v0_extvdd1v2.lib $libdir/slow_vdd1v0_extvdd1v0.lib ./lib/MEM1_256X32_slow.lib"

set VDD1_name default_voltage_net
set VDD1_voltage 1.2
set VDD2_name memory_voltage_net
set VDD2_voltage 1.2

set PD1 default_power_domain
set PD2 memory_power_domain
set PD2_inst_list "imem dmem"

set NC1 def_net
set NC2 mem_net 
