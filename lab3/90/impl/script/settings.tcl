########################################################
# Settings file
# It contains all settings/constraints for all flows
########################################################

########################################################
# Generic
########################################################
set DB_folder "db/v1"

setDesignMode -process 45

# CPU usage. Please do not increase this number.
setMultiCpuUsage -remoteHost 1 -cpuPerRemoteHost 2 -localCpu 2

# Layer mapfile for RC extraction 
setExtractRCMode -lefTechFileMap script/layer.mapfile

# Timing analysis using on-chip variation
setAnalysisMode -analysisType onChipVariation
# Removes pessimism from clock paths that have a portion of the clock network in common between the clock source and clock destination paths
setAnalysisMode -cppr both
# Enables SIAware delay calculation that also includes cross-talk induced delays
setDelayCalMode -SIAware true

########################################################
# Placement
########################################################
# List of filler cells, also used as endcaps
set FILLER_CELLS {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64}

########################################################
# CTS
########################################################
# Maximum allowable skew is derived automatically
set_ccopt_property target_skew auto
# Use inverters instead of buffers for the clock net
set_ccopt_property use_inverters true
# Max wire length
set_ccopt_property max_source_to_sink_net_length 300
# Aim for higher hold slack. Hold is more important than setup timing!
setOptMode -holdTargetSlack 0.1

# Specifiy what buffer/inverter cells the CTS can use. Usually you don't want too strong and too weak cells.
set_ccopt_property buffer_cells {CLKBUFX2 CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20}
set_ccopt_property inverter_cells {CLKINVX1 CLKINVX2 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8 CLKINVX12 CLKINVX16 CLKINVX20}
# Delay cells that are needed for fixing hold timing
setOptMode -holdFixingCells {DLY1X1 DLY1X4 DLY2X1 DLY2X4 DLY3X1 DLY3X4 DLY4X1 DLY4X4}


# Define custom route rules. 2W2S in this case.
add_ndr -width_multiplier {M1:M11 2} -spacing_multiplier {M1:M11 2} -name 2W2S -generate_via

# Define clock route types
# Route type 'top' will have 2W2S on Metal8/9 and will be shielded by VSS
create_route_type -name top -non_default_rule 2W2S -bottom_preferred_layer Metal8 -top_preferred_layer Metal9 -shield_net VSS -shield_side both_side -preferred_routing_layer_effort high
# Route type 'trunk' will have 2W2S on Metal6/7 and will be shielded by VSS
create_route_type -name trunk -non_default_rule 2W2S -bottom_preferred_layer Metal6 -top_preferred_layer Metal7 -shield_net VSS -shield_side both_side -preferred_routing_layer_effort high
# Route type 'leaf' will be on Metal4/5
create_route_type -name leaf -bottom_preferred_layer Metal4 -top_preferred_layer Metal5 -preferred_routing_layer_effort high

# Assign route types to top, trunk and leaf of clock net
set_ccopt_property route_type -net_type top top
set_ccopt_property route_type -net_type trunk trunk
set_ccopt_property route_type -net_type leaf leaf

########################################################
# Route
########################################################
# Specify which metal layers can be used for routing
setNanoRouteMode -routeBottomRoutingLayer 2 -routeTopRoutingLayer 9
# Max wire length
setOptMode -maxLength 900

# To fix antenna violations
setNanoRouteMode -routeAntennaCellName {ANTENNA}
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeInsertDiodeForClockNets true

# Allow tool to use self-generated via's
setNanoRouteMode -routeUseAutoVia true

# Multi-cut via effort level
setNanoRouteMode -droutePostRouteSwapVia multiCut
setNanoRouteMode -drouteUseMultiCutViaEffort high

########################################################
# Chip Finish
########################################################
# Filler cells already listed at placement.
