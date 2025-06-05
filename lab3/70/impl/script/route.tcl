########################################################
# Route flow
# 1. Settings/constraints
# 2. Global
# 3. Detail
# 4. Optimization
########################################################

########################################################
# 1. Settings/constraints
########################################################
# See settings.tcl

########################################################
# 2-3. Global and detail routing
########################################################
# Global and detail routing is done using a single command
routeDesign

# Fix min_cut issue
# fixVia -minCut
# routeDesign -viaOpt

# Time design
timeDesign -outDir "$DB_folder/timingReports" -postRoute
timeDesign -outDir "$DB_folder/timingReports" -postRoute -hold

# Save design
saveDesign "$DB_folder/route"

########################################################
# 4. Optimization
########################################################
optDesign -postRoute -setup -hold

# Try to fix routing DRCs
verify_drc -limit 1000000
ecoRoute -fix_drc

# Time design
timeDesign -outDir "$DB_folder/timingReports" -postRoute
timeDesign -outDir "$DB_folder/timingReports" -postRoute -hold

# Save design
saveDesign "$DB_folder/postroute"
