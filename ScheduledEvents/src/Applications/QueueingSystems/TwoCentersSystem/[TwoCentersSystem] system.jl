#---------------------------------
# Sim

struct TwoCentersSystem{Time} <: SingleQueueSystem 
    servers::Vector{Int}
    endTime::Time
end

const TCSystem = TwoCentersSystem

TCSystem(;end_time = 0.0, c1 = 1, c2 = 1) = TCSystem([c1, c2], end_time)

servers(sim::TCSystem)    = sim.servers
servers(sim::TCSystem, i) = servers(sim)[i]


#---------------------------------
# Events

struct Arrival <: ArrivalEvent end
struct D1 <: DepartureEvent end
struct D2 <: DepartureEvent end

arrival(sim::TCSystem)      = Arrival()
departure(sim::TCSystem)    = (D1(), D2())
departure(sim::TCSystem, i) = departure(sim)[i]

InitialEvent(sim::TCSystem) = arrival(sim)


#---------------------------------
# State and Stats
#    - all state and stats variables exist in the system's State
#    - updates to this general state is separated into state!() and stats! update functions
#      to more easily understand and design the simulation
#    - however, in actuality, both functions update the general system state 
#      (i.e., there isn't a separate stats struct)

mutable struct TwoCentersState{Time} <: State
    queue::Vector{Int}
    serving::Vector{Int}
    N::Int
    NW::Vector{Int}
    WQ::Vector{Time}
    WS::Vector{Time}
    TS::Vector{Vector{Time}}
    Tmax::Time
    IAT::Time
    iatime::Time
    stime::Vector{Time}
end

const TCState = TwoCentersState

function StartState(sim::TCSystem)
    z  = zero(Time(sim))
    zv1 = zeros(Time(sim),servers(sim, 1) + 1)              # add 1 to include case where no server is busy
    zv2 = zeros(Time(sim),servers(sim, 2) + 1)              # add 1 to include case where no server is busy
    TCState([0,0], [0,0], 0, [0,0], [z,z], [z,z], [zv1,zv2], z, z, z, [z,z])
end

# some useful informational methods
serving(s::TCState)                    =  s.serving
serving(s::TCState, i)                 =  serving(s)[i]
allbusy(sim::TCSystem, s::TCState, i)  =  servers(sim, i) == serving(s, i)
allidle(sim::TCSystem, s::TCState, i)  =  serving(s, i) == 0
queue(s::TCState)                      =  s.queue
queue(s::TCState, i)                   =  queue(s)[i]
queueempty(s::TCState, i)              =  queue(s, i) == 0

# some useful update methods
incqueue!(s::TCState, i)   =  (s.queue[i] += 1)
decqueue!(s::TCState, i)   =  (s.queue[i] -= 1)
incserving!(s::TCState, i) =  (s.serving[i] += 1)
decserving!(s::TCState, i) =  (s.serving[i] -= 1)


#---------------------------------
# Verbose printing of State and Stats

function verbose(h::Header, s::TCSystem)
    print("\t\t\tLQ_1", "\tLS_1",    "\tLQ_2",      "\tLS_2")
    print("\tN",        "\tNW",      "\tWQ",        "\tWS")
    print("\tT1∀idle",  "\tT2∀idle", "\tT1∀busy",   "\tT2∀busy")
    print("\tIAT",      "\tiat",    "\tsvt_1",      "\tsvt_2\n")
end

# note: @offset is not used here - so TS[1][1] would be @offset TS[1][0], etc.
function show(s::TCState)
    print("\t$(s.queue[1])",   "\t$(s.serving[1])", "\t$(s.queue[2])",  "\t$(s.serving[2])")
    print("\t$(s.N)",         "\t$(sum(s.NW))",    "\t$(sum(s.WQ))",   "\t$(sum(s.WS))")
    print( "\t$(s.TS[1][1])", "\t$(s.TS[2][1])",   "\t$(s.TS[1][3])", "\t$(s.TS[2][2])")
    print( "\t$(s.IAT)",      "\t$(s.iatime)",     "\t$(s.stime[1])",   "\t$(s.stime[2])")
end


#---------------------------------
# Common state! and stats! update subroutines

function state!_arriving(sim::TCSystem, state, eventList, i)
    if allbusy(sim, state, i)
        incqueue!(state, i)
    else
        incserving!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim, i), sim, state)
    end
end

function state!_leaving(sim::TCSystem, state, eventList, i)
    # customer leaves service center i
    if queueempty(state, i)
        decserving!(state, i)
    else
        decqueue!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim, i), sim, state)
    end
end

function stats!_timeupdate(sim::TCSystem, state, eventList)
    for i = 1:2
        state.WQ[i]   +=   Δprev(eventList) * queue(state, i) 
        state.WS[i]   +=   Δprev(eventList) * serving(state, i)
        @offset (1,0) state.TS[i][serving(state, i)]  +=  Δprev(eventList)            # remember Julia is 1 indexed, not zero index, so need @offset
    end
    state.Tmax    +=   Δprev(eventList)
end

inc_NW!(sim::TCSystem, state, i)  =  allbusy(sim, state, i) && (state.NW[i] += 1)


#---------------------------------
# Arrival event updates

function state!(event::Arrival, sim::TCSystem, state, eventList)
    # arrived - schedule a new arrival
    post!(eventList, arrival(sim), interarrivaltime(sim), sim, state)

    # customer goes to first service center
    state!_arriving(sim::TCSystem, state, eventList, 1)
end

function stats!(event::Arrival, sim::TCSystem, state, eventList)
    state.N = state.N + 1
    inc_NW!(sim::TCSystem, state, 1)                   # when all servers are busy, customre is added to Q1 
    stats!_timeupdate(sim::TCSystem, state, eventList)
end

function stats!(event::Arrival, from::Post, sim::TCSystem, state, iat)
    state.IAT + iat < endtime(sim)  &&  ( state.IAT += iat )
    state.iatime = iat
end


#---------------------------------
# D1 event updates

function state!(event::D1, sim::TCSystem, state, eventList)
    # customer leaves service center 1
    state!_leaving(sim, state, eventList, 1)

    # customer arrives at center 2
    state!_arriving(sim::TCSystem, state, eventList, 2)
end

function stats!(event::D1, sim::TCSystem, state, eventList)
    inc_NW!(sim::TCSystem, state, 2)                   # when all servers are busy, customre is added to Q2 
    stats!_timeupdate(sim, state, eventList)
end

function stats!(event::D1, from::Post, sim::TCSystem, state, serviceTime)
    state.stime[1] = serviceTime
end

#---------------------------------
# D2 event updates

function state!(event::D2, sim::TCSystem, state, eventList)
    # customer leaves service center 2
    state!_leaving(sim, state, eventList, 2)

    # customer exit system
end

function stats!(event::D2, sim::TCSystem, state, eventList)
    stats!_timeupdate(sim, state, eventList)
end

function stats!(event::D2, from::Post, sim::TCSystem, state, serviceTime)
    state.stime[2] = serviceTime
end



#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::TCSystem, state, eventList)
    stats!_timeupdate(sim::TCSystem, state, eventList)
end
