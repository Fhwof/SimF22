peek(el::Appendable_EL)  = isempty(el) ? nothing : first( events(el))
peek(el::Schedulable_EL) = isempty(el) ? nothing : peek( events(el))

dequeue!(el::Appendable_EL)       = isempty(el) ? nothing : dequeue!( events(el))
dequeue_pair!(el::Schedulable_EL) = isempty(el) ? nothing : dequeue_pair!( events(el))

futuretime(el::Schedulable_EL, Δtime) = futuretime(clock(el), Δtime)
time!(el::Schedulable_EL, newTime)    = time!(clock(el), newTime)

#----------------------
# Public

iterate(el::EventList)                    = iterate( events(el))
iterate(el::EventList, state)             = iterate( events(el), state)

function iterate(el::Editable_EL, state = nothing)
    event = nextevent!(el)
    event === nothing ? nothing : (event, nothing)
end

length(el::EventList)  = length(events(el))
isempty(el::EventList) = (length(el) == 0)

upcoming(el::Appendable_EL)      = peek(el)
upcoming(el::Schedulable_EL)     = peek(el)[1]
upcomingtime(el::Schedulable_EL) = peek(el)[2]

Δprev(el::Schedulable_EL)       = Δprev(clock(el))
currenttime(el::Schedulable_EL) = time(clock(el))
prevtime(el::Schedulable_EL)    = prevtime(clock(el))

nextevent!(el::Fixed_EL)      = popfirst!(el)        # slow - better to iterate
nextevent!(el::Appendable_EL) = dequeue!(el)

function nextevent!(el::Schedulable_EL)
    pair = dequeue_pair!(events(el))
    if pair === nothing
        nothing
    else
        (event, clockTime) = pair
        time!(el, clockTime)
        event
    end
end

# add! is a generaized synonym for append! and post!
add!(el::Appendable_EL, event)          = append!(el, event)
add!(el::Schedulable_EL, event, Δtime)  = post!(el, event, Δtime)

append!(el::Appendable_EL, E::Type)      = append!(el, E())                 # converting event types to events
append!(el::Appendable_EL, event::Event) = enqueue!(events(el), event)

post!(el::Schedulable_EL, E::Type, Δtime) = post!(el, E(), Δtime)           # converting event types to events

function post!(el::Schedulable_EL, event::Event, Δtime)
    postTime = futuretime(el, Δtime)
    if hasterminalend(el) && postTime >= endtime(el)
        nothing
    else
        add!(events(el), postTime, event)
    end
end


struct WithTimeStamp end
withTimeStamp = WithTimeStamp()

function post!(wts::WithTimeStamp, el::Schedulable_EL, PostingEvent::Type, Δtime)
    post!(e1, PostingEvent(currenttime(el)), Δtime)
end

function post!(wts::WithTimeStamp, el::Schedulable_EL, PostingEvent::Type, Δtime, info)
    post!(e1, PostingEvent(currenttime(el), info), Δtime)
end


show(io::IO, mime::MIME"text/plain", el::Schedulable_EL) = show(el)
print(el::Schedulable_EL) = show(el)

function show(el::Schedulable_EL)
    if hasterminalend(el)
        print("[$(currenttime(el)) << $(endtime(el))] ")
    else
        print("[$(currenttime(el)) < $(endtime(el))] ")
    end
    print(events(el))
end


#----------------------
# Public Searchable

getindex(el::Searchable_SchedEL, event) = getindex( events(el), index)
setindex!(el::Searchable_SchedEL, time, event) = setindex!( events(el), time, event)

delete!(el::Searchable_SchedEL, datum) = delete!(events(el), datum)

