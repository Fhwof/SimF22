function firstvalue(sim::StateSim, verbosity)
    value = runsim(sim, verbosity)
    while value === missing
        value = runsim(sim, verbosity)
    end
    value
end

function repeat(sim::StateSim, reps::Int, ResultType::Type = NormalStats; verbose = false)
    fv = firstvalue(sim, verbosity(verbose))
    results = (typeof(fv) <: State)  ?  Results(StateResults, fv, reps)  :  Results(ResultType, fv, reps)
    repeat(sim, reps, results, verbosity(verbose))
end

function repeat(sim::StateSim, reps::Int, results::Results, v::Verbosity)  
    for i = 2:reps
        add!(results, runsim(sim, v))
    end
    results
end
