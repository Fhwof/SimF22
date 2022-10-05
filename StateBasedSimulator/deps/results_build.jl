import Base.values, Base.count, Base.sum
import Base.getindex, Base.setindex!
import Base.extrema, Base.maximum, Base.minimum
import Statistics.mean, Statistics.var, Statistics.std
import Statistics.median, Statistics.quantile

Results_path  =  source_path * "Results/"
general_path  = Results_path * "GeneralResults/"
single_path   = Results_path * "SingleResults/"
multiple_path = Results_path * "MultipleResults/"

# Load definitions
include(general_path  * "[Results] definition.jl")
include(multiple_path * "[MultiResults] definition.jl")

# Load Single Value Results methods
include(single_path   * "[SingleResults] constructors.jl")
include(single_path   * "[SingleResults] accessors.jl")
include(single_path   * "[SingleResults] add!.jl")

# Load Multiple Value Results methods
include(multiple_path * "[MultiResults] constructors.jl")
include(multiple_path * "[MultiResults] accessors.jl")
include(multiple_path * "[MultiResults] add!.jl")
include(multiple_path * "[MultiResults] statistics distributer.jl")

# Load high-level interface methods (creation and use)
include(general_path  * "[Results] factory.jl")
include(general_path  * "[Results] statistics.jl")
include(general_path  * "[Results] ttest.jl")


resultsLoaded = true
