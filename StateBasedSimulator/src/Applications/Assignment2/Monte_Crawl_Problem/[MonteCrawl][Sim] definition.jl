####################################################
# Monte Hall Simulation Setup

# Strategy switch (through multiple dispatch) for the Monte Hall simulation
abstract type Strategy end
struct Switch <: Strategy end
struct Stay <: Strategy end
struct DoesntMatter <: Strategy end
struct Door3 <: Strategy end

# Simulation type definition
struct MonteCrawl <: DiscreteEventSim
    strategy::Strategy
end

# constructor
MonteCrawl(Strategy::Type) = MonteCrawl( Strategy())

# accessor
strategy(sim::MonteCrawl) = sim.strategy

