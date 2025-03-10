###########################################################################
#  Multiple Server System
###########################################################################
# -------------  [State]  -------------
#  queue::Vector{Int}                     
#  serving::Vector{Int}                   
# -------------  [Stats]  -------------
#  N::Int                                 
#  NW::Int                                
#  WQ::Time                               
#  WS::Time                               
#  TS::Vector{Time}                       
#  Tmax::Time               (Const)
#  IAT::Time                              
#  iatime::Time                           
#  stime::Time                            
###########################################################################

# -----------------------  [setup simulator]  --------------------------- #
include("../../../../deps/build.jl")

servicetime(sim::MultiServerSystem)      = rand(1:8)
interarrivaltime(sim::MultiServerSystem) = rand(3:12)

sim = MultiServerSystem(servers = 2, end_time = 100)


# -------------------------  [verbose run]  ----------------------------- #
runsim(sim, verbose = true)

# ----------------------  [run the simulator]  -------------------------- #
results = repeat(sim, 30);


# ------------------------  [perform stats]  ---------------------------- #
stats_WQ = results[:WQ]
mean(stats_WQ)
confint(stats_WQ)

stats_TS = @offset results[:TS, 0]
mean(stats_TS)
confint(stats_TS)

stats_TS = @offset results[NormalStats, :TS, 1]
mean(stats_TS)
confint(stats_TS)

stats_TS = @offset results[:TS, 2]
mean(stats_TS)
confint(stats_TS)

results[Const, :Tmax]
