####################################################
# Monte Hall Simulation Events interface

struct Choice1 <: Event end
struct Reveal  <: Event end
struct Choice2 <: Event end

EventList(sim::MonteCrawl) = EventList(Choice1, Reveal, Choice2)
