import Pkg
Pkg.add("Distributions")      # used to generate various distributions (e.g., Normal) in Applications
using Distributions, Random

d = Normal(0.5, .25)

cdf(d, 0.5)
pdf(d, 0.5)

quantile(d, 0.841344746068543)

