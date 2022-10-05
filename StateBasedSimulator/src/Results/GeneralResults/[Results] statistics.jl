using HypothesisTests, Distributions, Statistics
import HypothesisTests.confint

###########################################
#  General Statistical functions on Collection
#      - count, sum, mean

value(c::Const)                = c.value

count(mm::MultiMeasureResults) = statsfn(count, mm)
count(agr::Const)              = agr.n
count(agr::Aggregation)        = agr.n
count(sv::StoredValues)        = sv.loc - 1

sum(mm::MultiMeasureResults)   = statsfn(sum, mm)
sum(c::Const)                  = value(c) * count(c)
sum(agr::Aggregation)          = agr.sum
sum(sv::StoredValues)          = sum( values(sv))

mean(mm::MultiMeasureResults)  = statsfn(mean, mm)
mean(c::Const)                 = value(c)
mean(agr::Aggregation)         = sum(agr) / count(agr)
mean(sv::StoredValues)         = mean( values(sv))

###########################################
#  More simple statistical measures
#       - does not apply to  Sum collections
#       - var, minimum, maximum. extrema

# helper function for the SimpleStats implementation of var 
sumsq(stats::NormalStats)     = stats.sumSq
biasedvar(stats::NormalStats) = sumsq(stats)/count(stats) - mean(stats)^2

var(mm::MultiMeasureResults) = statsfn(var, mm)
var(c::Const) = 0
var(stats::NormalStats)      = biasedvar(stats) * stats.n / (stats.n - 1)
var(sv::StoredValues)        = var( values(sv))

function var(stats::BinomialStats)
    p = mean(stats)
    p * (1 - p) / count(stats)
end

std(mm::MultiMeasureResults) = statsfn(std, mm)
std(c::Const) = 0
std(stats::SimpleStats)      = sqrt( var(stats))
std(sv::StoredValues)        = std( values(sv))

confint(mm::MultiMeasureResults) = statsfn(confint, mm)

function confint(stats::BinomialStats; level = 0.95, tail = :both, method = :wilson)
    confint(BinomialTest(sum(stats), count(stats)); level, tail, method)
end

function confint(stats::NormalStats; level = 0.95, tail = :both)
    confint( OneSampleTTest(mean(stats), std(stats), count(stats)); level, tail)
end

function confint(stats::StoredValues; level = 0.95, tail = :both)
    confint(OneSampleTTest(values(stats)); level, tail)
end

minimum(mm::MultiMeasureResults) = statsfn(minimum, mm)
minimum(c::Const)                = value(c)
minimum(stats::NormalStats)      = stats.min
minimum(sv::StoredValues)        = minimum( values(sv))

maximum(mm::MultiMeasureResults) = statsfn(maximum, mm)
minimum(c::Const)                = value(c)
maximum(stats::NormalStats)      = stats.max
maximum(sv::StoredValues)        = maximum( values(sv))

extrema(mm::MultiMeasureResults) = statsfn(extrema, mm)
minimum(c::Const)                = (value(c), value(c))
extrema(stats::NormalStats)      = (stats.min, stats.max)
extrema(sv::StoredValues)        = extrema( values(sv))



###########################################
#  Non-Parametric statistical measures
#       - only applis to StoredValues collections
#       - median, quantile

median(mm::MultiMeasureResults) = statsfn(median, mm)
minimum(c::Const)               = value(c)
median(sv::StoredValues)        = median( values(sv))

quantile(mm::MultiMeasureResults) = statsfn(quantile, mm)
quantile(sv::StoredValues, p)     = quantile( values(sv), p)
quantile(c::Const, p)             = value(c)
