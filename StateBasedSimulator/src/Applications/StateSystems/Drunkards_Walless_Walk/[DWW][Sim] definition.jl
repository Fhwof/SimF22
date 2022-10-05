struct DrunkardsWallessWalkSim <: StateSim
    probLeft::Float64
end

function DrunkardsWallessWalkSim(; prob_left=0.5, prob_right=0.5) 
    ( prob_left == 0.5 != prob_right )                 &&  (prob_left = 1 - prob_right)
    ( prob_left != 1 - prob_right && prob_right != 0.5 ) &&  error("prob_left != 1 - prob_right; prob_left = $prob_left, prob_right = $prob_right")
    DrunkardsWallessWalkSim(prob_left)
end

const DWWSim = DrunkardsWallessWalkSim

probleft(sim::DWWSim) = sim.probLeft
probright(sim::DWWSim) = 1 - probleft(sim)
