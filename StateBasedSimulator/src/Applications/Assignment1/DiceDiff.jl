#This is a simple extension of a MonteCarloSim that
#reuses a lot of what is already written.
#The only differences are below and they should speak 
#for themselves.

struct DiceDiff <: MonteCarloSim end

function nextvalue(sim::DiceDiff)
    FirstD6 = rand(1:6)
    SecondD6 = rand(1:6)
    if FirstD6 < SecondD6
        SecondD6 - FirstD6
    else
        FirstD6 - SecondD6
    end
    
end

calcDiff(results::Results) = mean(results)