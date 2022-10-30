#I based the foundation of this simulator from how the
#drunkards walk sim was built.
#the drunkards walk sim was seperated into 6
#different files, so first I made sections
#of my code dedicated to what each file did.
#some files (like verbose) I didn't use, and
#some files (like the state/sim definitions)
#I combined into one section.

#I needed to add perameters to choose between finding the
#odds of At Least N card packs vs Exactly N card packs
#and to find the average number of card packs bought.
#I found paremeters to be easier to implement than
#multiple dispatching.

#---------- sim/state definition ----------

struct GoldCardSim <: StateSim end

mutable struct GoldCardState <: State
    numSilver::Int
    numGold::Int
    numPacks::Int
end

#---------- runsim ----------

function runsim(sim::GoldCardSim, maxItr, m = :Packs, goal = 3, g = 0.5;)
    runsim(sim, 10000, startstate(sim), m, goal, g)
end

function runsim(sim::GoldCardSim, maxItr, state, m, goal, g)
    for i = 1:maxItr
        isfound(sim, state) && break
        update!(sim, state, g)
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
startstate(sim::GoldCardSim) = GoldCardState(0, 0, 0)

ChanceOfAtLeast(sim::GoldCardSim, state, goal) = state.numPacks >= goal ? 1 : 0
ChanceOfExact(sim::GoldCardSim, state, goal) = state.numPacks == goal ? 1 : 0
AveragePacks(sim::GoldCardSim, state) = state.numPacks

function update!(sim::GoldCardSim, state::GoldCardState, g)
    Card = rand() < g ? :gold : :silver
    state.numPacks += 1
    if Card == :silver
        state.numSilver += 1
    elseif Card == :gold
        state.numGold += 1
    end
end

maxitr(sim::GoldCardSim) = 10000
isfound(sim::GoldCardSim, state) = state.numSilver > 0 && state.numGold > 0

#---------- repeat ----------

function firstvalue(sim::GoldCardSim, m, goal, g)
    value = runsim(sim, maxitr(sim), m, goal, g)
    while value === missing
        value = runsim(sim, maxitr(sim))
    end
    value
end

function repeat(sim::GoldCardSim, reps::Int, RTConstant::Type = NormalStats, m::Symbol = :AtLeast, goal::Int = 2, g::Float64 = 0.5;)
    firstValue = firstvalue(sim, m, goal, g)
    results = Results(RTConstant, firstValue, reps)
    repeat(sim, results, reps, m, goal, g)
end

function repeat(sim::GoldCardSim, results::Results, reps::Int, m::Symbol, goal::Int, g::Float64)  
    for i = 2:reps
        add!(results, runsim(sim, reps, startstate(sim), m,  goal, g))
    end
    results
end