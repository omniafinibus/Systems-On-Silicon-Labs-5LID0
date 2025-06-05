########################################################
# Floorplan flow
# 1. Design import
# 2. Create core area
# 3. I/O pad placement
# 4. Macro placement
# 5. Blockages
# 6. Power planning
# 7. Violation check
########################################################

########################################################
# 1. Design import
########################################################
# see impl.tcl

########################################################
# 2. Create core area
########################################################
set core_to_io_margin 20.0
# floorPlan -site CoreSite -r 2.6 0.6 $core_to_io_margin $core_to_io_margin $core_to_io_margin $core_to_io_margin
floorPlan -site CoreSite -r 1.2 0.7 $core_to_io_margin $core_to_io_margin $core_to_io_margin $core_to_io_margin


########################################################
# 3. I/O pad placement
########################################################
# There are no I/O pads in the lab. Hence, we can only place the relevant pins at the edge of the core.
# setPinConstraint -corner_to_pin_distance 20 
setPinConstraint -corner_to_pin_distance 10 
setPinConstraint -pin * -spacing 125 -layer {Metal4 Metal5}

assignIoPins -pin *

# Power/Ground pins (or actually pads) are not added in this lab.


########################################################
# 4. Macro placement
########################################################
# Relative place of SRAMs w.r.t. core boundary
# Changing orientation to flip the imem
# Edge numbers start from the lower left. For square macros this implies horizontal edge numbers are always uneven numbers, and vertical edge numbers always even.
create_relative_floorplan -place imem/u_mem -ref_type core_boundary -orient R90 -horizontal_edge_separate {1  0  1} -vertical_edge_separate {0  0  0}
create_relative_floorplan -place dmem/u_mem -ref_type core_boundary -orient MX90 -horizontal_edge_separate {1  0  1} -vertical_edge_separate {2  0  2}

# Below commands provide some help for Exercise 3. Note: They are not functional!!
# 2PD-only: Place PD at correct coordinates
# set location [dbInstBox "imem/u_mem"]
# set im_x_ll [dbDBUToMicrons [lindex $location 0]]
# set im_y_ll [expr [dbDBUToMicrons [lindex $location 1]] - 3.6]
# set im_x_ur [expr [dbDBUToMicrons [lindex $location 2]] + 3.6]
# set im_y_ur [dbDBUToMicrons [lindex $location 3]]

# set location [dbInstBox "dmem/u_mem"]
# set dm_x_ll [expr [dbDBUToMicrons [lindex $location 0]] - 3.6]
# set dm_y_ll [expr [dbDBUToMicrons [lindex $location 1]] - 3.6]
# set dm_x_ur [dbDBUToMicrons [lindex $location 2]]
# set dm_y_ur [dbDBUToMicrons [lindex $location 3]]

# Modify the area of PD2
# set power_spacing 20
# modifyPowerDomainAttr PD2 -box $im_x_ll $im_y_ll $dm_x_ur $dm_y_ur -gapEdges "$power_spacing $power_spacing $power_spacing $power_spacing" -rsExts "$power_spacing $power_spacing $power_spacing $power_spacing"
# Cut a box from a PD
# cutBoxListFromPowerDomain -powerdomain PD2 -boxList [list [list $im_x_ur [expr $im_y_ll - 0.355] $dm_x_ll $dm_y_ur]]

########################################################
# 5. Blockages
########################################################
# Add halo to both SRAM macros at once
addHaloToBlock 3.6 3.6 3.6 3.6 -snapToSite -allMacro


########################################################
# 6. Power planning
########################################################
set nets {VDD2 VSS}
# Add ring around core area
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer Metal11 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets $nets -type core_rings -follow core -layer {top Metal11 bottom Metal11 left Metal10 right Metal10} -width {top 4 bottom 4 left 4 right 4} -spacing {top 2 bottom 2 left 2 right 2} -offset {top 2 bottom 2 left 2 right 2} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None

# Add vertical stripes
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer Metal11 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets $nets -layer Metal10 -direction vertical -width 4 -spacing 2 -number_of_sets 3 -start_from left -start_offset 50 -stop_offset 50 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit Metal11 -padcore_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid None

# Add horizontal stripes
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer Metal11 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets $nets -layer Metal11 -direction horizontal -width 4 -spacing 2 -number_of_sets 9 -start_from bottom -start_offset 50 -stop_offset 50 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit Metal11 -padcore_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid None

# SRoute
setSrouteMode -viaConnectToShape { ring stripe } -targetSearchDistance 20
sroute -nets $nets -connect { corePin } -layerChangeRange { Metal1(1) Metal11(11) } -blockPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -allowJogging 1 -crossoverViaLayerRange { Metal1(1) Metal11(11) } -allowLayerChange 1 -targetViaLayerRange { Metal1(1) Metal11(11) }

# Trunks are not needed, because there are no Power/Ground pads in this lab.


########################################################
# 6. Violation check
########################################################
# DRC checking
verify_drc

# Connectivity check
# Note: you will see violations. Some are due to pins of the memory not connected. Others are due to sroute dangling wires.
# Memory pins will be connected during routing
# Dangling wires have to be investigated. Once all cells (including filler cells) have been placed, is there still an issue, or is there enough connection to power/ground?
verifyConnectivity -type all

# Remove violations from the list
clearDrc

saveDesign "$DB_folder/floorplan"

