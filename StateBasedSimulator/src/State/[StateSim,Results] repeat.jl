function firstvalue(sim::StateSim, verbosity)
    value = runsim(sim, verbosity)
    while value === missing
        value = runsim(sim, verbosity)
    end
    value
end

function repeat(sim::StateSim, reps::Int, RTConstant::Type = NormalStats; verbose = false)
    firstValue = firstvalue(sim, verbosity(verbose))
    results = Results(RTConstant, firstValue, reps)
    repeat(sim, results, reps, verbosity(verbose))
end

function repeat(sim::StateSim, results::Results, reps::Int, v::Verbosity)  
    for i = 2:reps
        add!(results, runsim(sim, v))
    end
    results
end

