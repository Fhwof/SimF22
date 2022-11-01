choose(s::Switch, d::Doors)       =  otherdoor(revealed(d), chosen(d))
choose(s::Stay, d::Doors)         =  chosen(d)
choose(s::DoesntMatter, d::Doors) =  rand( (chosen(d), otherdoor( revealed(d), chosen(d))) )
choose(s::Door3, d::Doors) = revealed(d) == 2 ? otherdoor(revealed(d), chosen(d)) : chosen(d)

function reveal(d::Doors)
    if prize(d) != 1 && chosen(d) != 1
        1
    elseif prize(d) != 2 && chosen(d) != 2
        2
    else
        3
    end
end

state!(event::Choice1, sim::MonteCrawl, state) = ( state.chosen = 3 )
state!(event::Reveal, sim::MonteCrawl, state)  = ( state.revealed = reveal(state) )
state!(event::Choice2, sim::MonteCrawl, state) = ( state.chosen = choose( strategy(sim), state) )
