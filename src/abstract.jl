abstract type AbstractProgressTable end

initialize(progress_table::AbstractProgressTable) = initialize(stdout, progress_table)
next(progress_table::AbstractProgressTable, row::AbstractVector; kwargs...) = next(stdout, progress_table, row; kwargs...)
separator(progress_table::AbstractProgressTable) = separator(stdout, progress_table)
Base.finalize(progress_table::AbstractProgressTable) = finalize(stdout, progress_table)