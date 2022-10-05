#-------------------------------------------------------
# constructor helpers

#arg checks

function argnamecheck(argName, measureNames)
    if ∉(argName, measureNames)
        error("Result Type argumment error - argument name $argName does not match any measurement names")
    end
end

standardizearg(RTdefault::Type, RTnew::Type)                        = RTnew
standardizearg(RTdefault::Type, indices)                            = (RTdefault, indices)
standardizearg(RTdefault::Type, RTnew_withIndices::Tuple{Type,Any}) = RTnew_withIndices

rtdefault(RT::Tuple) = RT[1]
rtdefault(RT::Type)  = RT

rtformat(RT::Tuple)  = RT[2]
rtformat(RT::Type)   = nothing



# Result Storage Types constructor and helper functions

#---
# RT_Dict - Holds the args stored as the measure name

function RT_newDict(measureNames, RT_const::Type)
    dict = Dict{Symbol,Union{Type, Tuple{Type,Any}}}()
    for name in measureNames
        dict[name] = RT_const
    end
    dict
end

function RT_addargs!(RTDict::Dict, RTdefault::Type, argName, argRT, measureNames)
    for i = 1:length(argName)
        argnamecheck(argName[i], measureNames)
        RTDict[argName[i]] = standardizearg(RTdefault, argRT[i])
    end
end

function RT_removeskips!(RTDict::Dict)
    for (argName, argRT) in RTDict
        argRT === Skip && delete!(RTDict, argName)
    end
end

function RT_Dict(RTdefault::Type, RTArgs::NamedTuple, measureNames)
    RTDict = RT_newDict(measureNames, RTdefault)
    RT_addargs!(RTDict, RTdefault, keys(RTArgs), values(RTArgs), measureNames)
    RT_removeskips!(RTDict)
    RTDict
end


#---
# toselector

# format(:c, (number, 0))
# (⨉(1, 0:1), ⨉(2, 0:1), ⨉(3, (1, 3, 5)))
# repeat(sim, NormalStats, 30; serving = Skip, queue = Skip, T_S = 1:3)
# repeat(sim, NormalStats, 30; serving = Skip, queue = Skip, T_S = (:c, 1:3)
#
# ts_format = ArgFormat(:c, 1:3)
# repeat(sim, NormalStats, 30; serving = Skip, queue = Skip, T_S = ts_format)
#
# ts_format = ArgFormat(dim_format = (:c, (number, 0)), 
#                       indices = (⨉(1, 0:1), ⨉(2, 0:1), ⨉(3, (1, 3, 5))))
# repeat(sim, NormalStats, 30; serving = Skip, queue = Skip, T_S = ts_format)

# Types

struct NotSymbol end
const number = NotSymbol()

struct Cross
    outer
    inner
end

const ⨉ = Cross        # ⨉ \bigtimes

struct ArgFormat
    dimFormat
    indices
end

function ArgFormat(;dim_format = ((number, 1),), indices = missing, dim_offset = dim_format, dim_offsets = dim_offset)
    if indices === missing 
        error("The list of indices is missing")
    else
        offsetFormat = standardizeformat(dim_offsets)
        ArgFormat(initialoffset(offsetFormat), indices)
    end
end

ArgFormat(dim_format::Union{Int,Symbol}, indices) = ArgFormat((dim_format,), indices)
ArgFormat(indices) = ArgFormat(((number, 1),), indices)

onearg(arg...) = (arg...,)

initialoffset(dformat::Tuple{Symbol,Any})    = onearg(dformat)
initialoffset(dformat::Tuple{NotSymbol,Any}) = onearg(dformat)
initialoffset(dformat) = dformat

standardizeformat(dformat::Int)                  = (number, dformat)
standardizeformat(dformat::Symbol)               = (dformat, 1)
standardizeformat(dformat::Tuple{Symbol,Any})    = dformat
standardizeformat(dformat::Tuple{NotSymbol,Any}) = dformat
standardizeformat(dformat::Tuple)                = map(standardizeformat, dformat)

# Helper functions

# measure(argName::Symbol, i)    = Symbol(String(argName) * "_" * string(i))
# measure(argName::Symbol, i, j) = Symbol(String(argName) * "_" * string(i) * "_" * string(j))

measure(argName::Symbol, i...) = Symbol(measure(String(argName), i))

function measure(argName::String, indices)
    for i in indices
        argName = *(argName, "_", string(i))
    end
    argName
end

flatsymbol(flatName::Symbol, i) = Symbol(String(flatName) *  string(i))
subscriptsymbol(outerName::Symbol, innerName::Symbol) = Symbol(String(outerName) * "_" * String(innerName))
subscriptsymbol(outerName::Symbol, innerName::NotSymbol) = Symbol(String(outerName) * "_")

indexoffset(index, offset) = index - (offset - 1)
flatselector(flatSelector::Nothing, index, offset) = (indexoffset(index, offset),)
flatselector(flatSelector::Tuple{}, index, offset) = (indexoffset(index, offset),)
flatselector(flatSelector::Tuple, index, offset) = (flatSelector..., indexoffset(index, offset))



# process a cross: a and b, where a is an int
#      - i.e., scenario 1)  process(a X (b1, b2, b3)) -> a_(process(b1)) ; a_(process(b2)) ; a_(process(b3))
function process_cross!(selectorIndices, flatSelector, flatName, format, offset, outerIndex::Int, innerIndices)
    flatName = flatsymbol(flatName, outerIndex)
    flatSelector = flatselector(flatSelector, outerIndex, offset)
    (subscriptName, newOffset) = standardizeformat(first(format)) 
    flatName = subscriptsymbol(flatName, subscriptName, )
    process_arg!(selectorIndices, flatSelector, flatName, newOffset, Base.tail(format), innerIndices)
end

# process a cross: a and b, where a is a tuple
#      - i.e., scenario 2)  process((a1, a2) X (b1, b2, b3)) -> process(a1 X b1) ; process(a1 X b2) ; process(a1 X b3) ; 
#                                                               process(a2 X b1) ; process(a2 X b2) ; process(a2 X b3)
function process_cross!(selectorIndices, flatSelector, flatName, format, offset, outerIndices, innerIndices)
    for outerIndex in outerIndices
        process_cross!(selectorIndices, flatSelector, flatName, format, offset, outerIndex, innerIndices)
    end
end

# process a single arg: arg is a Int
#      - create name:   mainName_subName with index appended 
#      - push arg on list
#      - push (name arg) on flat list

function process_arg!(selectorIndices::Vector, flatSelector, flatName, offset, argFormat, index::Int)
    flatSymbol = flatsymbol(flatName, index)
    flatSelector = flatselector(flatSelector, index, offset)
    push!(selectorIndices, (flatSymbol, flatSelector))
end


# process a single arg: arg is a Cross
#      - setup the processing: 
#              -   X(arg, (b1, b2, b3)) same as arg X (b1, b2, b3) -> arg x b1 ; arg1 X b2 ; arg X b3
#      - two scenarios:  
#            1) arg is an int     then   process(arg X (b1, b2, b3)) -> arg_(process(b1)) ; arg_(process(b2)) ; arg_(process(b3))
#            2) arg is an Tuple   then   process((a1, a2) X (b1, b2, b3)) -> process(a1 X b1) ; process(a1 X b2) ; process(a1 X b3) ; 
#                                                                            process(a2 X b1) ; process(a2 X b2) ; process(a2 X b3)
function process_arg!(selectorIndices::Vector, flatSelector, flatName, offset, format, indices::Cross)
    process_cross!(selectorIndices, flatSelector, flatName, format, offset, indices.outer, indices.inner)
end

# process a single arg: arg is a Tuple
#      - processes one argument at a time 
#      - i.e.  process( (arg1, arg2, arg3) )  ->  process(arg1);  process(arg2);  process(arg3)
function process_arg!(selectorIndices::Vector, flatSelector, flatName, offset, format, indices)
    for element in indices
        process_arg!(selectorIndices, flatSelector, flatName, offset, format, element)
    end
end

    

# function includeflatsymbol(measure::Symbol, indices)
#     ans = Vector{Tuple{Symbol,Int}}(undef, length(indices))
#     for i = 1:length(indices)
#         ans[i] = compose(flatsymbol(measure, indices[i]), indices[i])
#     end
#     (ans...,)
# end

determineindices(measure::Symbol, arg::Nothing)           = nothing
determineindices(measure::Symbol, arg::Tuple{Symbol,Any}) = determineindices(measure, ArgFormat((arg[1],), arg[2]))
determineindices(measure::Symbol, arg)                    = determineindices(measure, ArgFormat(arg))

function determineindices(measure::Symbol, arg::ArgFormat)
    selectorIndices = Vector()
    (subscriptName, offset) = standardizeformat(first(arg.dimFormat)) 
    flatName = subscriptsymbol(measure, subscriptName)
    process_arg!(selectorIndices, nothing, flatName, offset, Base.tail(arg.dimFormat), arg.indices)
    (selectorIndices...,)
end

function toselector(RTDict)
    selectorIndices = Dict{Symbol,Union{Nothing,Tuple}}()
    for (measure, RT) in RTDict
        selectorIndices[measure] = determineindices(measure, rtformat(RT))
    end
    selectorIndices
end



#---
# toresulttypes()

function flattenmeasure!(ResultTypes::Dict, measure::Symbol, RT, indices)
    for (flatMeasure, i) in indices
        ResultTypes[flatMeasure] = RT
    end
end

function toresulttypes(RTDict, selector)
    ResultTypes = Dict{Symbol,Type}()
    for (measure, indices) in selector
        if indices === nothing
            ResultTypes[measure] = RTDict[measure]
        else
            flattenmeasure!(ResultTypes, measure, RTDict[measure][1], indices)
        end
    end
    ResultTypes
end

#---
# resultsstorage
getmeasurement(values, measure::Symbol)             = getfield(values, measure)
getmeasurement(values::NamedTuple, measure::Symbol) = values[measure]
getmeasurement(values::Dict, measure::Symbol)       = values[measure]

function getnestedindex(measure, indices::Tuple)
    for i in indices
        measure = measure[i]
    end
    measure
end

function addvalue!(rDict::Dict, RT::Type, measure::Symbol, value, reps)
    rDict[measure] = RT(:init, value, reps)
end

# function addvalue!(rDict::Dict, RT::Type, measure::Symbol, value::Vector, reps)
#     error("Statistics can only be performed on scalar values" * 
#     "- a vector measure has been detected without selecting one or more values within it")
# end

function addvalue!(rDict::Dict, RTDict::Dict, measure::Symbol, indices::Nothing, value, reps)
    RT =  RTDict[measure]
    addvalue!(rDict::Dict, RT::Type, measure::Symbol, getmeasurement(value, measure), reps)
end

function addvalue!(rDict::Dict, RTDict::Dict, measure::Symbol, indices, values, reps)
    for (flatMeasure, i) in indices
        RT =  RTDict[flatMeasure]
        rDict[flatMeasure] = RT(:init, getnestedindex(getmeasurement(values, measure), i), reps)
    end
end

function resultsstorage(RTDict, selector, measureValues, reps)
    resultsDict = Dict{Symbol,Results}()
    for (measure, indices) in selector
        addvalue!(resultsDict, RTDict, measure, indices, measureValues, reps)
    end
    resultsDict
end

#---
# MultiMeasureResults constructor
 
function MMResults(RT::Type, RTArgs::NamedTuple, measureValues, reps)
    RTDict = RT_Dict(RT, RTArgs, measurenames(measureValues))
    selector = toselector(RTDict)
    ResultTypes = toresulttypes(RTDict, selector)
    storage = resultsstorage(ResultTypes, selector, measureValues, reps)
    statsDictionary = Dict{Symbol,NamedTuple}()
    MMResults(selector, storage, statsDictionary)
end
