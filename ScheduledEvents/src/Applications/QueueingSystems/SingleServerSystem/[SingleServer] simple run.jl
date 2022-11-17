###########################################################################
#  Single Server System
###########################################################################
# -------------  [State]  -------------
#  queue::Int
#  busy::Bool
# -------------  [Stats]  -------------
#  N::Int
#  NW::Int
#  WQ::Time
#  WS::Time
#  T_idle::Time                             
#  Tmax::Time               (Const)
#  IAT::Time
#  iatime::Time
#  stime::Time
###########################################################################

# -----------------------  [setup simulator]  --------------------------- #
include("../../../../deps/build.jl")

servicetime(sim::SingleServerSystem)      = rand(3:12)
interarrivaltime(sim::SingleServerSystem) = rand(1:8)

sim = SingleServerSystem(end_time = 100)

# -------------------------  [verbose run]  ----------------------------- #
runsim(sim, verbose = true)

# ----------------------  [run the simulator]  -------------------------- #
# results = repeat(sim, 30; busy = Skip, queue = Skip, Tmax = Const);
results = repeat(sim, 30);

# ------------------------  [perform stats]  ---------------------------- #
stat_WQ = results[:WQ]
mean(stat_WQ)
var(stat_WQ)

t_idle = results[:T_idle];
mean(t_idle)
confint(t_idle)


results[Const, :Tmax]

results[:WQ]
results[NormalStats, :WQ]

stat_WQ = results[NormalStats, :WQ]
mean(stat_WQ)
var(stat_WQ)