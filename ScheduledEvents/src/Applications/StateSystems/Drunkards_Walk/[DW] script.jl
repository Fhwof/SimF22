include("../../../../deps/build.jl")

dw = DrunkardsWalkSim(walls = 10)           # :steps is the default measure

runsim(dw, verbose = true)
runsim(dw)

results = repeat(dw, 1000)
mean(results)
confint(results)


dw = DrunkardsWalkSim(walls = 10, measure = :leftWall)

results = repeat(dw, 1000, BinomialStats)
mean(results)
confint(results)

dw = DrunkardsWalkSim(walls = 10, measure = :steps)

results = repeat(dw, 1000)
mean(results)
confint(results)


# note: the internal code that allows the 'measure' keyword to function in the constructor is advanced Julia 
#       you do not need to replicate this for the assignment - just define mesaure(::Simulation, ::State) directly