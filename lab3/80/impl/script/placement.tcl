########################################################
# Placement flow
# 1. Special cell placement
# 2. Global
# 3. Detail
# 4. Optimization
########################################################


########################################################
# 1. Special cell placement
########################################################
# In this lab we only place endcaps and tie-offs
# No welltaps needed, because the cells in this technology the cells are tapped.
# No decap cells needed, because we will not analyze the power of the designs.
# No spare cells needed, because we will not manufacture the chip.

# Configure what shape of filler cells to place where. Top and bottom edges usually occupy entire rows and therefore have a list of all large/small cells.
setEndCapMode -leftEdge FILL4 -rightEdge FILL4 -topEdge $FILLER_CELLS -bottomEdge $FILLER_CELLS

# Note: command is PD AWARE!
addEndCap -prefix ENDCAP

# Note: Tie-off cells need to be placed after placement!

########################################################
# 2-4. Placement and optimization
########################################################
# For 2PD case:
# commit_power_intent
# Configuration options:
# setPlaceMode
# setOptMode

# All steps are integrated in a single command:
place_opt_design
# Incremental optimization is also an option. E.g.:
# place_opt_design -incremental


# Configure max fanout and distance, and tiehi/tilo cells
setTieHiLoMode -maxFanout 20 -maxDistance 50 -cell {TIEHI TIELO} 
# Note: command is PD AWARE!
addTieHiLo -prefix TIEHILO

# Time design
timeDesign -outDir "$DB_folder/timingReports" -preCTS
timeDesign -outDir "$DB_folder/timingReports" -preCTS -hold

# Save design
saveDesign "$DB_folder/place"
