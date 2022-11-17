#--------------------------------------------
#  Simulation's runsim() interface when called directly, not through repeat()

runsim(sim::Simulation; verbose = false) =  runsim(sim, verbosity(verbose))

#--------------------------------------------
#  runsim() as called using repeat()

runsim(sim::StateSim, v::Verbosity) = runsim( sim, maxitr(sim), startstate(sim), v)

function runsim(sim::StateSim, maxItr, state, v)
    verbosefn(v, sim, state, 0)
    for i = 1:maxItr
        isfound(sim, state) && break
        update!(sim, state)
        verbosefn(v, sim, state, i)
    end
    measure(sim, state)
end
