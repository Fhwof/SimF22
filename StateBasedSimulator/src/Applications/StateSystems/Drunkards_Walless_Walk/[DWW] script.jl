include("../../../../deps/build.jl")        # load simulator - works in VS Code using shift-enter

dww = DWWSim()
runsim(dww, verbose = true)
runsim(dww)

results = repeat(dww, 1000)
mean(results)
confint(results)

maxitr(sim::DWWSim) = 100

results = repeat(dww, 1000)
mean(results)
confint(results)

