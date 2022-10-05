#----------------------
# Results - selecting and setting up the correct subtype

Results(RT::Type, RTArgs, value::Nothing, rep)     = nothing
Results(RT::Type, RTArgs::Nothing, value, rep)     = Results(RT, value, rep)

Results(RT::Type, value::Real, reps)               = ( RT <: StoredValues )  ?  RT(value, reps)  :  RT(value)
Results(RT::Type, value, reps)                     = MMResults(RT, NamedTuple(), value, reps)

function Results(RT::Type, RTArgs::NamedTuple, value, reps)
    if isempty(RTArgs)
        Results(RT, value, reps)
    else
        MMResults(RT, RTArgs, value, reps)
    end
end