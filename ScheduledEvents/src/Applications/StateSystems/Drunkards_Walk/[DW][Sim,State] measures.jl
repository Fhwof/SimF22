#--------------------------------------------
#  Measures 
#     Allows the Drunkard's Walk Simulator to select between multiple measure during the Sim construction
#         - This is advanced Julia (metaprogramming), you do not need to implement it for A2 
#         - You can just define measure(sim::DWSim, state) = stepsmeasure(sim, state), or the measure you want to use,
#            directly in the script (it is just more convenient this way)

stepsmeasure(sim::DrunkardsWalkSim, state)   =  steps(state)
atleftmeasure(sim::DrunkardsWalkSim, state)  =  closestwall(state) === :left ? 1 : 0
atrightmeasure(sim::DrunkardsWalkSim, state) =  closestwall(state) === :right ? 1 : 0

function setmeasure(m::Symbol)
    if m === :steps
        eval(:(measure(sim::DWSim, state) = stepsmeasure(sim, state)))
    elseif m === :leftWall
        eval(:(measure(sim::DWSim, state) = atleftmeasure(sim, state)))
    elseif m === :rightWall
        eval(:(measure(sim::DWSim, state) = atrightmeasure(sim, state)))
    else
        error("The measure keyword must be one of {:steps, :leftWall, :rightWall")
    end
end
