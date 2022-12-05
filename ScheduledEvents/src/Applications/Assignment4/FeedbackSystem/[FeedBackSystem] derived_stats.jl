

# RateOfDeparture(r::Results, c::Int) = (mean(r[:departures, c]) / mean(r[:WS, c]))
# RateOfDeparture(r::Results) = (RateOfDeparture(r, 1) + RateOfDeparture(r, 2) + RateOfDeparture(r, 3))/3 

RateOfDeparture(r::Results, sim::FSystem, c::Int) = (mean(r[:departures, c]) / sim.endTime)
RateOfDeparture(r::Results, sim::FSystem) = (RateOfDeparture(r, sim, 1) + RateOfDeparture(r, sim, 2) + RateOfDeparture(r, sim, 3))/3 

RateOfDeparture(r::Results, sim::ThCSystem, c::Int) = (mean(r[:departures, c]) / sim.endTime)
RateOfDeparture(r::Results, sim::ThCSystem) = (RateOfDeparture(r, sim, 1) + RateOfDeparture(r, sim, 2) + RateOfDeparture(r, sim, 3))/3 

percentAllServeIdle(r::Results, sim::FSystem, c::Int) = (mean(r[:TS, c, 1]) / sim.endTime)
percentAllServeIdle(r::Results, sim::FSystem) = (percentAllServeIdle(r, sim, 1) + percentAllServeIdle(r, sim, 2) + percentAllServeIdle(r, sim, 3))/3 

percentAllServeBusy(r::Results, sim::FSystem, c::Int) = (mean(r[:TS, c, 2]) / sim.endTime)
percentAllServeBusy(r::Results, sim::FSystem) = (percentAllServeBusy(r, sim, 1) + percentAllServeBusy(r, sim, 2) + percentAllServeBusy(r, sim, 3))/3 

percentAllServeIdle(r::Results, sim::ThCSystem, c::Int) = (mean(r[:TS, c, 1]) / sim.endTime)
percentAllServeIdle(r::Results, sim::ThCSystem) = (percentAllServeIdle(r, sim, 1) + percentAllServeIdle(r, sim, 2) + percentAllServeIdle(r, sim, 3))/3 

percentAllServeBusy(r::Results, sim::ThCSystem, c::Int) = (mean(r[:TS, c, 2]) / sim.endTime)
percentAllServeBusy(r::Results, sim::ThCSystem) = (percentAllServeBusy(r, sim, 1) + percentAllServeBusy(r, sim, 2) + percentAllServeBusy(r, sim, 3))/3 