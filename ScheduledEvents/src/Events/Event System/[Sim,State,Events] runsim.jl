#----------------------------------------------------------------------------------------------------
#  Setting up runsim by generating the EventList and StartState

function runsim(sim::DiscreteEventSim, v::Verbosity)
    runsim( sim, EventList(sim), v)
end

function runsim(sim::DiscreteEventSim, eventList::EventList, v::Verbosity)
    runsim( sim, StartState(sim), eventList, v)
end


#----------------------------------------------------------------------------------------------------
#  runsim for sims with ** Fixed ** event lists

function runsim(sim::DiscreteEventSim, state, eventList::Fixed_EL, v)
    i = 0
    verbosefn(v, header, sim)
    verbosefn(v, sim, :initial, state, 0)
    if !isfound(sim, state)
        for event in eventList
            stats!(event, sim, state)
            state!(event, sim, state)
            i = i + 1
            verbosefn(v, sim, event, state, i)
            isfound(sim, state) && break
        end
    end
    stats!(cleanup, sim, state)
    measure(sim, state)
end

#----------------------------------------------------------------------------------------------------
#  runsim for sims with ** Appendable ** event lists

function runsim(sim::DiscreteEventSim, eventsList::Appendable_EL, v)
    runsim(sim, maxitr(sim), eventsList, v)
end

function runsim(sim::DiscreteEventSim, maxItr::Nothing, eventsList::Appendable_EL, v)
    error("A maxitr() function must be defined for event simulators that have appendable event lists. Otherwise they may never terminate")
end

function runsim(sim::DiscreteEventSim, maxItr, eventsList::Appendable_EL, v)
    runsim(sim, maxItr, StartState(sim), eventsList, v)
end

function runsim(sim::DiscreteEventSim, maxItr, state, eventList::Appendable_EL, v)
    i = 0
    verbosefn(v, header, sim)
    verbosefn(v, sim, event, state, i)
    while i <= maxItr && !isfound(sim, state)
        event = nextevent!(eventList)
        stats!(event, sim, state, eventList)
        state!(event, sim, state, eventList)
        verbosefn(v, sim, event, state, i)
        i = i + 1
    end
    stats!(cleanup, sim, state, eventList)
    measure(sim, state)
end


#----------------------------------------------------------------------------------------------------
#  runsim for sims with ** Schedulable ** event lists

function runsim(sim::DiscreteEventSim, state, eventList::Schedulable_EL, v)
    event = Before()
    verbosefn(v, header, sim)
    verbosefn(v, sim, event, state, currenttime(eventList))
    while !isempty(eventList) && !isfound(sim, state)
        event = nextevent!(eventList)
        stats!(event, sim, state, eventList)
        state!(event, sim, state, eventList)
        verbosefn(v, sim, event, state, currenttime(eventList))
    end
    stats!(cleanup, sim, state, eventList)
    measure(sim, state)
end
