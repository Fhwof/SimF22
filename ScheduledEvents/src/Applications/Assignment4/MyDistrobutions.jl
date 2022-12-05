import Base.rand
import Pkg
Pkg.add("Plots")
Pkg.add("StatsPlots")
Pkg.add("Distributions")
Pkg.add("BenchmarkTools")
using Plots, Distributions, Random, StatsPlots, BenchmarkTools

#---------- MyNormal ----------
# struct MyNormal <: Distribution{Univariate, Continuous}
#     mean::Float64
#     var::Float64
#     function MyNormal(mean::Float64 = 0.0, var::Float64 = 1.0)
#         return new(mean, var)
#     end
# end

# MyNormal(mean::Integer, var::Integer) = MyNormal(float(mean), float(var))

# function rand(dist::MyNormal)
#     mean = dist.mean
#     var = dist.var
#     return ?
# end


#---------- MyExp ----------
struct MyExp <: Distribution{Univariate, Continuous}
    b::Float64
    function MyExp(b::Float64 = 1.0)
        return new(b)
    end
end

MyExp(b::Integer) = MyExp(float(b))

function rand(dist::MyExp)
    b = dist.b
    return (-b) * log(1 - rand()) #b is the inverse of lambda
end

function rand(dist::MyExp, n::Int = 1)
    b = dist.b
    list = Float64[]
    for i in 1:n
        push!(list, (-b) * log(1 - rand()))
    end
    return list
end

MyExp200 = rand(MyExp(30), 200)
Exponential200 = rand(Exponential(30), 200)
qqnorm(rand(MyExp(30), 200), qqline = :fit, title = "MyExp")
qqnorm(rand(Exponential(30), 200), qqline = :fit, title = "Exponential")
qqplot(rand(MyExp(30), 200), rand(Exponential(30), 200), qqline = :fit, title = "Compare")

@btime rand(MyExp(30), 200)
@btime rand(Exponential(30), 200)