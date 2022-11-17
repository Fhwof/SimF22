mutable struct DrunkardsState <: State 
    loc::Int
    steps::Int
    wallsLoc::Int
end

DrunkardsState(sim::DrunkardsWalkSim) = DrunkardsState(start(sim), 0, walls(sim))

const DWState = DrunkardsState

import Distributions.location
location(state::DWState) = state.loc

steps(state::DWState) = state.steps
walls(state::DWState) = state.wallsLoc

closestwall(state::DWState) = (location(state) < 0 ? :left  : 
                               location(state) > 0 ? :right : :neither )
