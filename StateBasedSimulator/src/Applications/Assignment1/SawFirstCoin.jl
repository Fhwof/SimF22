#I based the foundation of this simulator from how the
#drunkards walk sim was built.
#the drunkards walk sim was seperated into 6
#different files, so first I made sections
#of my code dedicated to what each file did.
#some files (like verbose) I didn't use, and
#some files (like the state/sim definitions)
#I combined into one section.

#This simulation checks the odds that a coin
#lands on heads, then tails for two coin flips.

#Although the case of having two tail flips is
#impossible for the situation given in the question,
#those cases must be taken into account for the
#total coin flips to get proper odds. I only count
#a tail flip if the first coin flip was heads.

#---------- sim/state definition ----------

struct SawFirstCoinSim <: StateSim end

mutable struct SawFirstCoinState <: State
    numTails::Int
    total::Int
end


function SawFirstCoinSim(sim::SawFirstCoinSim)
    measure(sim::SawFirstCoinSim, state) = ChanceOfTails(sim, state)
end


#---------- runsim ----------

function runsim(sim::SawFirstCoinSim, maxItr)
    runsim(sim, 10000, startstate(sim))
end

function runsim(sim::SawFirstCoinSim, maxItr, state)
    for i = 1:maxItr
        update!(sim, state)
    end
    state.numTails / state.total
end

#---------- interface ----------
startstate(sim::SawFirstCoinSim) = SawFirstCoinState(0, 0)

ChanceOfTails(sim::SawFirstCoinSim, state) = state.numTails/state.total

function update!(sim::SawFirstCoinSim, state::SawFirstCoinState)
    FirstCoin = rand((:heads, :tails))
    SecondCoin = rand((:heads, :tails))
    state.total += 1
    if FirstCoin == :heads && SecondCoin == :tails
        state.numTails += 1
    end
end

maxitr(sim::SawFirstCoinSim) = 10000

#---------- repeat ----------

function firstvalue(sim::SawFirstCoinSim)
    value = runsim(sim, maxitr(sim))
    while value === missing
        value = runsim(sim, maxitr(sim))
    end
    value
end

function repeat(sim::SawFirstCoinSim, reps::Int, RTConstant::Type = NormalStats;)
    firstValue = firstvalue(sim)
    results = Results(RTConstant, firstValue, reps)
    repeat(sim, results, reps)
end

function repeat(sim::SawFirstCoinSim, results::Results, reps::Int)  
    for i = 2:reps
        add!(results, runsim(sim, reps))
    end
    results
end