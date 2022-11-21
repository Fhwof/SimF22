include("../../../deps/build.jl")
include("[TwoCentersSystem] derived_stats.jl")

interarrivaltime(sim::TCSystem) = round(rand(Exponential(4.5)))
distributions(sim::TCSystem) = [Erlang(8, 0.9), Erlang(27, 2/9)]
servicetime(sim::TCSystem, i)   = round(rand(distributions(sim)[i]))

sim = TCSystem(c1 = 2, c2 = 1, end_time = 100)

# ----------------------  [run the simulator]  -------------------------- #
results = repeat(sim, 100);

# ------------------------  [perform stats]  ---------------------------- #
WQ_1_mean = mean(wq(results, 1))
WQ_2_mean = mean(wq(results, 2))
WQ_mean = mean(wq(results))
WQ_1_confint = confint(wq(results, 1))
WQ_2_confint = confint(wq(results, 2))
WQ_confint = confint(wq(results))

WS_1_mean = mean(ws(results, 1))
WS_2_mean = mean(ws(results, 2))
WS_mean = mean(ws(results))
WS_1_confint = confint(ws(results, 1))
WS_2_confint = confint(ws(results, 2))
WS_confint = confint(ws(results))

p_wait_1_mean = mean(p_wait(results, 1))
p_wait_2_mean = mean(p_wait(results, 2))
p_wait_mean = mean(p_wait(results))
p_wait_1_confint = confint(p_wait(results, 1))
p_wait_2_confint = confint(p_wait(results, 2))
p_wait_confint = confint(p_wait(results))

p_idle_1_mean = mean(p_idle(results, 1))
p_idle_2_mean = mean(p_idle(results, 2))
p_idle_mean = mean(p_idle(results))
p_idle_1_confint = confint(p_idle(results, 1))
p_idle_2_confint = confint(p_idle(results, 2))
p_idle_confint = confint(p_idle(results))

p_busy_1_mean = mean(p_busy(results, 1))
p_busy_2_mean = mean(p_busy(results, 2))
p_busy_mean = mean(p_busy(results))
p_busy_1_confint = confint(p_busy(results, 1))
p_busy_2_confint = confint(p_busy(results, 2))
p_busy_confint = confint(p_busy(results))

println("The mean of wait time from the first server is: $WS_1_mean with a 95% confint of: $WS_1_confint")
println("The mean of wait time from the second server is: $WS_2_mean with a 95% confint of: $WS_2_confint")
println("The mean of wait time from both servers is: $WS_mean with a 95% confint of: $WS_confint")
println()
println("The mean of service time from the first server is: $WS_1_mean with a 95% confint of: $WS_1_confint")
println("The mean of service time from the second server is: $WS_2_mean with a 95% confint of: $WS_2_confint")
println("The mean of service time from both servers is: $WS_mean with a 95% confint of: $WS_confint")
println()
println("The probability of waiting from the first server is: $p_wait_1_mean with a 95% confint of: $p_wait_1_confint")
println("The probability of waiting from the second server is: $p_wait_2_mean with a 95% confint of: $p_wait_2_confint")
println("The probability of waiting from both servers is: $p_wait_mean with a 95% confint of: $p_wait_confint")
println()
println("The probability of an idle server from the first server is: $p_idle_1_mean with a 95% confint of: $p_idle_1_confint")
println("The probability of an idle server from the second server is: $p_idle_2_mean with a 95% confint of: $p_idle_2_confint")
println("The probability of an idle server from both servers is: $p_idle_mean with a 95% confint of: $p_idle_confint")
println()

println("The probability of an busy server from the first server is: $p_busy_1_mean with a 95% confint of: $p_busy_1_confint")
println("The probability of an busy server from the second server is: $p_busy_2_mean with a 95% confint of: $p_busy_2_confint")
println("The probability of an busy server from both servers is: $p_busy_mean with a 95% confint of: $p_busy_confint")
println()
# #this code was used to verify 2. b) calculations
# n = 10000
# uniTotal = 0
# erlTotal = 0
# for i in 1:n
#     uniTotal += rand(4:8)
#     erlTotal += round(Int, rand(Erlang(27, 2/9)))
# end
# println(uniTotal/n)
# println(erlTotal/n)