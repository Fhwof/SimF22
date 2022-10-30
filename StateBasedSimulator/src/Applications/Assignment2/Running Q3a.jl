include("../../../deps/build.jl")

sim = NormSim(0.0, 1.0)

results = repeat(sim, 10000)
mean(results)