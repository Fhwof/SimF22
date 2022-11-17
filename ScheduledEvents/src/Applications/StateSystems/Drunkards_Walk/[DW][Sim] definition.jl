struct DrunkardsWalkSim <: StateSim
    wallLoc::Int
    startPos::Int
    probLeft::Float64
end

function DrunkardsWalkSim(; walls=10, start=0, prob_left=0.5, prob_right=0.5, measure=:steps) 
    abs(start) >= walls && error("Drunkard must start between walls; walls = [-$walls, $walls] and start = $start")
    ( prob_left == 0.5 != prob_right )                 &&  (prob_left = 1 - prob_right)
    ( prob_left != 1 - prob_right && prob_right != 0.5 ) &&  error("prob_left != 1 - prob_right; prob_left = $prob_left, prob_right = $prob_right")
    setmeasure(measure)
    DrunkardsWalkSim(walls, start, prob_left)
end

const DWSim = DrunkardsWalkSim

probleft(sim::DWSim) = sim.probLeft
probright(sim::DWSim) = 1 - probleft(sim)
walls(sim::DWSim) = sim.wallLoc
start(sim::DWSim) = sim.startPos

