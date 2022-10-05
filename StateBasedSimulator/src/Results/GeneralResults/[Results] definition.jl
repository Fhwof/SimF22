abstract type Results end
abstract type Aggregation <: Results end
abstract type SimpleStats <: Aggregation end

struct Skip <: Results end

mutable struct Const{T} <: Results
    n::Int
    value::T
end

mutable struct StoredValues{T} <: Results
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
