########################################################
# CTS flow
# 1. Settings/constraints
# 2. CTS
# 3. Optimization
########################################################

########################################################
# 1. Settings/constraints
########################################################
# See settings.tcl

########################################################
# 2. CTS
########################################################
ccopt_design -outDir "$DB_folder/timingReports"
# Time design
timeDesign -outDir "$DB_folder/timingReports" -postCTS -hold

# Save design
saveDesign "$DB_folder/cts"


########################################################
# 3. Post-CTS Optimization
########################################################
# To fix fanout using optDesign:
# setOptMode -fixFanoutLoad true

optDesign -postCTS -outDir "$DB_folder/timingReports"
optDesign -postCTS -hold -outDir "$DB_folder/timingReports"

# Save design
saveDesign "$DB_folder/postcts"

