include("../../../deps/build.jl")

sim = SawFirstCoinSim()
results = runsim(sim, 10000)

results = repeat(sim, 10000, StoredValues)
mean(results)
confint(results)