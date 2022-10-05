import Base.show, Base.print

abstract type Verbosity end
struct Silent <: Verbosity end
struct Verbose <: Verbosity end

struct Header end
header = Header()
verbose(h::Header, sim::Simulation) = nothing

verbosity(verbose::Bool) = verbose ? Verbose() : Silent()

@generated function verbosefn(verbosity, args...)
    if verbosity <: Silent
        return :(nothing)
    else
        return :(verbose(args...))
    end
end

verbose_withlinenum(sim::Simulation) = true
verbose_splitstate(sim::Simulation) = false

verbose_linenum(sim::Simulation, i) = print("[", i, "]")
