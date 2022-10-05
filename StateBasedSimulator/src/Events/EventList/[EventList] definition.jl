using DataStructures

#------------------------------------------------
# Type Definition

abstract type EventList end
abstract type Editable_EL <: EventList end
abstract type Schedulable_EL  <: Editable_EL end

struct Fixed_EL{N,Event} <: EventList
    events::NTuple{N,Event}
end

struct Appendable_EL{Event} <: Editable_EL
    events::Queue{Event}
end

struct Simple_SchedEL{Event,Time} <: Schedulable_EL
    clock::Clock{Time}
    endTime::Time
    hasTerminalEnd::Bool
    events::BasicHeap{Event,Time}
end

struct Searchable_SchedEL{Event,Key,Time} <: Schedulable_EL
    clock::Clock{Time}
    endTime::Time
    hasTerminalEnd::Bool
    events::SearchableHeap{Event,Key,Time}
end


#------------------------------------------------
# Constructors

function EventList(first::Type, rest...)
    N = length(rest) + 1
    Fixed_EL{N,Event}((first(),  map(Event->Event(), rest)...))
end

function EventList(first::Event, rest...)
    N = length(rest) + 1
    Fixed_EL{N,Event}((first, rest...))
end

function EventList(eventListType::Symbol, args...; keywords...)
    if eventListType === :append
        Appendable_EL(args...)
    elseif eventListType === :schedule
        Schedulable_EL(args...; keywords...)
    else
        error("The first argument, must be an event type, or the symbol :append or :schedule.\n" * 
              "The symbol $eventListType was used instead.")
    end
end

#-------------------------------------------------------
# Appendable Event List constructors


Appendable_EL()                                              = Appendable_EL(Queue{Event}())
Appendable_EL{E}() where E <: Event                          = Appendable_EL(Queue{E}())
Appendable_EL{E}(FirstEvent::Type, args...) where E <: Event = Appendable_EL{E}(FirstEvent(args...))
Appendable_EL(FirstEvent::Type, args...)                     = Appendable_EL{Event}(FirstEvent(args...))

function Appendable_EL(firstEvent::Event)
    el = Appendable_EL()
    append!(el, firstEvent)
    el
end

#-------------------------------------------------------
# Schedulable Event List constructors

function timeconsistencycheck(startTime, endTime)
    if endTime <= startTime
        error("The end time must be greater than the clock's start time.\n" *
              "eventTime = $eventTime, startTime =  $startTime")
    end
end

function Schedulable_EL(; initialEvent = nothing, startTime = 0.0, endTime = 0.0, searchable = false, terminalEnd = true)
    Schedulable_EL(initialEvent, endTime;  startTime, searchable, terminalEnd)
end

function Schedulable_EL(initialEvent::Nothing, endTime; startTime = 0.0, searchable = false, terminalEnd = true)
    error("A schedulable event list must have initialEvent set, e.g., EventList(:schedule, initialEvent = Arrival, endTime = 1000.0")
end

function Schedulable_EL(InitialEvent::Type, endTime; startTime = 0.0, searchable = false, terminalEnd = true)
    Schedulable_EL(InitialEvent(), endTime;  startTime, searchable, terminalEnd)
end

function Schedulable_EL(initialEvent::Event, endTime; startTime = 0.0, searchable = false, terminalEnd = true)
    timeconsistencycheck(startTime, endTime)
    Time = typeof(endTime)
    Heap    = searchable ? SearchableHeap     : BasicHeap
    SchedEL = searchable ? Searchable_SchedEL : Simple_SchedEL

    heap = Heap{Event}(initialEvent, convert(Time, startTime))
    heap[end_event] = endTime
    SchedEL(Clock{Time}(startTime), endTime, terminalEnd, heap)
end


#------------------------------------------------
# accessors

clock(el::EventList)               = el.clock
endtime(el::Schedulable_EL)        = el.endTime
hasterminalend(el::Schedulable_EL) = el.hasTerminalEnd
events(el::EventList)              = el.events
