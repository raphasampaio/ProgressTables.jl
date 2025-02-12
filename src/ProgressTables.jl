module ProgressTables

using Printf

export IncrementalProgressTable,
    IncrementalProgressBar,
    initialize,
    next,
    separator,
    finalize

include("abstract.jl")
include("style.jl")
include("incremental_table.jl")
include("incremental_separator.jl")

end
