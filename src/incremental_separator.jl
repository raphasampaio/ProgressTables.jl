mutable struct IncrementalSeparator <: AbstractSeparator
    string::String
    string_length::Int
    max_steps::Int
    current_step::Int

    function IncrementalSeparator(string::AbstractString, max_steps::Integer)
        return new(string, length(string), max_steps, 0)
    end
end

function IncrementalSeparator(progress_table::IncrementalProgressTable, max_steps::Integer)
    return IncrementalSeparator(progress_table.separator, max_steps)
end

function next(io::IO, separator::IncrementalSeparator)
    if separator.current_step < separator.max_steps
        separator.current_step += 1

        from = div(separator.string_length * (separator.current_step - 1), separator.max_steps) + 1
        to = div(separator.string_length * separator.current_step, separator.max_steps)

        print(io, separator.string[from:to])
    end

    return nothing
end

function Base.finalize(io::IO, separator::IncrementalSeparator)
    if separator.current_step < separator.max_steps
        from = div(separator.string_length * separator.current_step, separator.max_steps) + 1
        print(io, separator.string[from:end])
    end
    println(io)

    separator.current_step = separator.max_steps

    return nothing
end
