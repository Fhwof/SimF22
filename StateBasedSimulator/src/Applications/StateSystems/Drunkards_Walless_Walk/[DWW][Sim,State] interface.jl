startstate(sim::DWWSim) = WallessState(sim)

steppedleft(sim) = rand() < probleft(sim)

function update!(sim::DWWSim, state)
    state.loc += steppedleft(sim) ? -1 : 1
    state.maxLoc = max( abs( location(state)), furthestdistance(state))
end

maxitr(sim::DWWSim) = 50
measure(sim::DWWSim, state) = furthestdistance(state)
