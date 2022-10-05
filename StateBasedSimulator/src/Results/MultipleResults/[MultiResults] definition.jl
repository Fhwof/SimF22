#---------------------------------------------------
# MultiMeasureResults type definition

struct MultiMeasureResults <: Results
    # measure => storage mapping - subset of measures - unflattened
    selector::Dict{Symbol, Union{Nothing, Tuple}}

    # measure storage - subset of measures - flattend
    results::Dict{Symbol, Results}

    # stats function record (e.g. mean(), var() etc.)
    stats::Dict{Symbol,NamedTuple}
end

const MMResults = MultiMeasureResults

