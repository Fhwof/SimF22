include("../../../deps/build.jl")

sim = SawFirstCoinSim()
results = runsim(sim, 10000)

results = repeat(sim, 10000)
mean(results)
confint(results)