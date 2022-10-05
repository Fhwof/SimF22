abstract type Event end

struct Before <: Event end
struct EndEvent <: Event end
struct Cleanup <: Event end

cleanup = Cleanup()
end_event = EndEvent()

isbefore(e::Event)  = false
isbefore(e::Before) = true

isend(e::Event)    = false
isend(e::EndEvent) = true

timestamp(e::Event) = nothing
info(e::Event)      = nothing

print(event::Event) = show(event)

using Printf

function show(event::Event)
    @printf("\t%-11s", typeof(event))
end
