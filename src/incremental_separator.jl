mutable struct IncrementalSeparator <: AbstractSeparator
    string::String
    string_length::Int
    max_steps::Int
    current_step::Int

    function IncrementalSeparator(string::AbstractString, max_steps::Integer)
        return new(string, length(string), max_steps, 0)
    end
end

function IncrementalSeparator(progress_table::IncrementalProgressTable)
    return IncrementalSeparator(progress_table.separator, progress_table.width)
end

function next(io::IO, separator::IncrementalSeparator)
    if separator.current_step < separator.max_steps
        separator.current_step += 1

        @show from = div(separator.string_length * (separator.current_step - 1), separator.max_steps) + 1
        @show to = div(separator.string_length * separator.current_step, separator.max_steps)
        @show separator.string

        print(io, separator.string[from:to])
    end

    return nothing
end

function Base.finalize(io::IO, separator::IncrementalSeparator)
    if separator.current_step < separator.max_steps
        from = div(separator.string_length * separator.current_step, separator.max_steps) + 1
        print(io, separator.separator[from:end])
    end
    separator.current_step = separator.max_steps

    return nothing
end
