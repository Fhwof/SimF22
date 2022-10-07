#I based the foundation of this simulator from how the
#drunkards walk sim was built.
#the drunkards walk sim was seperated into 6
#different files, so first I made sections
#of my code dedicated to what each file did.
#some files (like verbose) I didn't use, and
#some files (like the state/sim definitions)
#I combined into one section.

#This simulation checks the odds that in two
#coin flips, it landed on both heads and tails.
#This is a small but important difference from
#part a.

#Although the case of having two tail flips is
#impossible for the situation given in the question,
#those cases must be taken into account for the
#total coin flips to get proper odds. I only count
#tail flips if their was also a head flip.

#---------- sim/state definition ----------

struct SawCoinSim <: StateSim end

mutable struct SawCoinState <: State
    numTails::Int
    total::Int
end


function SawCoinSim(sim::SawCoinSim)
    measure(sim::SawCoinSim, state) = ChanceOfTails(sim, state)
end


#---------- runsim ----------

function runsim(sim::SawCoinSim, maxItr)
    runsim(sim, 10000, startstate(sim))
end

function runsim(sim::SawCoinSim, maxItr, state)
    for i = 1:maxItr
        update!(sim, state)
    end
    state.numTails / state.total
end

#---------- interface ----------
startstate(sim::SawCoinSim) = SawCoinState(0, 0)

ChanceOfTails(sim::SawCoinSim, state) = state.numTails/state.total

function update!(sim::SawCoinSim, state::SawCoinState)
    FirstCoin = rand((:heads, :tails))
    SecondCoin = rand((:heads, :tails))
    state.total += 1
    if (FirstCoin == :heads && SecondCoin == :tails) || (FirstCoin == :tails && SecondCoin == :heads) 
        state.numTails += 1
    end
end

maxitr(sim::SawCoinSim) = 10000

#---------- repeat ----------

function firstvalue(sim::SawCoinSim)
    value = runsim(sim, maxitr(sim))
    while value === missing
        value = runsim(sim, maxitr(sim))
    end
    value
end

function repeat(sim::SawCoinSim, reps::Int, RTConstant::Type = NormalStats;)
    firstValue = firstvalue(sim)
    results = Results(RTConstant, firstValue, reps)
    repeat(sim, results, reps)
end

function repeat(sim::SawCoinSim, results::Results, reps::Int)  
    for i = 2:reps
        add!(results, runsim(sim, reps))
    end
    results
end