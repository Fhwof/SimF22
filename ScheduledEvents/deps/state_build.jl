import Base.repeat
import DataStructures.update!

state_path          = source_path * "State/"

include(state_path * "[State] definition.jl")
include(state_path * "[StateSim] verbosity_framework.jl")
include(state_path * "[StateSim,Results] repeat.jl")
include(state_path * "[Sim,State] interface_for_runsim.jl")
include(state_path * "[Sim,State] runsim.jl")
include(state_path * "[Sim,State] verbose.jl") 

stateLoaded = true
