include("../../../deps/build.jl")

dicediff = DiceDiff()

results = repeat(dicediff, 1000000, StoredValues)
calcDiff(results)