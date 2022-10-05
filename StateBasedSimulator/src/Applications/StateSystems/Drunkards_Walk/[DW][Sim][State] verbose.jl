function show(state::DrunkardsState)
    println("[$(steps(state))]\t-$(walls(state)) |\t$(location(state))\t| $(walls(state))")
end

verbose_withlinenum(sim::DWSim) = false
