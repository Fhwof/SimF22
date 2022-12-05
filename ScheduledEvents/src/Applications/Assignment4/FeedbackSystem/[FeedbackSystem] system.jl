#---------------------------------
# Sim

struct ThreeCentersSystem{Time} <: SingleQueueSystem 
    servers::Vector{Int}
    endTime::Time
end

const FSystem = ThreeCentersSystem

FSystem(;end_time = 0.0, c1 = 1, c2 = 1, c3 = 1) = FSystem([c1, c2, c3], end_time)

servers(sim::FSystem)    = sim.servers
servers(sim::FSystem, i) = servers(sim)[i]


#---------------------------------
# Events

struct A1 <: ArrivalEvent end
struct D1 <: DepartureEvent end
struct D2 <: DepartureEvent end
struct D3 <: DepartureEvent end

arrival(sim::FSystem)      = A1()
departure(sim::FSystem)    = (D1(), D2(), D3())
departure(sim::FSystem, i) = departure(sim)[i]

InitialEvent(sim::FSystem) = arrival(sim)


#---------------------------------
# State and Stats
#    - all state and stats variables exist in the system's State
#    - updates to this general state is separated into state!() and stats! update functions
#      to more easily understand and design the simulation
#    - however, in actuality, both functions update the general system state 
#      (i.e., there isn't a separate stats struct)

mutable struct FeedbackState{Time} <: State
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

const FState = FeedbackState

#
#
#---------- CHECK TO SEE IF I NEED zv1, zv2, zv3 ----------
#
#
# StartState might work more like a single server system

function StartState(sim::FSystem)
    z  = zero(Time(sim))
    zv1 = zeros(Time(sim),servers(sim, 1) + 1)              # add 1 to include case where no server is busy
    zv2 = zeros(Time(sim),servers(sim, 2) + 1)              # add 1 to include case where no server is busy
    zv3 = zeros(Time(sim),servers(sim, 2) + 1)              # add 1 to include case where no server is busy
    FState([0,0,0], [0,0,0], 0, [0,0,0], [z,z,z], [z,z,z], [zv1,zv2,zv3], z, z, z, [z,z,z])
end

# some useful informational methods
serving(s::FState)                    =  s.serving
serving(s::FState, i)                 =  serving(s)[i]
allbusy(sim::FSystem, s::FState, i)  =  servers(sim, i) == serving(s, i)
allidle(sim::FSystem, s::FState, i)  =  serving(s, i) == 0
queue(s::FState)                      =  s.queue
queue(s::FState, i)                   =  queue(s)[i]
queueempty(s::FState, i)              =  queue(s, i) == 0

# some useful update methods
incqueue!(s::FState, i)   =  (s.queue[i] += 1)
decqueue!(s::FState, i)   =  (s.queue[i] -= 1)
incserving!(s::FState, i) =  (s.serving[i] += 1)
decserving!(s::FState, i) =  (s.serving[i] -= 1)


#---------------------------------
# Verbose printing of State and Stats

function verbose(h::Header, s::FSystem)
    print("\t\t\tLQ_1", "\tLS_1",    "\tLQ_2",      "\tLS_2",    "\tLQ_3",      "\tLS_3")
    print("\tN",        "\tNW",      "\tWQ",        "\tWS")
    print("\tT1 idle",  "\tT2 idle", "\tT3 idle", "\tT1 busy",   "\tT2 busy", "\tT3 busy")
    print("\tIAT",      "\tiat",    "\tsvt_1,2,3\n")
end

# note: @offset is not used here - so TS[1][1] would be @offset TS[1][0], etc.
function show(s::FState)
    print("\t$(s.queue[1])",   "\t$(s.serving[1])", "\t$(s.queue[2])",  "\t$(s.serving[2])", "\t$(s.queue[3])",  "\t$(s.serving[3])")
    print("\t$(s.N)",         "\t$(sum(s.NW))",    "\t$(sum(s.WQ))",   "\t$(sum(s.WS))")
    print( "\t$(s.TS[1][1])", "\t$(s.TS[2][1])", "\t$(s.TS[3][1])",   "\t$(s.TS[1][2])", "\t$(s.TS[2][2])", "\t$(s.TS[3][2])")
    print( "\t$(s.IAT)",      "\t$(s.iatime)",     "\t$(s.stime[1]), $(s.stime[2]), $(s.stime[3])")
end

function stats!_timeupdate(sim::FSystem, state, eventList)
    for i = 1:3
        state.WQ[i]   +=   Δprev(eventList) * queue(state, i) 
        state.WS[i]   +=   Δprev(eventList) * serving(state, i)
        @offset (1,0) state.TS[i][serving(state, i)]  +=  Δprev(eventList)            # remember Julia is 1 indexed, not zero index, so need @offset
    end
    state.Tmax    +=   Δprev(eventList)
end

#---------------------------------
# Arrival 
function state!(event::A1, sim::FSystem, state, eventList)
    post!(eventList, arrival(sim), interarrivaltime(sim), sim, state)
    state!_arriving(sim::FSystem, state, eventList, 1)
end

# function for all service center arrivals
function state!_arriving(sim::FSystem, state, eventList, i)
    if allbusy(sim, state, i)
        incqueue!(state, i)
    else
        incserving!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim), sim, state)
    end
end

#----- Arrival Stats

function stats!(event::A1, sim::FSystem, state, eventList)
    state.N = state.N + 1
    inc_NW!(sim::FSystem, state, 1)                   # when all servers are busy, customre is added to Q1 
    stats!_timeupdate(sim::FSystem, state, eventList)
end

function stats!(event::A1, from::Post, sim::FSystem, state, iat)
    state.IAT + iat < endtime(sim)  &&  ( state.IAT += iat )
    state.iatime = iat
end

#---------------------------------
# Departure 

function state!_leaving(sim::FSystem, state, eventList, i)
    # customer leaves service center i
    if queueempty(state, i)
        decserving!(state, i)
    else
        decqueue!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim), sim, state)
    end
end

function state!(event::D1, sim::FSystem, state, eventList)
    # customer leaves service center 1
    state!_leaving(sim, state, eventList, 1)

    # customer arrives at center choice
    if(choice(sim))
        state!_arriving(sim::FSystem, state, eventList, 2)
    else
        state!_arriving(sim::FSystem, state, eventList, 3)
    end
end

function state!(event::D2, sim::FSystem, state, eventList)
    # customer leaves service center 1
    state!_leaving(sim, state, eventList, 2)
end

function state!(event::D3, sim::FSystem, state, eventList)
    # customer leaves service center 1
    state!_leaving(sim, state, eventList, 3)

    # customer arrives at center feedback_choice
    if(feedback_choice(sim))
        state!_arriving(sim::FSystem, state, eventList, 1)
    else
        state!_arriving(sim::FSystem, state, eventList, 2)
    end
end

#----- Departure Stats

function stats!(event::D1, sim::FSystem, state, eventList)
    inc_NW!(sim::FSystem, state, 2)                   # when all servers are busy, customre is added to Q2 
    stats!_timeupdate(sim, state, eventList)
end

function stats!(event::D1, from::Post, sim::FSystem, state, serviceTime)
    state.stime[1] = serviceTime
end

function stats!(event::D2, sim::FSystem, state, eventList)
    stats!_timeupdate(sim, state, eventList)
end

function stats!(event::D2, from::Post, sim::FSystem, state, serviceTime)
    state.stime[2] = serviceTime
end

function stats!(event::D3, sim::FSystem, state, eventList)
    stats!_timeupdate(sim, state, eventList)
end

function stats!(event::D3, from::Post, sim::FSystem, state, serviceTime)
    state.stime[3] = serviceTime
end

inc_NW!(sim::FSystem, state, i)  =  allbusy(sim, state, i) && (state.NW[i] += 1)

#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::FSystem, state, eventList)
    stats!_timeupdate(sim::FSystem, state, eventList)
end
