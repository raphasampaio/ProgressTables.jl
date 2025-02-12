mutable struct IncrementalSeparator
    separator::String
    max_steps::Int
    current_step::Int

    function IncrementalSeparator(; separator::String, max_steps::Integer)
        return new(separator, max_steps, 0)
    end
end

function next!(io::IO, p::IncrementalSeparator)
    if p.current_step < p.max_steps
        p.current_step += 1
        print(io, p.separator[1:div(length(p.separator) * p.current_step, p.max_steps)])
    end
end

function done!(io::IO, p::IncrementalSeparator)
    p.current_step = p.max_steps
end

