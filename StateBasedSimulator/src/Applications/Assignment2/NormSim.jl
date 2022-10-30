using Distributions, Random
import Base.repeat

struct NormSim <: MonteCarloSim
    𝜇::Float64
    𝜎::Float64
end

#---------- Repeat ----------



function repeat(sim::NormSim, reps, R::Type = NormalStats) 
    value = nextvalue(sim, sim.𝜇, sim.𝜎)
    results = Results(R, value, reps)
    repeat(sim, results, reps)
end

function repeat(sim::NormSim, results::Results, reps)  
    for i = 2:reps
        add!(results, nextvalue(sim, sim.𝜇, sim.𝜎))
    end
        
    results
end

#---------- NextValue ----------

function nextvalue(sim::NormSim, 𝜇, 𝜎)
    rand(Normal(𝜇, 𝜎))
end