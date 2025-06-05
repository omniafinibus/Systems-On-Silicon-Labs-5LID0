########################################################
# Physical implementation flow
# 1. Design import
# 2. Settings for all sub-flows
# 3. Floorplan
# 4. Placement
# 5. CTS
# 6. Route
# 7. Chip finish
########################################################

########################################################
# 1. Design import
########################################################
# 1PD case:
source ../synth/db/1pd/mMIPS_system.invs_setup.tcl
# 2PD case:
# source ../synth/db/2pd/mMIPS_system.invs_setup.tcl

########################################################
# 2. Settings
########################################################
source script/settings.tcl

########################################################
# 3. Floorplan
########################################################
source script/floorplan.tcl
puts "floorplan"
suspend

########################################################
# 4. Placement
########################################################
source script/placement.tcl
puts "placement"
suspend

########################################################
# 5. CTS
########################################################
source script/cts.tcl
puts "cts"
suspend

########################################################
# 6. Route
########################################################
source script/route.tcl
puts "route"
suspend

########################################################
# 7. Chip finish
########################################################
source script/chip_finish.tcl
