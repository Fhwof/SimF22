include("../../../deps/build.jl")

# ---------- 1.c) ----------
numRepeats = 100

#set up and run the simple system
servicetime(sim::SingleServerSystem)      = rand(3:12)
interarrivaltime(sim::SingleServerSystem) = rand(1:8)
simpleSim = SingleServerSystem(end_time = 100)
simpleResults = repeat(simpleSim, numRepeats)
simpleWQ = simpleResults[:WQ]
simpleMean = mean(simpleWQ)
simpleSTD = std(simpleWQ)
simpleConfint = confint(simpleWQ, level = 0.99)

#setup and run the realistic system
servicetime(sim::SingleServerSystem)      = round(Int, rand(Erlang(8, 0.9)))
interarrivaltime(sim::SingleServerSystem) = round(Int, rand(Exponential(4.5)))
realSim = SingleServerSystem(end_time = 100)
realResults = repeat(realSim, numRepeats)
realWQ = realResults[:WQ]
realMean = mean(realWQ)
realSTD = std(realWQ)
realConfint = confint(realWQ, level = 0.99)

#comparisons
WQFtest = ftest(simpleWQ, realWQ)
WQTtest = ttest(simpleWQ, realWQ, equalVar = false)

println("the mean of the total wait time in the simple sim was: $simpleMean")
println("the mean of the total wait time in the realistic sim was: $realMean")
println()
println("the standard deviation of the total wait time in the simple sim was: $simpleSTD")
println("the standard deviation of the total wait time in the realistic sim was: $realSTD")
println()
println("the 99% confidence interval of the total wait time in the simple sim was: $simpleConfint")
println("the 99% confidence interval of the total wait time in the realistic sim was: $realConfint")
println()
println("the F test of the simple and real systems yielded: $WQFtest")
println("the Welch T test of the simple and real systems yielded: $WQTtest")

# ---------- 1.d) ----------
numRepeats = 5000

#set up and run the simple system
servicetime(sim::SingleServerSystem)      = rand(3:12)
interarrivaltime(sim::SingleServerSystem) = rand(1:8)
simpleSim = SingleServerSystem(end_time = 100)
simpleResults = repeat(simpleSim, numRepeats)
simpleWQ = simpleResults[:WQ]
simpleMean = mean(simpleWQ)
simpleSTD = std(simpleWQ)

#setup and run the realistic system
servicetime(sim::SingleServerSystem)      = round(Int, rand(Erlang(8, 0.9)))
interarrivaltime(sim::SingleServerSystem) = round(Int, rand(Exponential(4.5)))
realSim = SingleServerSystem(end_time = 100)
realResults = repeat(realSim, numRepeats)
realWQ = realResults[:WQ]
realMean = mean(realWQ)
realSTD = std(realWQ)

#comparisons
WQFtest = ftest(simpleWQ, realWQ)
WQTtest = ttest(simpleWQ, realWQ, equalVar = false)

println("the F test of the simple and real systems after $numRepeats simulations yielded: $WQFtest")
println("the Welch T test of the simple and real systems after $numRepeats simulations yielded: $WQTtest")

# #this code was used to verify 1. a) calculations
# n = 10000
# uniTotal = 0
# expTotal = 0
# for i in 1:n
#     uniTotal += rand(1:8)
#     expTotal += rand(Exponential(4.5))
# end
# println(uniTotal/n)
# println(expTotal/n)

# #this code was used to verify 1. b) calculations
# # rand(Erlang(375, 1/50)) is the function I found accidentally that will have the same mean as rand(3:12) 
# n = 10000
# uniTotal = 0
# erlTotal = 0
# for i in 1:n
#     uniTotal += rand(3:12)
#     erlTotal += round(Int, rand(Erlang(8, 0.9)))
# end
# println(uniTotal/n)
# println(erlTotal/n)