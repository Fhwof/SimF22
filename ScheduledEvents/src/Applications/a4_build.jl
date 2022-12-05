

a4_path = source_path * "Applications/Assignment4/"

# ThreeCentersSystem
ThCS_path = a4_path * "ThreeCentersSystem/"
include(ThCS_path * "[ThreeCentersSystem] system.jl")

#FeedbackSystem
FS_Path = a4_path * "FeedbackSystem/"
include(FS_Path * "[FeedbackSystem] system.jl")
include(FS_Path * "[FeedbackSystem] derived_stats.jl")