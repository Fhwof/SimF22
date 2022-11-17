function verbose_state(sim::Simulation, state)
    print(state)
    verbose_splitstate(sim::Simulation) && print("\n")
end

function verbose(sim::Simulation, state, i) 
    verbose_withlinenum(sim) && verbose_linenum(sim, i)
    verbose_state(sim, state)
end

show(io::IO, mime::MIME"text/plain", s::State) = show(s)
print(s::State) = show(s)
