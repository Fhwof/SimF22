import Base.repeat

function repeat(sim::Simulation, reps, R::Type = NormalStats) 
    value = nextvalue(sim)
    results = Results(R, value, reps)
    repeat(sim, results, reps)
end

function repeat(sim::Simulation, results::Results, reps)  
    for i = 2:reps
        add!(results, nextvalue(sim))
    end
        
    results
end

