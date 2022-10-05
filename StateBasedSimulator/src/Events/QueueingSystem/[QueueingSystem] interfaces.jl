abstract type QueueingSystem <: DiscreteEventSim end
abstract type SingleQueueSystem <: QueueingSystem end

initialevent(sim::QueueingSystem) = sim.initialEvent
endtime(sim::QueueingSystem) = sim.endTime
Time(sim::QueueingSystem)    = typeof(endtime(sim))

abstract type ArrivalEvent <: Event end
abstract type DepartureEvent <: Event end

function EventList(sim::QueueingSystem)
    EventList(:schedule, initialEvent = InitialEvent(sim), endTime = endtime(sim))
end

