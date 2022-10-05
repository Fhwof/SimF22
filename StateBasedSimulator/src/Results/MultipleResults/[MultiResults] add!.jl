#--------------------------------------------------------------
#  MultiMeasures add!() - adding values across multiple measures

function add!(results::MMResults, measure::Symbol, indices::Nothing, value)
    add!(results[measure], getmeasurement(value, measure))
end

function add!(results::MMResults, measure::Symbol, indices, values)
    for (flatMeasure, i) in indices
        add!(results[flatMeasure], getnestedindex(getmeasurement(values, measure), i))
    end
end

function add!(results::MMResults, newValues)
    for (measure, indices) in selector(results)
        add!(results, measure, indices, newValues)
    end
end
