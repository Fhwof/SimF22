# for all constructors, x is the result of the first simulation run that doesn't have a missing value

Const(init::Symbol, x, rep) = Const(x)
Const(x) = Const(1, x)

Sum(init::Symbol, x, rep) = Sum(x)
Sum(x) = Sum(1, x)

BinomialStats(init::Symbol, x, rep) = BinomialStats(x)
BinomialStats(x) = BinomialStats(1, x)

NormalStats(init::Symbol, x, rep) = NormalStats(x)
NormalStats(x) = NormalStats(1, x, x^2, x, x)

StoredValues(init::Symbol, x, rep) = StoredValues(x, rep)

function StoredValues(x, n::Int)
    ElType = typeof(x)
    values = Vector{ElType}(undef, n)
    values[1] = x
    StoredValues{ElType}(values, 2)
end
