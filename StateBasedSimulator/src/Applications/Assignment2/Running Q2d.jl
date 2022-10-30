include("../../../deps/build.jl")

sim = GoldCardSim()
println()
#----- 0.5 -----
g = 0.5
println("g = $g")
results = repeat(sim, 100000, StoredValues, :Packs, 3, g)
println("confidence interval: ", confint(results))
println("formula: ", ((1/g) + (1/(1-g)) - 1))
println()

#----- 0.25 -----
g = 0.25
println("g = $g")
results = repeat(sim, 100000, StoredValues, :Packs, 3, g)
println("confidence interval: ", confint(results))
println("formula: ", ((1/g) + (1/(1-g)) - 1))
println()

#----- 0.1 -----
g = 0.1
println("g = $g")
results = repeat(sim, 100000, StoredValues, :Packs, 3, g)
println("confidence interval: ", confint(results))
println("formula: ", ((1/g) + (1/(1-g)) - 1))
println()

