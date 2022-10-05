#----------------------
# MultiMeasure Statistics distributer

function mapstats(statsFn::Function, results::MMResults)
    NamedTupled{statsnames(results)}(map(statsFn, values(results)))
end

function statsfn(statsFn::Function, results::MMResults)
    statsName = Symbol(statsFn)
    if hasstats(results, statsName)
        stats(results)[statsName]
    else
        statistics(results)[statsName] = mapstats(statsFn, results)
    end
end
