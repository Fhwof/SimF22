#This simulator is very similar to DiceDiff, but 
#the sim struct needed attributes to keep track
#of the number of sides on each die, along with
#some logic to incorporate it.

struct SidesDiff <: MonteCarloSim
    dieSide::Int
    die2Side::Int
end

function nextvalue(sim::SidesDiff)
    First = rand(1:sim.dieSide)
    Second = 0
    if sim.die2Side == 0
        Second = rand(1:sim.dieSide)
    else
        Second = rand(1:sim.die2Side)
    end
    
    if First < Second
        Second - First
    else
        First - Second
    end
    
end

calcDiff(results::Results) = mean(results)