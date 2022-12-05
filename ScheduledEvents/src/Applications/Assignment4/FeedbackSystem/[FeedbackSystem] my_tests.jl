


include("../../../../deps/build.jl")
include("../../../../deps/a4_build.jl")

interarrivaltime(sim::FSystem) = round(rand(Exponential(4.5)))
servicetime(sim::FSystem) = rand(Poisson(3.5))
choice(sim::FSystem) = rand(Bernoulli(0.50))
feedback_choice(sim::FSystem) = rand(Bernoulli(0.50))

sim = FSystem(c1 = 2, c2 = 1, c3 = 1, end_time = 100)

#one runsim to show the typical output
runsim(sim,  verbose = true)
println()

results = repeat(sim, 500)
println("Mean total wait time from service center 1: $(mean(results[:WQ, 1]))")
println("Mean total wait time from service center 2: $(mean(results[:WQ, 2]))")
println("Mean total wait time from service center 3: $(mean(results[:WQ, 3]))")