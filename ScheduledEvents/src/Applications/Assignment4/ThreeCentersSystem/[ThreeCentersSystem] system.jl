#---------------------------------
# Sim

struct ThreeCentersSystem{Time} <: SingleQueueSystem 
    servers::Vector{Int}
    endTime::Time
end

const ThCSystem = ThreeCentersSystem

ThCSystem(;end_time = 0.0, c1 = 1, c2 = 1, c3 = 1) = ThCSystem([c1, c2, c3], end_time)

servers(sim::ThCSystem)    = sim.servers
servers(sim::ThCSystem, i) = servers(sim)[i]


#---------------------------------
# Events

struct A1 <: ArrivalEvent end
struct D1 <: DepartureEvent end
struct D2 <: DepartureEvent end
struct D3 <: DepartureEvent end

arrival(sim::ThCSystem)      = A1()
departure(sim::ThCSystem)    = (D1(), D2(), D3())
departure(sim::ThCSystem, i) = departure(sim)[i]

InitialEvent(sim::ThCSystem) = arrival(sim)


#---------------------------------
# State and Stats
#    - all state and stats variables exist in the system's State
#    - updates to this general state is separated into state!() and stats! update functions
#      to more easily understand and design the simulation
#    - however, in actuality, both functions update the general system state 
#      (i.e., there isn't a separate stats struct)

mutable struct ThreeCentersState{Time} <: State
    queue::Vector{Int}
    serving::Vector{Int}
    departures::Vector{Int}
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

const ThCState = ThreeCentersState

function StartState(sim::ThCSystem)
    z  = zero(Time(sim))
    zv1 = zeros(Time(sim),servers(sim, 1) + 1)              # add 1 to include case where no server is busy
    zv2 = zeros(Time(sim),servers(sim, 2) + 1)              # add 1 to include case where no server is busy
    zv3 = zeros(Time(sim),servers(sim, 2) + 1)              # add 1 to include case where no server is busy
    ThCState([0,0,0], [0,0,0], [0,0,0], 0, [0,0,0], [z,z,z], [z,z,z], [zv1,zv2,zv3], z, z, z, [z,z,z])
end

# some useful informational methods
serving(s::ThCState)                    =  s.serving
serving(s::ThCState, i)                 =  serving(s)[i]
allbusy(sim::ThCSystem, s::ThCState, i)  =  servers(sim, i) == serving(s, i)
allidle(sim::ThCSystem, s::ThCState, i)  =  serving(s, i) == 0
queue(s::ThCState)                      =  s.queue
queue(s::ThCState, i)                   =  queue(s)[i]
queueempty(s::ThCState, i)              =  queue(s, i) == 0

# some useful update methods
incqueue!(s::ThCState, i)   =  (s.queue[i] += 1)
decqueue!(s::ThCState, i)   =  (s.queue[i] -= 1)
incserving!(s::ThCState, i) =  (s.serving[i] += 1)
decserving!(s::ThCState, i) =  (s.serving[i] -= 1)
incdepartures!(s::ThCState, i) = (s.departures[i] += 1)


#---------------------------------
# Verbose printing of State and Stats

function verbose(h::Header, s::ThCSystem)
    print("\t\t\tLQ_1,2,3", "\tLS_1,2,3")
    print("\tN",        "\tNW",      "\tWQ",        "\tWS")
    print("\tT1 idle",  "\tT2 idle", "\tT3 idle", "\tT1 busy",   "\tT2 busy", "\tT3 busy")
    print("\tIAT",      "\tiat",    "\tsvt_1,2,3\n")
end

# note: @offset is not used here - so TS[1][1] would be @offset TS[1][0], etc.
function show(s::ThCState)
    print("\t$(s.queue[1]),$(s.queue[2]),$(s.queue[3])",   "\t\t$(s.serving[1]),$(s.serving[2]),$(s.serving[3])")
    print("\t\t$(s.N)",         "\t$(sum(s.NW))",    "\t$(sum(s.WQ))",   "\t$(sum(s.WS))")
    print( "\t$(s.TS[1][1])", "\t$(s.TS[2][1])", "\t$(s.TS[3][1])",   "\t$(s.TS[1][2])", "\t$(s.TS[2][2])", "\t$(s.TS[3][2])")
    print( "\t$(s.IAT)",      "\t$(s.iatime)",     "\t$(s.stime[1]), $(s.stime[2]), $(s.stime[3])")
end

function stats!_timeupdate(sim::ThCSystem, state, eventList)
    for i = 1:3
        state.WQ[i]   +=   Δprev(eventList) * queue(state, i) 
        state.WS[i]   +=   Δprev(eventList) * serving(state, i)
        @offset (1,0) state.TS[i][serving(state, i)]  +=  Δprev(eventList)            # remember Julia is 1 indexed, not zero index, so need @offset
    end
    state.Tmax    +=   Δprev(eventList)
end

#---------------------------------
# Arrival 
function state!(event::A1, sim::ThCSystem, state, eventList)
    post!(eventList, arrival(sim), interarrivaltime(sim), sim, state)
    state!_arriving(sim::ThCSystem, state, eventList, 1)
end

# function for all service center arrivals
function state!_arriving(sim::ThCSystem, state, eventList, i)
    if allbusy(sim, state, i)
        incqueue!(state, i)
    else
        incserving!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim), sim, state)
    end
end

#----- Arrival Stats

function stats!(event::A1, sim::ThCSystem, state, eventList)
    state.N = state.N + 1
    inc_NW!(sim::ThCSystem, state, 1)                   # when all servers are busy, customre is added to Q1 
    stats!_timeupdate(sim::ThCSystem, state, eventList)
end

function stats!(event::A1, from::Post, sim::ThCSystem, state, iat)
    state.IAT + iat < endtime(sim)  &&  ( state.IAT += iat )
    state.iatime = iat
end

#---------------------------------
# Departure 

function state!_leaving(sim::ThCSystem, state, eventList, i)
    # customer leaves service center i
    if queueempty(state, i)
        decserving!(state, i)
    else
        decqueue!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim), sim, state)
    end
end

function state!(event::D1, sim::ThCSystem, state, eventList)
    # customer leaves service center 1
    state!_leaving(sim, state, eventList, 1)

    # customer arrives at center choice
    if(choice(sim))
        state!_arriving(sim::ThCSystem, state, eventList, 2)
    else
        state!_arriving(sim::ThCSystem, state, eventList, 3)
    end
end

function state!(event::D2, sim::ThCSystem, state, eventList)
    # customer leaves service center 1
    state!_leaving(sim, state, eventList, 2)
end

function state!(event::D3, sim::ThCSystem, state, eventList)
    # customer leaves service center 1
    state!_leaving(sim, state, eventList, 3)
end

#----- Departure Stats

function stats!(event::D1, sim::ThCSystem, state, eventList)
    inc_NW!(sim::ThCSystem, state, 2)                   # when all servers are busy, customre is added to Q2 
    stats!_timeupdate(sim, state, eventList)
    incdepartures!(state, 1)
end

function stats!(event::D1, from::Post, sim::ThCSystem, state, serviceTime)
    state.stime[1] = serviceTime
end

function stats!(event::D2, sim::ThCSystem, state, eventList)
    stats!_timeupdate(sim, state, eventList)
    incdepartures!(state, 2)
end

function stats!(event::D2, from::Post, sim::ThCSystem, state, serviceTime)
    state.stime[2] = serviceTime
end

function stats!(event::D3, sim::ThCSystem, state, eventList)
    stats!_timeupdate(sim, state, eventList)
    incdepartures!(state, 3)
end

function stats!(event::D3, from::Post, sim::ThCSystem, state, serviceTime)
    state.stime[3] = serviceTime
end

inc_NW!(sim::ThCSystem, state, i)  =  allbusy(sim, state, i) && (state.NW[i] += 1)

#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::ThCSystem, state, eventList)
    stats!_timeupdate(sim::ThCSystem, state, eventList)
end
