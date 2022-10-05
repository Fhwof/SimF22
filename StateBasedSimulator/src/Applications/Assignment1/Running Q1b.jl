include("../../../deps/build.jl")

dicediff = SidesDiff(6, 6)

results = repeat(dicediff, 1000000, StoredValues)
calcDiff(results)

#confint(results)