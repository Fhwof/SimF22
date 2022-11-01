function show(d::Doors)
    println("  prize  = ", prize(d) > 0 ? prize(d) : "<<not set>>")
    println("  chosen = ", chosen(d) > 0 ? chosen(d) : "<<not set>>")
    println("  reveal = ", revealed(d) > 0 ? revealed(d) : "<<not set>>")
end

verbose_withlinenum(sim::MonteCrawl) = false
verbose_splitstate(sim::MonteCrawl) = true
