create_library_set -name cadence45_bc_HV_lib\
   -timing\
    [list /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v2_basicCells.lib\
    /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v2_extvdd1v0.lib\
    ../synth/lib/MEM1_256X32_fast.lib]
create_library_set -name cadence45_bc_LV_lib\
   -timing\
    [list /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v0_basicCells.lib\
    /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v0_extvdd1v2.lib]
create_library_set -name cadence45_wc_HV_lib\
   -timing\
    [list /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib\
    /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_extvdd1v0.lib\
    ./../synth/lib/MEM1_256X32_slow.lib]
create_library_set -name cadence45_wc_LV_lib\
   -timing\
    [list /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib\
    /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_extvdd1v2.lib]
create_op_cond -name PD1_PVT_1P1V_0C -library_file /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v0_basicCells.lib -P 1 -V 1.1 -T 0
create_op_cond -name PD2_PVT_1P32V_0C -library_file /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v2_basicCells.lib -P 1 -V 1.32 -T 0
create_op_cond -name PD1_PVT_0P9V_125C -library_file /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib -P 1 -V 0.9 -T 125
create_op_cond -name PD2_PVT_1P08V_125C -library_file /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v2_basicCells.lib -P 1 -V 1.08 -T 125
create_rc_corner -name rc_tech\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 25\
   -qx_tech_file /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/qrc/qx/gpdk045.tch
create_delay_corner -name dc_wc\
   -library_set cadence45_wc_HV_lib\
   -opcond_library slow_vdd1v2\
   -opcond PD1_PVT_1P08V_125C\
   -rc_corner rc_tech
update_delay_corner -name dc_wc -power_domain PD1\
   -library_set cadence45_wc_HV_lib\
   -opcond_library slow_vdd1v2\
   -opcond PD1_PVT_1P08V_125C
create_delay_corner -name dc_bc\
   -library_set cadence45_bc_HV_lib\
   -opcond_library fast_vdd1v2\
   -opcond PD1_PVT_1P32V_0C\
   -rc_corner rc_tech
update_delay_corner -name dc_bc -power_domain PD1\
   -library_set cadence45_bc_HV_lib\
   -opcond_library fast_vdd1v2\
   -opcond PD1_PVT_1P32V_0C
create_constraint_mode -name _default_constraint_mode_\
   -sdc_files\
    [list signoffTimingReports/.sd.6917.024802.atso.dat/mmmc/modes/_default_constraint_mode_/_default_constraint_mode_.sdc]
create_analysis_view -name wc_view -constraint_mode _default_constraint_mode_ -delay_corner dc_wc -latency_file signoffTimingReports/.sd.6917.024802.atso.dat/mmmc/views/wc_view/latency.sdc
create_analysis_view -name bc_view -constraint_mode _default_constraint_mode_ -delay_corner dc_bc -latency_file signoffTimingReports/.sd.6917.024802.atso.dat/mmmc/views/bc_view/latency.sdc
set_analysis_view -setup [list wc_view] -hold [list bc_view]
