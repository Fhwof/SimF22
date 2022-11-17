function verbose_event(sim::Simulation, event)
    print(event)
    print(" ")
end

function verbose(sim::Simulation, event, state, i)
    verbose_withlinenum(sim) && verbose_linenum(sim, i)
    verbose_event(sim, event)
    verbose_state(sim, state)
end

verbose_splitstate(sim::DiscreteEventSim) = true
