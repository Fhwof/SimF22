app_path         = source_path * "Applications/"
mc_path          = app_path * "MonteCarloSystems/"
state_path       = app_path * "StateSystems/"
fixedevents_path = app_path * "FixedEventsSystems/"
A1_path          = app_path * "Assignment1/"
A2_path          = app_path * "Assignment2/"

# Assignment 1
include(A1_path * "DiceDiff.jl")
include(A1_path * "SidesDiff.jl")
include(A1_path * "SawFirstCoin.jl")
include(A1_path * "SawCoin.jl")
include(A1_path * "SpecialCard.jl")

#Assignment 2
include(A2_path * "GoldCard.jl")
include(A2_path * "NormSim.jl")

# Computing PI
PI_path = mc_path * "Computing_PI/"
include(PI_path * "[PI][Sim] setup.jl")

# Drunkards Walless Walk
DWW_path = state_path * "Drunkards_Walless_Walk/"
include(DWW_path * "[DWW][Sim] definition.jl")
include(DWW_path * "[DWW][State] definition.jl")
include(DWW_path * "[DWW][Sim,State] interface.jl")
include(DWW_path * "[DWW][Sim][State] verbose.jl")

# Drunkards Walk
DW_path = state_path * "Drunkards_Walk/"
include(DW_path * "[DW][Sim] definition.jl")
include(DW_path * "[DW][State] definition.jl")
include(DW_path * "[DW][Sim,State] interface.jl")
include(DW_path * "[DW][Sim,State] measures.jl")
include(DW_path * "[DW][Sim][State] verbose.jl")

# Monte Hall Problem
MH_path = fixedevents_path * "Monte_Hall_Problem/"
include(MH_path * "[MH][Sim] definition.jl")
include(MH_path * "[MH][State] definition.jl")
include(MH_path * "[MH][State] choosing_doors.jl")
include(MH_path * "[MH][Event] definition.jl")
include(MH_path * "[MH][Sim,State] measure.jl")
include(MH_path * "[MH][Sim,State,Event] update state!.jl")
include(MH_path * "[MH][Sim][State] verbose.jl")

simAppsLoaded = true
