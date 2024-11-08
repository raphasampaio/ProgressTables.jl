module ProgressTables

using Printf

export ProgressTable,
    initialize,
    next,
    separator,
    finalize

include("abstract.jl")
include("progress_table.jl")

end
