


include("../../../../deps/build.jl")
include("../../../../deps/a4_build.jl")

interarrivaltime(sim::FSystem) = round(rand(Exponential(4.5)))
servicetime(sim::FSystem) = rand(Poisson(3.5))
choice(sim::FSystem) = rand(Bernoulli(0.50))
feedback_choice(sim::FSystem) = rand(Bernoulli(0.50))

interarrivaltime(sim::ThCSystem) = round(rand(Exponential(4.5)))
servicetime(sim::ThCSystem) = rand(Poisson(3.5))
choice(sim::ThCSystem) = rand(Bernoulli(0.50))

function runTest(sim)
    results = repeat(sim, 500)
    println()
    println("for $sim with an end time of: $(sim.endTime)")
    println() 
    println("Mean percent idle time from service center 1: $(mean(percentAllServeIdle(results, sim, 1)))")
    println("Mean percent idle time from service center 2: $(mean(percentAllServeIdle(results, sim, 2)))")
    println("Mean percent idle time from service center 3: $(mean(percentAllServeIdle(results, sim, 3)))")
    println("Mean percent idle time from all service centers: $(mean(percentAllServeIdle(results, sim)))")
    println()
    println("Mean percent busy time from service center 1: $(mean(percentAllServeBusy(results, sim, 1)))")
    println("Mean percent busy time from service center 2: $(mean(percentAllServeBusy(results, sim, 2)))")
    println("Mean percent busy time from service center 3: $(mean(percentAllServeBusy(results, sim, 3)))")
    println("Mean percent busy time from all service centers: $(mean(percentAllServeBusy(results, sim)))")
    println()
    println("Mean rate of departure from service center 1: $(mean(RateOfDeparture(results, sim, 1)))")
    println("Mean rate of departure from service center 2: $(mean(RateOfDeparture(results, sim, 2)))")
    println("Mean rate of departure from service center 3: $(mean(RateOfDeparture(results, sim, 3)))")
    println("Mean rate of departure from all service centers: $(mean(RateOfDeparture(results, sim)))")
end

#endTime = 100
Fsim = FSystem(c1 = 2, c2 = 1, c3 = 1, end_time = 100)
ThCsim = ThCSystem(c1 = 2, c2 = 1, c3 = 1, end_time = 100)
runTest(Fsim)
runTest(ThCsim)

#endTime = 200
Fsim = FSystem(c1 = 2, c2 = 1, c3 = 1, end_time = 200)
ThCsim = ThCSystem(c1 = 2, c2 = 1, c3 = 1, end_time = 200)
runTest(Fsim)
runTest(ThCsim)

#endTime = 1000
Fsim = FSystem(c1 = 2, c2 = 1, c3 = 1, end_time = 1000)
ThCsim = ThCSystem(c1 = 2, c2 = 1, c3 = 1, end_time = 1000)
runTest(Fsim)
runTest(ThCsim)
