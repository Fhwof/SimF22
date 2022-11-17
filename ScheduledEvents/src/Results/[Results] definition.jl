abstract type Results end
abstract type CondensedResults <: Results end
abstract type AllResults{T} <: Results end
abstract type Aggregation <: CondensedResults end
abstract type SimpleStats <: Aggregation end

mutable struct Const{T} <: CondensedResults
    n::Int
    value::T
end

mutable struct StoredValues{T} <: AllResults{T}
    values::Vector{T}
    loc::Int
end

# used when a state is stored instead of a single value
#   - StoredValues can be extracted from StateResults to perform statistics on, such as mean, var, etc.
#   - you can extract a field or a computation from various fields
mutable struct StateResults{T} <: AllResults{T}
    values::Vector{T}
    loc::Int
end

mutable struct Sum{T} <: Aggregation
    n::Int
    sum::T
end

mutable struct BinomialStats{T} <: SimpleStats
    n::Int
    sum::T
end

mutable struct NormalStats{T} <: SimpleStats
    n::Int
    sum::T
    sumSq::T
    min::T
    max::T
end
