#---------------------------------
# assume stats! updates do not exist
#     - let the application overide the default

stats!(event, sim, state) = nothing
stats!(event, sim, state, eventlist) = nothing

#---------------------------------
#  the state!(::EndEvent) update should never be run

state!(update::EndEvent, sim, state, eventlist) = nothing

#---------------------------------
# assume stats!(::Cleanup) and stats!(::EndEvent) update is not needed
#     - if hasTerminalEnd == true, i.e., the sim terimnates when the EndEvent occurs
#            - then Cleanup is not required (unless overidden by the application)
#            - the EndEvent should update the stats
#     - if hasTerminalEnd == false, 
#          i.e., the sim uses EndEvent to prevent new posts, 
#                but will run existing posts with posting times past the end when the EndEvent occurs
#            - then EndEvent is ignored (unless overidden by the application) 
#            - in this case Cleanup would update the stats
#     - in both cases, the default is to not run stats! for EndEvent
#       and let the application overide these defaults 
#            - (it is possible that neither Endevent, nor Cleanup would run stats! for a particular application)

# stats!(event::EndEvent, sim, state, eventlist) = nothing
# stats!(event::Cleanup, sim, state, eventlist) = nothing

#---------------------------------
# Allow post! calls to run stats! updates

struct Post end
from_post = Post()

function post!(eventList, event, Δtime, sim::DiscreteEventSim, state)
    post!(eventList, event, Δtime)
    stats!(event, from_post, sim, state, Δtime)
end
