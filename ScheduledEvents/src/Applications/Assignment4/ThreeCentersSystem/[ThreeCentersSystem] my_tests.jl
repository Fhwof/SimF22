


include("../../../../deps/build.jl")
include("../../../../deps/a4_build.jl")

interarrivaltime(sim::ThCSystem) = round(rand(Exponential(4.5)))
servicetime(sim::ThCSystem) = rand(Poisson(3.5))
choice(sim::ThCSystem) = rand(Bernoulli(0.50))

sim = ThCSystem(c1 = 2, c2 = 1, c3 = 1, end_time = 100)

#one runsim to show the typical output
runsim(sim,  verbose = true)
println()

results = repeat(sim, 500)
println("With an equal chance to go to center 2 and 3, they should have very similar total wait times:")
println("Mean total wait time from service center 1: $(mean(results[:WQ, 1]))")
println("Mean total wait time from service center 2: $(mean(results[:WQ, 2]))")
println("Mean total wait time from service center 3: $(mean(results[:WQ, 3]))")
println()

choice(sim::ThCSystem) = rand(Bernoulli(0.25))
results = repeat(sim, 500)
println("With different chances to go to center 2 and 3, they should have very different total wait times:")
println("Mean total wait time from service center 1: $(mean(results[:WQ, 1]))")
println("Mean total wait time from service center 2: $(mean(results[:WQ, 2]))")
println("Mean total wait time from service center 3: $(mean(results[:WQ, 3]))")