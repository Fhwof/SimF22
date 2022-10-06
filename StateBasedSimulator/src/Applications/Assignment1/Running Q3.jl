include("../../../deps/build.jl")

sim = SpecialCardSim()

#The 4th argument can be: :AtLeast, :Exact, or :Packs for parts a), b), and c)
results = repeat(sim, 100000, StoredValues, :AtLeast, 2)
mean(results)
confint(results)