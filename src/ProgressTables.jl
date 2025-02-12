module ProgressTables

using Printf

export IncrementalProgressTable,
    initialize,
    next,
    separator,
    finalize

include("abstract.jl")
include("style.jl")
include("incremental.jl")

end
