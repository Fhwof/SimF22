measure(sim::MonteHall, state) = won(state) ? 1 : 0
won(d::Doors) = (chosen(d) == prize(d))
