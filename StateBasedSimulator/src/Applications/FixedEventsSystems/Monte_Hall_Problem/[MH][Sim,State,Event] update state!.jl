choose(s::Switch, d::Doors)       =  otherdoor(revealed(d), chosen(d))
choose(s::Stay, d::Doors)         =  chosen(d)
choose(s::DoesntMatter, d::Doors) =  rand( (chosen(d), otherdoor( revealed(d), chosen(d))) )

function reveal(d::Doors)
    (prize(d) != chosen(d)) ? otherdoor(prize(d), chosen(d)) : otherdoor(chosen(d))
end

state!(event::Choice1, sim::MonteHall, state) = ( state.chosen = randomdoor() )
state!(event::Reveal, sim::MonteHall, state)  = ( state.revealed = reveal(state) )
state!(event::Choice2, sim::MonteHall, state) = ( state.chosen = choose( strategy(sim), state) )
