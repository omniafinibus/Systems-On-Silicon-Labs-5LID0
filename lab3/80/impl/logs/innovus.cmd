#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Jun 22 02:34:52 2024                
#                                                     
#######################################################

#@(#)CDS: Innovus v19.11-s128_1 (64bit) 08/20/2019 20:54 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 19.11-s128_1 NR190815-2055/19_11-UB (database version 18.20, 469.7.1) {superthreading v1.51}
#@(#)CDS: AAE 19.11-s034 (64bit) 08/20/2019 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 19.11-s040_1 () Aug  1 2019 08:53:57 ( )
#@(#)CDS: SYNTECH 19.11-e010_1 () Jul 15 2019 20:31:02 ( )
#@(#)CDS: CPE v19.11-s006
#@(#)CDS: IQuantus/TQuantus 19.1.2-s245 (64bit) Thu Aug 1 10:22:01 PDT 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
set_flowkit_db flow_edit_wildcard_end_steps {}
set_flowkit_db flow_edit_wildcard_start_steps {}
set_flowkit_db flow_footer_tcl {}
set_flowkit_db flow_header_tcl {}
set_flowkit_db flow_metadata {}
set_flowkit_db flow_step_begin_tcl {}
set_flowkit_db flow_step_check_tcl {}
set_flowkit_db flow_step_end_tcl {}
set_flowkit_db flow_step_order {}
set_flowkit_db flow_summary_tcl {}
set_flowkit_db flow_template_feature_definition {}
set_flowkit_db flow_template_type {}
set_flowkit_db flow_template_version {}
set_flowkit_db flow_user_templates {}
set_flowkit_db flow_branch {}
set_flowkit_db flow_caller_data {}
set_flowkit_db flow_current {}
set_flowkit_db flow_hier_path {}
set_flowkit_db flow_database_directory dbs
set_flowkit_db flow_exit_when_done false
set_flowkit_db flow_history {}
set_flowkit_db flow_log_directory logs
set_flowkit_db flow_mail_on_error false
set_flowkit_db flow_mail_to {}
set_flowkit_db flow_metrics_file {}
set_flowkit_db flow_metrics_snapshot_parent_uuid {}
set_flowkit_db flow_metrics_snapshot_uuid 4acf32af-0d55-4dbb-bb9f-e9b0fca512af
set_flowkit_db flow_overwrite_database false
set_flowkit_db flow_report_directory reports
set_flowkit_db flow_run_tag {}
set_flowkit_db flow_schedule {}
set_flowkit_db flow_script {}
set_flowkit_db flow_starting_db {}
set_flowkit_db flow_status_file {}
set_flowkit_db flow_step_canonical_current {}
set_flowkit_db flow_step_current {}
set_flowkit_db flow_step_last {}
set_flowkit_db flow_step_last_msg {}
set_flowkit_db flow_step_last_status not_run
set_flowkit_db flow_step_next {}
set_flowkit_db flow_working_directory .
set init_verilog ../synth/db/1pd/mMIPS_system.v
set init_design_netlisttype Verilog
set init_design_settop 1
set init_top_cell mMIPS_system
set init_mmmc_file ../synth/db/1pd/mMIPS_system.mmode.tcl
set init_lef_file {/opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/lef/gsclib045_tech.lef /opt/tools/technology/cadence/gpdk/45nm/gsclib045_all_v4.4/gsclib045/lef/gsclib045_macro.lef ../synth/lef/MEM1_256X32.lef}
set fp_core_cntl aspect
set fp_aspect_ratio 1.0000
set extract_shrink_factor 1.0
set init_assign_buffer 0
set init_cpf_file ../synth/db/1pd/mMIPS_system.cpf
init_design
um::read_metric -id current ../synth/db/1pd/mMIPS_system.metrics.json
set_global timing_apply_default_primary_input_assertion false
set_global timing_clock_phase_propagation both
setAnalysisMode -asyncChecks noAsync
setExtractRCMode -layerIndependent 1
setPlaceMode -reorderScan false
setExtractRCMode -engine preRoute
read_power_intent -cpf ../synth/db/1pd/mMIPS_system.cpf
commit_power_intent -keepRows -powerDomain -power_switch
set edi_pe::pegConsiderMacroLayersUnblocked 1
getNanoRouteMode -routeStrictlyHonorNonDefaultRule -quiet
getNanoRouteMode -routeBottomRoutingLayer -quiet
getNanoRouteMode -routeTopRoutingLayer -quiet
set edi_pe::pegPreRouteWireWidthBasedDensityCalModel 1
setDesignMode -process 45
setMultiCpuUsage -remoteHost 1 -cpuPerRemoteHost 2 -localCpu 2
setExtractRCMode -lefTechFileMap script/layer.mapfile
setAnalysisMode -analysisType onChipVariation
setAnalysisMode -cppr both
setDelayCalMode -SIAware true
set_ccopt_property target_skew auto
set_ccopt_property use_inverters true
set_ccopt_property max_source_to_sink_net_length 300
setOptMode -holdTargetSlack 0.1
set_ccopt_property buffer_cells {CLKBUFX2 CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20}
set_ccopt_property inverter_cells {CLKINVX1 CLKINVX2 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8 CLKINVX12 CLKINVX16 CLKINVX20}
setOptMode -holdFixingCells {DLY1X1 DLY1X4 DLY2X1 DLY2X4 DLY3X1 DLY3X4 DLY4X1 DLY4X4}
add_ndr -width_multiplier {M1:M11 2} -spacing_multiplier {M1:M11 2} -name 2W2S -generate_via
create_route_type -name top -non_default_rule 2W2S -bottom_preferred_layer Metal8 -top_preferred_layer Metal9 -shield_net VSS -shield_side both_side -preferred_routing_layer_effort high
create_route_type -name trunk -non_default_rule 2W2S -bottom_preferred_layer Metal6 -top_preferred_layer Metal7 -shield_net VSS -shield_side both_side -preferred_routing_layer_effort high
create_route_type -name leaf -bottom_preferred_layer Metal4 -top_preferred_layer Metal5 -preferred_routing_layer_effort high
set_ccopt_property route_type -net_type top top
set_ccopt_property route_type -net_type trunk trunk
set_ccopt_property route_type -net_type leaf leaf
setNanoRouteMode -routeBottomRoutingLayer 2 -routeTopRoutingLayer 9
setOptMode -maxLength 900
setNanoRouteMode -routeAntennaCellName ANTENNA
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeInsertDiodeForClockNets true
setNanoRouteMode -routeUseAutoVia true
setNanoRouteMode -droutePostRouteSwapVia multiCut
setNanoRouteMode -drouteUseMultiCutViaEffort high
floorPlan -site CoreSite -r 1.2 0.8 20.0 20.0 20.0 20.0
setPinConstraint -corner_to_pin_distance 10
setPinConstraint -pin * -spacing 125 -layer {Metal4 Metal5}
assignIoPins -pin *
create_relative_floorplan -place imem/u_mem -ref_type core_boundary -orient R90 -horizontal_edge_separate {1  0  1} -vertical_edge_separate {0  0  0}
create_relative_floorplan -place dmem/u_mem -ref_type core_boundary -orient MX90 -horizontal_edge_separate {1  0  1} -vertical_edge_separate {2  0  2}
addHaloToBlock 3.6 3.6 3.6 3.6 -snapToSite -allMacro
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer Metal11 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VDD2 VSS} -type core_rings -follow core -layer {top Metal11 bottom Metal11 left Metal10 right Metal10} -width {top 4 bottom 4 left 4 right 4} -spacing {top 2 bottom 2 left 2 right 2} -offset {top 2 bottom 2 left 2 right 2} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer Metal11 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {VDD2 VSS} -layer Metal10 -direction vertical -width 4 -spacing 2 -number_of_sets 3 -start_from left -start_offset 50 -stop_offset 50 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit Metal11 -padcore_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid None
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer Metal11 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {VDD2 VSS} -layer Metal11 -direction horizontal -width 4 -spacing 2 -number_of_sets 9 -start_from bottom -start_offset 50 -stop_offset 50 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit Metal11 -padcore_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid None
setSrouteMode -viaConnectToShape { ring stripe } -targetSearchDistance 20
sroute -nets {VDD2 VSS} -connect { corePin } -layerChangeRange { Metal1(1) Metal11(11) } -blockPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -allowJogging 1 -crossoverViaLayerRange { Metal1(1) Metal11(11) } -allowLayerChange 1 -targetViaLayerRange { Metal1(1) Metal11(11) }
verify_drc
verifyConnectivity -type all
clearDrc
saveDesign db/v1/floorplan
fit
fit
setEndCapMode -leftEdge FILL4 -rightEdge FILL4 -topEdge {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64} -bottomEdge {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64}
addEndCap -prefix ENDCAP
place_opt_design
setTieHiLoMode -maxFanout 20 -maxDistance 50 -cell {TIEHI TIELO}
addTieHiLo -prefix TIEHILO
timeDesign -outDir db/v1/timingReports -preCTS
timeDesign -outDir db/v1/timingReports -preCTS -hold
saveDesign db/v1/place
ccopt_design -outDir db/v1/timingReports
timeDesign -outDir db/v1/timingReports -postCTS -hold
saveDesign db/v1/cts
optDesign -postCTS -outDir db/v1/timingReports
optDesign -postCTS -hold -outDir db/v1/timingReports
saveDesign db/v1/postcts
routeDesign
timeDesign -outDir db/v1/timingReports -postRoute
timeDesign -outDir db/v1/timingReports -postRoute -hold
saveDesign db/v1/route
optDesign -postRoute -setup -hold
verify_drc -limit 1000000
ecoRoute -fix_drc
timeDesign -outDir db/v1/timingReports -postRoute
timeDesign -outDir db/v1/timingReports -postRoute -hold
saveDesign db/v1/postroute
signoffOptDesign -setup
signoffOptDesign -hold
signoffOptDesign -drv
timeDesign -outDir db/v1/timingReports -signOff
timeDesign -outDir db/v1/timingReports -signOff -hold
addFiller -cell {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64} -prefix FILLER
saveDesign db/v1/signoff
verify_drc -limit 1000000
verifyConnectivity -type all
report_power
report_area
report_timing
summaryReport
saveNetlist mMIPS_layout.v -excludeCellInst FILLER_CELLS
write_sdf optRoute.sdf 
read_activity_file -reset ../sim/tcf.dump -format TCF -scope sys_inst
report_power
