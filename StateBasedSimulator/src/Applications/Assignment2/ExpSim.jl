using Distributions, Random
import Base.repeat

struct ExpSim <: MonteCarloSim
    rate::Float64
end

#---------- Repeat ----------



function repeat(sim::ExpSim, reps, R::Type = NormalStats) 
    value = nextvalue(sim, sim.rate)
    results = Results(R, value, reps)
    repeat(sim, results, reps)
end

function repeat(sim::ExpSim, results::Results, reps)  
    for i = 2:reps
        add!(results, nextvalue(sim, sim.rate))
    end
        
    results
end

#---------- NextValue ----------

function nextvalue(sim::ExpSim, rate)
    rand(Exponential(rate))
end