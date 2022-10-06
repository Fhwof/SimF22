include("../../../deps/build.jl")

dicediff = SidesDiff(5, 5)

results = repeat(dicediff, 1000000, StoredValues)
calcDiff(results)

#confint(results)