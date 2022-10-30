mutable struct TwoDrunkardsState <: State 
    loc1::Int
    steps1::Int
    loc2::Int
    steps2::Int
    wallsLoc::Int
end

TwoDrunkardsState(sim::TwoDrunkardsWalkSim) = TwoDrunkardsState(start1(sim), 0, start2(sim), 0, walls(sim))

const TDWState = TwoDrunkardsState

import Distributions.location
location1(state::TDWState) = state.loc1
location2(state::TDWState) = state.loc2

steps1(state::TDWState) = state.steps1
steps2(state::TDWState) = state.steps2
walls(state::TDWState) = state.wallsLoc

closestwall1(state::TDWState) = (location1(state) < 0 ? :left  : 
                               location1(state) > 0 ? :right : :neither )

closestwall(state::TDWState) = (location1(state) < 0 ? :left  : 
                               location1(state) > 0 ? :right : :neither )
