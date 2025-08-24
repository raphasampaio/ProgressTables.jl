module ProgressTables

using Printf

export IncrementalProgressTable,
    IncrementalSeparator,
    initialize,
    next,
    next!,
    separator,
    finalize,
    finalize!

include("abstract.jl")
include("style.jl")
include("incremental_table.jl")
include("incremental_separator.jl")
include("stdout.jl")

end
