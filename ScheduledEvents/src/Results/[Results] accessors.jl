###########################################
#  Accessors for AllResults

values(r::AllResults)    = r.values
fillindex(r::AllResults) = r.loc

asvector(r::StoredValues) = values(r)


###########################################
# results[] i.e., getindex()

getindex(r::Results)  =   mean(r)

getindex(c::Const)    =   value(c)
getindex(c::Const, i) =   value(c)

getindex(r::AllResults, index)         =   values(r)[index]
setindex!(r::AllResults, value, index) = ( values(r)[index] = value )

getindex(stateResults::StateResults, fieldName::Symbol)                        =  selectfield(stateResults, fieldName)
getindex(stateResults::StateResults, fieldName::Symbol, indices...)            =  selectfield(stateResults, fieldName, indices...)
getindex(stateResults::StateResults, RT::Type, fieldName::Symbol)              =  selectfield(RT, stateResults, fieldName)
getindex(stateResults::StateResults, RT::Type, fieldName::Symbol, indices...)  =  selectfield(RT, stateResults, fieldName, indices...)
