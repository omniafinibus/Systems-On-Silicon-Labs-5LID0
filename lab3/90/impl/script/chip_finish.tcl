########################################################
# Chip finish flow
# 1. Settings/constraints
# 2. Signoff optimization
# 3. Add fillers
# 4. Violation check
########################################################

########################################################
# 1. Settings/constraints
########################################################
# See settings.tcl


########################################################
# 2. Signoff optimization
########################################################
# Configuration options:
# setSignoffOptMode

# Optimize setup and hold timing and design rule violations (DRVs)
signoffOptDesign -setup
signoffOptDesign -hold 
signoffOptDesign -drv

# Time design
timeDesign -outDir "$DB_folder/timingReports" -signOff
timeDesign -outDir "$DB_folder/timingReports" -signOff -hold


########################################################
# 3. Add fillers
########################################################
# Add fillers in empty space
addFiller -cell $FILLER_CELLS -prefix FILLER

# No metal fill in this lab.

# Save design
saveDesign "$DB_folder/signoff"

########################################################
# 4. Violation check; No violation should occur!
########################################################
# DRC checking
verify_drc -limit 1000000

# Connectivity check
verifyConnectivity -type all
