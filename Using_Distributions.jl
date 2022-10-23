import Pkg
Pkg.add("Distributions")      # used to generate various distributions (e.g., Normal) in Applications
using Distributions, Random

x = 3.2      # or whatever number you want to look up_down
q = 0.975     # or whatever percentage you want to look up
n = 50       # or however  many times you ran the simulation, i.e., the value you used in repeat()
dof = n - 1

nd = Normal(1.7,0.54)
pdf(nd, x)          # the pdf, i.e., the same as dnorm(x) in R
pdf(Normal(1.7,0.54), x)

cdf(nd, x)          # the cdf, i.e, the same as pnorm(x) in R
quantile(nd, q)     # the cdf-1, i.e., the same as qnorm(q) in R
rand(nd)            # the samd as rnorm(1) in R
rand(nd, 20)        # the same as rnorm(20) in R

td = TDist(dof)
pdf(td, x)          # the pdf, i.e., the same as dt in R
cdf(td, x)          # the cdf, i.e, the same as pt in R
quantile(td, q)     # the cdf-1, i.e., the same as qt in R
rand(td)            # the samd as rt(1) in R
rand(td, 20)        # the same as rt(20) in R

#----------------------------------------------
#  Example of it being used

nd_23 = Normal(2,3)
nd_01 = Normal(0,1)
nd_51 = Normal(5,1)

cdf(nd_23, 4)
cdf(nd_01, 4)
cdf(nd_51, 4)

#----------------------------------------------
#  Example of it being used

nd = Normal(1.7,0.54)
nd_32 = Normal(3,2)

# do not use - not fully functional - just here to show what is happening under the hood
function randrepeat(distribution, n)
    values = zeros(n)
    for i = 1:n
        values[i] = rand(distribution)
    end
    values
end

randrepeat(nd, 7)
randrepeat(nd_32, 7)

# simpler way
rand(nd, 7)
rand(nd_32, 7)

rand(Normal(2,3), 7)

# important distributions for us

# runif() < 0.3

rand() < 0.3

rand(Bernoulli(0.3))
rand(Bernoulli(0.3), 7)

rand(Geometric(2/5))
rand(Geometric(2/5), 7)

rand(Exponential(5/2))
rand(Exponential(5/2), 7)

exp = Exponential(5/2)
rand(exp, 7)
# R code: rexp(7, 5/2)

rand(Binomial(10, 0.3))
rand(Binomial(10, 0.3), 7)

# random Bernoulli trial
function berntrial(p)
    rand() < p
end

function rbinom(n, p)
    succ = 0
    for i = 1:n
        succ += berntrial(p)
    end
    succ
end

rbinom(10, 0.3)


rand(Poisson(5.5))
rand(Poisson(5.5), 7)

mean(rand(Exponential(5), 100000))
mean(rand(Poisson(5), 100000))

