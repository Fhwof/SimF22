#--------------------------------------------
#  Default interface used by WithStateSim for runsim 

startstate(sim::StateSim)     = nothing                     # manditory
measure(sim::StateSim, state) = state                       # problem based
isfound(sim::StateSim, state) = false                       # problem based
update!(sim::StateSim, state) = error("update!(sim, state) must be defined in the application")

function maxitr(sim::StateSim)
    error("For a State simulation, maxiter(sim) = user_supplied_int must be defined to protect against infinite runs \n" *
          "If an infinite length run is not possible, or it is a chance the user is willing to risk,\n" *
          "explicitly declare    maxiter(sim) = Inf")
end

