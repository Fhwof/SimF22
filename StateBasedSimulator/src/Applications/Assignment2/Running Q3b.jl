include("../../../deps/build.jl")

rate = 1.0
println("\ncreating ExpSim with rate = $rate")
sim = ExpSim(rate)
results = repeat(sim, 10000)
println("rate from Monte Carlo: ", mean(results))

rate = 0.5
println("\ncreating ExpSim with rate = $rate")
sim = ExpSim(rate)
results = repeat(sim, 10000)
println("rate from Monte Carlo: ", mean(results))

rate = 543.0
println("\ncreating ExpSim with rate = $rate")
sim = ExpSim(rate)
results = repeat(sim, 10000)
println("rate from Monte Carlo: ", mean(results))