module ProgressTables

using Printf

export IncrementalProgressTable,
    initialize,
    next,
    separator,
    finalize

include("abstract.jl")
include("incremental.jl")

end
