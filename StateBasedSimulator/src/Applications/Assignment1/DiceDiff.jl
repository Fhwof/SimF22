

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