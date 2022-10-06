#---------- sim/state definition ----------

struct SpecialCardSim <: StateSim end

mutable struct SpecialCardState <: State
    numSilver::Int
    numGold::Int
    numPacks::Int
end


# function SpecialCardSim(sim::SpecialCardSim,  m = :AtLeast)
    
# end


#---------- runsim ----------

function runsim(sim::SpecialCardSim, maxItr, m = :AtLeast, goal = 3)
    runsim(sim, 10000, startstate(sim), m, goal)
end

function runsim(sim::SpecialCardSim, maxItr, state, m, goal)
    for i = 1:maxItr
        isfound(sim, state) && break
        update!(sim, state)
    end
    if m == :AtLeast
        ChanceOfAtLeast(sim, state, goal)
    elseif m == :Exact
        ChanceOfExact(sim, state, goal)
    elseif m == :Packs
        AveragePacks(sim, state)
    end
end

#---------- interface ----------
startstate(sim::SpecialCardSim) = SpecialCardState(0, 0, 0)

ChanceOfAtLeast(sim::SpecialCardSim, state, goal) = state.numPacks >= goal ? 1 : 0
ChanceOfExact(sim::SpecialCardSim, state, goal) = state.numPacks == goal ? 1 : 0
AveragePacks(sim::SpecialCardSim, state) = state.numPacks

function update!(sim::SpecialCardSim, state::SpecialCardState)
    Card = rand((:silver, :gold))
    state.numPacks += 1
    if Card == :silver
        state.numSilver += 1
    elseif Card == :gold
        state.numGold += 1
    end
end

maxitr(sim::SpecialCardSim) = 10000
isfound(sim::SpecialCardSim, state) = state.numSilver > 0 && state.numGold > 0

#---------- repeat ----------

function firstvalue(sim::SpecialCardSim, m, goal)
    value = runsim(sim, maxitr(sim), m, goal)
    while value === missing
        value = runsim(sim, maxitr(sim))
    end
    value
end

function repeat(sim::SpecialCardSim, reps::Int, RTConstant::Type = NormalStats, m::Symbol = :AtLeast, goal::Int = 2;)
    firstValue = firstvalue(sim, m, goal)
    results = Results(RTConstant, firstValue, reps)
    repeat(sim, results, reps, m, goal)
end

function repeat(sim::SpecialCardSim, results::Results, reps::Int, m::Symbol, goal::Int)  
    for i = 2:reps
        add!(results, runsim(sim, reps, startstate(sim), m,  goal))
    end
    results
end