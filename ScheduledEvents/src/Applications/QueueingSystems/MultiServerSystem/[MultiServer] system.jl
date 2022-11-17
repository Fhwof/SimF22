#---------------------------------
# Sim

struct MultiServerSystem{Time} <: SingleQueueSystem 
    servers::Int
    endTime::Time
end

const MSSystem = MultiServerSystem

MultiServerSystem(;end_time = 0.0, servers = 1) = MSSystem(servers, end_time)

servers(sim::MSSystem) = sim.servers


#---------------------------------
# Events

struct Arrival <: ArrivalEvent end
struct Departure <: DepartureEvent end

arrival(sim::MSSystem)   = Arrival()
departure(sim::MSSystem) = Departure()

InitialEvent(sim::MSSystem) = arrival(sim)


#---------------------------------
# State and Stats
#    - all state and stats variables exist in the system's State
#    - updates to this general state is separated into state!() and stats! update functions
#      to more easily understand and design the simulation
#    - however, in actuality, both functions update the general system state 
#      (i.e., there isn't a separate stats struct)

mutable struct MultiServerState{Time} <: State
    queue::Int
    serving::Int
    N::Int
    NW::Int
    WQ::Time
    WS::Time
    TS::Vector{Time}
    Tmax::Time
    IAT::Time
    iatime::Time
    stime::Time
end

const MSState = MultiServerState

function StartState(sim::MSSystem)
    z  = zero(Time(sim))
    zv = zeros(Time(sim),servers(sim) + 1)              # add 1 to include case where no server is busy
    MSState(0, 0, 0, 0, z, z, zv, z, z, z, z)
end

# some useful informational methods
serving(s::MSState)                 =  s.serving
allbusy(sim::MSSystem, s::MSState)  =  servers(sim) == serving(s)
allidle(s::MSState)                 =  serving(s) == 0
queue(s::MSState)                   =  s.queue
queueempty(s::MSState)              =  queue(s) == 0

# some useful update methods
incqueue!(s::MSState)   =  (s.queue += 1)
decqueue!(s::MSState)   =  (s.queue -= 1)
incserving!(s::MSState) =  (s.serving += 1)
decserving!(s::MSState) =  (s.serving -= 1)


#---------------------------------
# Verbose printing of State and Stats

function verbose(h::Header, s::MSSystem)
    print("\t\t\t\tL_Q", "\tserving",   "\tN")
    print("\tN_W",       "\tW_Q",    "\tW_S")
    print("\tT∀idle",    "\tT∀busy", "\tIAT") 
    print("\tiatime",    "\tstime\n")
end

function show(s::MSState)
    print("\t$(s.queue)",  "\t$(s.serving)",  "\t$(s.N)")
    print("\t$(s.NW)",     "\t$(s.WQ)",       "\t$(s.WS)")
    print("\t$(s.TS[1])",  "\t$(s.TS[end])",  "\t$(s.IAT)")
    print("\t$(s.iatime)", "\t$(s.stime)")
end


#---------------------------------
# Arrival event state and stats updates

function state!(event::Arrival, sim::MSSystem, state, eventList)
    if allbusy(sim, state)
        incqueue!(state)
    else
        incserving!(state)
        post!(eventList, departure(sim), servicetime(sim), sim, state)
    end
    post!(eventList, arrival(sim), interarrivaltime(sim), sim, state)
end

function stats!(event::Arrival, sim::MSSystem, state, eventList)
    state.N = state.N + 1
    allbusy(sim, state) && (state.NW += 1)                   # when all servers are busy, customer is added to the queue 
    state.WQ += Δprev(eventList) * queue(state)
    state.WS += Δprev(eventList) * serving(state)
    @offset state.TS[serving(state)] += Δprev(eventList)     # remember Julia is 1 indexed, not zero index, so @offset used
    state.Tmax += Δprev(eventList)
end

function stats!(event::Arrival, from::Post, sim::MSSystem, state, iat)
    state.IAT + iat < endtime(sim)  &&  ( state.IAT += iat )
    state.iatime = iat
end


#---------------------------------
# Departure event state and stats updates

function state!(event::Departure, sim::MSSystem, state, eventList)
    if queueempty(state)
        decserving!(state)
    else
        decqueue!(state)
        post!(eventList, departure(sim), servicetime(sim), sim, state)
    end
end

function stats!(event::Departure, sim::MSSystem, state, eventList)
    state.WQ += Δprev(eventList) * queue(state)
    state.WS += Δprev(eventList) * serving(state)
    @offset state.TS[serving(state)] += Δprev(eventList)               # remember Julia is 1 indexed, not zero index, so @offset used
    state.Tmax += Δprev(eventList)
end

function stats!(event::Departure, from::Post, sim::MSSystem, state, serviceTime)
    state.stime = serviceTime
end



#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::MSSystem, state, eventList)
    state.WQ += Δprev(eventList) * queue(state)
    state.WS += Δprev(eventList) * serving(state)
    @offset state.TS[serving(state)] += Δprev(eventList)               # remember Julia is 1 indexed, not zero index, so @offset used
    state.Tmax += Δprev(eventList)
end
