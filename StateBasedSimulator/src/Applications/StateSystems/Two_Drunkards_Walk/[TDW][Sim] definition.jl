struct TwoDrunkardsWalkSim <: StateSim
    wallLoc::Int
    startPos1::Int
    startPos2::Int
    probLeft::Float64
end

function TwoDrunkardsWalkSim(; walls=10, start1=0, start2=0, prob_left=0.5, prob_right=0.5, measure=:steps) 
    abs(start1) >= walls && error("Drunkard must start between walls; walls = [-$walls, $walls] and start = $start")
    abs(start2) >= walls && error("Drunkard must start between walls; walls = [-$walls, $walls] and start = $start")
    start1 == start2 && error("The drunkards cannot start in the same palce; start1, start2 = $start1, $start2")
    ( prob_left == 0.5 != prob_right )                 &&  (prob_left = 1 - prob_right)
    ( prob_left != 1 - prob_right && prob_right != 0.5 ) &&  error("prob_left != 1 - prob_right; prob_left = $prob_left, prob_right = $prob_right")
    setmeasure(measure)
    TwoDrunkardsWalkSim(walls, start1, start2, prob_left)
end

const TDWSim = TwoDrunkardsWalkSim

probleft(sim::TDWSim) = sim.probLeft
probright(sim::TDWSim) = 1 - probleft(sim)
walls(sim::TDWSim) = sim.wallLoc
start1(sim::TDWSim) = sim.startPos1
start2(sim::TDWSim) = sim.startPos2

