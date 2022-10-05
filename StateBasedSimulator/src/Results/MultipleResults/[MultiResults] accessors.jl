#----------------------
# MultiMeasureResults accessors

selector(m::MMResults)     = m.selector
measurements(m::MMResults) = m.results
values(m::MMResults)       = values(measurements(m))

statistics(m::MMResults)  = m.stats
statsnames(m::MMResults)  = keys(stats(m))
statsvalues(m::MMResults) = values(stats(m))

measurenames(measures)             = fieldnames(typeof(measures))
measurenames(measures::NamedTuple) = keys(measures)
measurenames(measureValues::Dict)  = keys(measureValues)
measurenames(m::MMResults)         = keys(measurements(m))



#----------------------
# MultiMeasureResults info

# measurement info
hasmeasure(m::MMResults, name::Symbol) = haskey(measurements(m), name)
getindex(m::MMResults, name::Symbol) = get(measurements(m), name, nothing)

getindex(results::MMResults, name::Symbol, indices...) = results[measure(name, indices...)]

#statistics info
hasstats(measures::MMResults, statsName::Symbol) = haskey(stats(measures), statsName)
