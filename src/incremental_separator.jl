mutable struct IncrementalSeparator
    string::String
    string_length::Int
    max_steps::Int
    current_step::Int

    function IncrementalSeparator(string::String, max_steps::Integer)
        return new(string, length(string), max_steps, 0)
    end
end

function next!(io::IO, separator::IncrementalSeparator)
    if separator.current_step < separator.max_steps
        separator.current_step += 1

        from = div(separator.string_length * (separator.current_step - 1), separator.max_steps) + 1 
        to = div(separator.string_length * separator.current_step, separator.max_steps)

        print(io, separator.string[from:to])
    end

    return nothing
end

function finalize!(io::IO, separator::IncrementalSeparator)
    if separator.current_step < separator.max_steps
        from = div(separator.string_length * separator.current_step, separator.max_steps) + 1
        print(io, separator.separator[from:end])
    end
    separator.current_step = separator.max_steps

    return nothing
end

