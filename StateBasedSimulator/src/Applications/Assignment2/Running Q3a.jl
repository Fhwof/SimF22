include("../../../deps/build.jl")

𝜇 = 0.0
𝜎 = 1.0
println("\ncreating NormSim with 𝜇 = $𝜇, and 𝜎 = $𝜎")
sim = NormSim(𝜇, 𝜎)
results = repeat(sim, 10000)
println("𝜇 from Monte Carlo: ", mean(results))
println("𝜎 from Monte Carlo: ", std(results))

𝜇 = 10.0
𝜎 = 0.5
println("\ncreating NormSim with 𝜇 = $𝜇, and 𝜎 = $𝜎")
sim = NormSim(𝜇, 𝜎)
results = repeat(sim, 10000)
println("𝜇 from Monte Carlo: ", mean(results))
println("𝜎 from Monte Carlo: ", std(results))

𝜇 = 100.0
𝜎 = 150.0
println("\ncreating NormSim with 𝜇 = $𝜇, and 𝜎 = $𝜎")
sim = NormSim(𝜇, 𝜎)
results = repeat(sim, 10000)
println("𝜇 from Monte Carlo: ", mean(results))
println("𝜎 from Monte Carlo: ", std(results))