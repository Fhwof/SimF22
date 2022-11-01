include("../../../../deps/build.jl")        # load simulator - works in VS Code using shift-enter


doesntMatter = repeat(MonteCrawl(DoesntMatter), 100000)
stay = repeat(MonteCrawl(Stay), 100000)
switch = repeat(MonteCrawl(Switch), 100000)
door3 = repeat(MonteCrawl(Door3), 100000)

println()
println("The mean probability of the DoesntMatter strategy is: ", mean(doesntMatter))
println("The mean probability of the Stay strategy is: ", mean(stay))
println("The mean probability of the Switch strategy is: ", mean(switch))
println("The mean probability of the Door3 strategy is: ", mean(door3))
println()
println("The confidence interval of the probability of the DoesntMatter strategy is: ", confint(doesntMatter))
println("The confidence interval of the probability of the Stay strategy is: ", confint(stay))
println("The confidence interval of the probability of the Switch strategy is: ", confint(switch))
println("The confidence interval of the probability of the Door3 strategy is: ", confint(door3))
println()
println("The t-test of Door3 and DoesntMatter is: ", ttest(door3, doesntMatter))
println("The t-test of Door3 and Switch is: ", ttest(door3, switch))
