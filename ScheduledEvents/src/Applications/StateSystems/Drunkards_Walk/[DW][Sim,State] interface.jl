startstate(sim::DrunkardsWalkSim) = DrunkardsState(sim)

steppedleft(sim) = rand() < probleft(sim)

function update!(sim::DrunkardsWalkSim, state)
    state.loc += steppedleft(sim) ? -1 : 1
    state.steps += 1
end

maxitr(sim::DrunkardsWalkSim) = 10000
isfound(sim::DrunkardsWalkSim, state) = abs(location(state)) >= walls(state)
