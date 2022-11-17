app_path         = source_path * "Applications/"
mc_path          = app_path * "MonteCarloSystems/"
state_path       = app_path * "StateSystems/"
fixedevents_path = app_path * "FixedEventsSystems/"
queueingsys_path = app_path * "QueueingSystems/"

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

SingleServer_path = queueingsys_path * "SingleServerSystem/"
include(SingleServer_path * "[SingleServer] system.jl")

MultiServer_path = queueingsys_path * "MultiServerSystem/"
include(MultiServer_path * "[MultiServer] system.jl")

TwoCenters_path = queueingsys_path * "TwoCentersSystem/"
include(TwoCenters_path * "[TwoCentersSystem] system.jl")


simAppsLoaded = true
