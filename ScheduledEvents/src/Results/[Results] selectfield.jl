#-----------------------------------------------------
# selectfield(sr::StateResults, fieldName) i.e. sr[:fieldName]
#   - Select one field from StateResult to perform stats (returned as a Results subtype ... default as StoredValues)
#   - acts analogously to a slice (without @view abilities ... but views are not really feasible given the data structure used)

function getvalue(array, indices, dim = 1)
    ( dim > length(indices) )  ?  array  :  getvalue(array[indices[dim]], indices, dim + 1)
end

firstvalue(stateResults::StateResults, fieldName::Symbol) = getfield(stateResults[1], fieldName)

function firstvalue(stateResults::StateResults, fieldName::Symbol, indices...)
    getvalue(getfield(stateResults[1], fieldName), (indices...,))
end

function addvalues!(selectResults, stateResults::StateResults, fieldName::Symbol)
    for i = 2:length(stateResults)
        add!(selectResults, getfield(stateResults[i], fieldName))
    end
end

function addvalues!(selectResults, stateResults::StateResults, fieldName::Symbol, indices...)
    indices = (indices...,)
    for i = 2:length(stateResults)
        array = getfield(stateResults[i], fieldName)
        add!(selectResults, getvalue(array, indices))
    end
end

function selectfield(stateResults::StateResults, fieldName::Symbol)
    selectResults = StoredValues(firstvalue(stateResults, fieldName), length(stateResults))
    addvalues!(selectResults, stateResults, fieldName)
    selectResults
end

function selectfield(stateResults::StateResults, fieldName::Symbol, indices...)
    selectResults = StoredValues(firstvalue(stateResults, fieldName, indices...), length(stateResults))
    addvalues!(selectResults, stateResults, fieldName, indices...)
    selectResults
end

function selectfield(RT::Type, stateResults::StateResults, fieldName::Symbol)
    if RT <: Const 
        Const(length(stateResults), getfield(stateResults[1], fieldName))
    else
        selectResults = RT(firstvalue(stateResults, fieldName))
        addvalues!(selectResults, stateResults, fieldName)
        selectResults
    end
end

function selectfield(RT::Type, stateResults::StateResults, fieldName::Symbol, indices...)
    if RT <: Const 
        getfield(stateResults[1], fieldName)[indices...]
    else
        selectResults = RT(firstvalue(stateResults, fieldName, indices...))
        addvalues!(selectResults, stateResults, fieldName, indices...)
        selectResults
    end
end
