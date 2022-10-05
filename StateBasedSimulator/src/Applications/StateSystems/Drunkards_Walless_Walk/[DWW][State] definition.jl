mutable struct WallessState <: State 
    loc::Int
    maxLoc::Int
end

WallessState(sim::DWWSim) = WallessState(0, 0)

import Distributions.location
location(state::WallessState) = state.loc

furthestdistance(state::WallessState) = state.maxLoc
