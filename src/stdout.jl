function initialize(progress_table::AbstractProgressTable)
    ProgressTables.initialize(stdout, progress_table)
    return nothing
end

function next(progress_table::AbstractProgressTable, row::AbstractVector; kwargs...)
    ProgressTables.next(stdout, progress_table, row; kwargs...)
    return nothing
end

function separator(progress_table::AbstractProgressTable)
    ProgressTables.separator(stdout, progress_table)
    return nothing
end

function Base.finalize(progress_table::AbstractProgressTable)
    ProgressTables.finalize(stdout, progress_table)
    return nothing
end

function next!(separator::AbstractSeparator)
    ProgressTables.next!(stdout, separator)
    return nothing
end

function Base.finalize(separator::AbstractSeparator)
    ProgressTables.finalize(stdout, separator)
    return nothing
end
