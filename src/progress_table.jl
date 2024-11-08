struct ProgressTable <: AbstractProgressTable
    header::Vector{String}
    widths::Vector{Int}
    format::Vector{Printf.Format}
    border::Bool

    header_alignment::Vector{Symbol}
    header_bold::Vector{Bool}
    # header_italic::Vector{Bool}
    header_underline::Vector{Bool}
    header_blink::Vector{Bool}
    header_reverse::Vector{Bool}
    header_hidden::Vector{Bool}
    header_color::Vector{Symbol}

    alignment::Vector{Symbol}
    bold::Vector{Bool}
    # italic::Vector{Bool}
    underline::Vector{Bool}
    blink::Vector{Bool}
    reverse::Vector{Bool}
    hidden::Vector{Bool}
    color::Vector{Symbol}

    width::Int
    prefix_spacing::Vector{Int}
    suffix_spacing::Vector{Int}

    function ProgressTable(;
        header::Vector{String},
        widths::Vector{Int} = [length(column) + 2 for column in header],
        format::Vector{String} = ["%f" for _ in header],
        border::Bool = true,
        header_alignment::Vector{Symbol} = [:center for _ in header],
        header_bold::Vector{Bool} = [true for _ in header],
        # header_italic::Vector{Bool} = [false for _ in header],
        header_underline::Vector{Bool} = [false for _ in header],
        header_blink::Vector{Bool} = [false for _ in header],
        header_reverse::Vector{Bool} = [false for _ in header],
        header_hidden::Vector{Bool} = [false for _ in header],
        header_color::Vector{Symbol} = [:normal for _ in header],
        alignment::Vector{Symbol} = [:center for _ in header],
        bold::Vector{Bool} = [false for _ in header],
        # italic::Vector{Bool} = [false for _ in header],
        underline::Vector{Bool} = [false for _ in header],
        blink::Vector{Bool} = [false for _ in header],
        reverse::Vector{Bool} = [false for _ in header],
        hidden::Vector{Bool} = [false for _ in header],
        color::Vector{Symbol} = [:normal for _ in header],
    )
        size = length(header)

        width = if border
            size + sum(widths) + 1
        else
            size + sum(widths) - 1
        end

        suffix_spacing = Vector{Int}()
        for i in 1:size
            remaining = widths[i] - length(header[i])
            push!(suffix_spacing, floor(Int, remaining / 2))
        end

        prefix_spacing = Vector{Int}()
        for i in 1:size
            remaining = widths[i] - length(header[i])
            push!(prefix_spacing, remaining - suffix_spacing[i])
        end

        return new(
            header,
            widths,
            [Printf.Format(fmt) for fmt in format],
            border,
            header_alignment,
            header_bold,
            # header_italic,
            header_underline,
            header_blink,
            header_reverse,
            header_hidden,
            header_color,
            alignment,
            bold,
            # italic,
            underline,
            blink,
            reverse,
            hidden,
            color,
            width,
            prefix_spacing,
            suffix_spacing,
        )
    end
end

initialize(progress_table::ProgressTable) = initialize(stdout, progress_table)
next(progress_table::ProgressTable, row::AbstractVector; kwargs...) = next(stdout, progress_table, row; kwargs...)
separator(progress_table::ProgressTable) = separator(stdout, progress_table)
Base.finalize(progress_table::ProgressTable) = finalize(stdout, progress_table)

function initialize(io::IO, progress_table::ProgressTable)
    size = length(progress_table.widths)

    if progress_table.border
        print(io, "┌")
        for (i, width) in enumerate(progress_table.widths)
            print(io, "─"^width)
            if i != size
                print(io, "┬")
            end
        end
        println(io, "┐")
        print(io, "│")
    end

    for (i, column) in enumerate(progress_table.header)
        width = progress_table.widths[i]
        alignment = progress_table.header_alignment[i]

        if alignment == :left
            print(io, " ")
        elseif alignment == :right
            print(io, " "^(width - length(column) - 1))
        else
            print(io, " "^progress_table.prefix_spacing[i])
        end

        printstyled(
            io,
            column,
            bold = progress_table.header_bold[i],
            # italic = progress_table.header_italic[i],
            underline = progress_table.header_underline[i],
            blink = progress_table.header_blink[i],
            reverse = progress_table.header_reverse[i],
            hidden = progress_table.header_hidden[i],
            color = progress_table.header_color[i],
        )

        if alignment == :left
            print(io, " "^(width - length(column) - 1))
        elseif alignment == :right
            print(io, " ")
        else
            print(io, " "^progress_table.suffix_spacing[i])
        end

        if i != size
            print(io, "│")
        end
    end

    if progress_table.border
        println(io, "│")
    else
        println(io)
    end

    separator(io, progress_table)

    return nothing
end

function next(
    io::IO,
    progress_table::ProgressTable,
    row::AbstractVector;
    alignment::Vector{Symbol} = progress_table.alignment,
    bold::Vector{Bool} = progress_table.bold,
    # italic::Vector{Bool} = progress_table.italic,
    underline::Vector{Bool} = progress_table.underline,
    blink::Vector{Bool} = progress_table.blink,
    reverse::Vector{Bool} = progress_table.reverse,
    hidden::Vector{Bool} = progress_table.hidden,
    color::Vector{Symbol} = progress_table.color,
)
    size = length(progress_table.widths)

    @assert length(row) == size

    if progress_table.border
        print(io, "│")
    end

    for (i, value) in enumerate(row)
        format = progress_table.format[i]
        string = Printf.format(format, value)

        width = progress_table.widths[i]

        if alignment[i] == :left
            print(io, " ")
        elseif alignment[i] == :right
            print(io, " "^(width - length(string) - 1))
        else
            remaining = width - length(string)
            suffix_spacing = floor(Int, remaining / 2)
            prefix_spacing = width - length(string) - suffix_spacing
            print(io, " "^prefix_spacing)
        end

        printstyled(
            io,
            string,
            bold = bold[i],
            # italic = italic[i],
            underline = underline[i],
            blink = blink[i],
            reverse = reverse[i],
            hidden = hidden[i],
            color = color[i],
        )

        if alignment[i] == :left
            print(io, " "^(width - length(string) - 1))
        elseif alignment[i] == :right
            print(io, " ")
        else
            remaining = width - length(string)
            suffix_spacing = floor(Int, remaining / 2)
            prefix_spacing = width - length(string) - suffix_spacing
            print(io, " "^suffix_spacing)
        end

        if i != size
            print(io, "│")
        end
    end

    if progress_table.border
        println(io, "│")
    else
        println(io)
    end

    return nothing
end

function separator(io::IO, progress_table::ProgressTable)
    size = length(progress_table.widths)

    if progress_table.border
        print(io, "├")
    end

    for (i, width) in enumerate(progress_table.widths)
        print(io, "─"^width)
        if i != size
            print(io, "┼")
        end
    end

    if progress_table.border
        println(io, "┤")
    else
        println(io)
    end

    return nothing
end

function Base.finalize(io::IO, progress_table::ProgressTable)
    size = length(progress_table.widths)

    if progress_table.border
        print(io, "└")

        for (i, width) in enumerate(progress_table.widths)
            print(io, "─"^width)

            if i != size
                print(io, "┴")
            end
        end

        println(io, "┘")
    end

    return nothing
end
