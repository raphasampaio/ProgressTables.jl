@kwdef struct Style
    alignment::Vector{Symbol}
    bold::Vector{Bool}
    italic::Vector{Bool}
    underline::Vector{Bool}
    blink::Vector{Bool}
    reverse::Vector{Bool}
    hidden::Vector{Bool}
    color::Vector{Symbol}
end
