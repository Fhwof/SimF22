#---------------------------------
# Sim

struct SingleServerSystem{Time} <: SingleQueueSystem 
    endTime::Time
end

const SSSystem = SingleServerSystem

SSSystem(;end_time = 0.0) = SSSystem(end_time)


#---------------------------------
# Events

struct Arrival <: ArrivalEvent end
struct Departure <: DepartureEvent end

arrival(sim::SSSystem)   = Arrival()
departure(sim::SSSystem) = Departure()

InitialEvent(sim::SSSystem) = arrival(sim)


#---------------------------------
# State and Stats
#    - all state and stats variables exist in the system's State
#    - updates to this general state is separated into state!() and stats! update functions
#      to more easily understand and design the simulation
#    - however, in actuality, both functions update the general system state 
#      (i.e., there isn't a separate stats struct)

mutable struct SingleServerState{Time} <: State
    #state
    queue::Int
    busy::Bool
    #stats
    N::Int
    NW::Int
    WQ::Time
    WS::Time
    T_idle::Time
    Tmax::Time
    IAT::Time
    iatime::Time
    stime::Time
end

const SSState = SingleServerState

function StartState(sim::SSSystem)
    z = zero(Time(sim))
    SSState(0, false, 0, 0, z, z, z, z, z, z, z)
end

# some useful informational methods
serverbusy(s::SSState) = s.busy
serveridle(s::SSState) = !serverbusy(s)
queue(s::SSState)      = s.queue
queueempty(s::SSState) = queue(s) == 0

# some useful update methods
incqueue!(s::SSState)   = (s.queue += 1)
decqueue!(s::SSState)   = (s.queue -= 1)
serverbusy!(s::SSState) = (s.busy = true)
serveridle!(s::SSState) = (s.busy = false)


#---------------------------------
# Verbose printing of State and Stats

function verbose(h::Header, s::SSSystem)
    print("\t\t\tLQ", "\tbusy", "\tN")
    print("\tNW",     "\tWQ",  "\tWS")
    print("\tT_idle",  "\tIAT",  "\tiatime", "\tstime\n")
end

function show(s::SSState)
    print("\t$(s.queue)",  "\t$(s.busy)", "\t$(s.N)")
    print("\t$(s.NW)",    "\t$(s.WQ)",  "\t$(s.WS)")
    print("\t$(s.T_idle)", "\t$(s.IAT)",   "\t$(s.iatime)", "\t$(s.stime)")
end


#---------------------------------
# Arrival event state and stats updates

function state!(event::Arrival, sim::SSSystem, state, eventList)
    if serverbusy(state)
        incqueue!(state)
    else
        serverbusy!(state)
        post!(eventList, departure(sim), servicetime(sim), sim, state)
    end
    post!(eventList, arrival(sim), interarrivaltime(sim), sim, state)
end

function stats!(event::Arrival, sim::SSSystem, state, eventList)
    state.iatime = state.stime = 0
    state.N = state.N + 1
    state.WQ += Δprev(eventList) * queue(state)
    state.Tmax += Δprev(eventList)
    if serverbusy(state)                             # since new customer is placed in the queue 
        state.NW += 1                               #      add 1 to number of customers who have had to wait in a queue
        state.WS += Δprev(eventList)
    else
        state.T_idle += Δprev(eventList)
    end
end

function stats!(event::Arrival, from::Post, sim::SSSystem, state, iat)
    state.IAT + iat < endtime(sim)  &&  ( state.IAT += iat )
    state.iatime = iat
end


#---------------------------------
# Departure event state and stats updates

function state!(event::Departure, sim::SSSystem, state, eventList)
    state.iatime = state.stime = 0
    if queueempty(state)
        serveridle!(state)
    else
        decqueue!(state)
        post!(eventList, departure(sim), servicetime(sim), sim, state)
    end
end

function stats!(event::Departure, sim::SSSystem, state, eventList)
    state.WQ   +=  Δprev(eventList) * queue(state)
    state.WS   +=  Δprev(eventList)
    state.Tmax +=  Δprev(eventList)
end

function stats!(event::Departure, from::Post, sim::SSSystem, state, serviceTime)
    state.stime = serviceTime
end


#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::SSSystem, state, eventList)
    state.WQ += Δprev(eventList) * queue(state)
    state.Tmax +=  Δprev(eventList)
    if serverbusy(state)
        state.WS += Δprev(eventList)
    else
        state.T_idle += Δprev(eventList)
    end
end
