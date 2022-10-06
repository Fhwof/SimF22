include("../../../deps/build.jl")

sim = SpecialCardSim()

results = repeat(sim, 100000, StoredValues, :AtLeast, 6)
mean(results)
confint(results)