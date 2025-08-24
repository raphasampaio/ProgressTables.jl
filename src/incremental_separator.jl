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

        from_char = div(separator.string_length * (separator.current_step - 1), separator.max_steps) + 1
        to_char = div(separator.string_length * separator.current_step, separator.max_steps)

        # Convert character indices to byte indices for proper Unicode handling
        from_byte = from_char == 1 ? 1 : nextind(separator.string, 0, from_char)
        to_byte = to_char == separator.string_length ? lastindex(separator.string) : prevind(separator.string, nextind(separator.string, 0, to_char + 1))

        print(io, separator.string[from_byte:to_byte])
    end

    return nothing
end

function Base.finalize(io::IO, separator::IncrementalSeparator)
    if separator.current_step < separator.max_steps
        from_char = div(separator.string_length * separator.current_step, separator.max_steps) + 1
        # Convert character index to byte index for proper Unicode handling
        from_byte = from_char == 1 ? 1 : nextind(separator.string, 0, from_char)
        print(io, separator.string[from_byte:end])
    end
    println(io)

    separator.current_step = separator.max_steps

    return nothing
end
