startstate(sim::TwoDrunkardsWalkSim) = DrunkardsState(sim)

steppedleft(sim) = rand() < probleft(sim)

function update!(sim::TwoDrunkardsWalkSim, state)
    # isfound() determines the end conditions, this just keeps the drunkards walking unless they hit a wall already
    # I don't need to worry about them walking after collision because isfound() will stop the sim when a collision happens
    if (abs(location1(state)) < walls(state))
        state.loc1 += steppedleft(sim) ? -1 : 1
        state.steps1 += 1
    end
    if (abs(location2(state)) < walls(state))
        state.loc2 += steppedleft(sim) ? -1 : 1
        state.steps2 += 1
    end
end


maxitr(sim::TwoDrunkardsWalkSim) = 10000
isfound(sim::TwoDrunkardsWalkSim, state) = abs(location(state)) >= walls(state)
