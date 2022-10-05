# general Accessors
getindex(r::Results)  =   mean(r)
getindex(r::Results, fn::Function)  =   fn(r)

getindex(c::Const)    =   value(c)
getindex(c::Const, i) =   value(c)


# StoredValues Accessors
values(sv::StoredValues)    = sv.values
fillindex(sv::StoredValues) = sv.loc

getindex(sv::StoredValues, index)         =   sv.values[index]
setindex!(sv::StoredValues, value, index) = ( sv.values[index] = value )
