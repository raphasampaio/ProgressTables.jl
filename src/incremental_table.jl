struct IncrementalProgressTable <: AbstractProgressTable
    header::Vector{String}
    widths::Vector{Int}
    format::Vector{Printf.Format}
    border::Bool
    style::@NamedTuple{header::Style, body::Style}
    width::Int
    prefix_spacing::Vector{Int}
    suffix_spacing::Vector{Int}
    separator::String

    function IncrementalProgressTable(;
        header::Vector{String},
        widths::Vector{Int} = [length(column) + 2 for column in header],
        format::Vector{String} = ["%f" for _ in header],
        border::Bool = true,
        header_alignment::Vector{Symbol} = [:center for _ in header],
        header_bold::Vector{Bool} = [true for _ in header],
        header_italic::Vector{Bool} = [false for _ in header],
        header_underline::Vector{Bool} = [false for _ in header],
        header_blink::Vector{Bool} = [false for _ in header],
        header_reverse::Vector{Bool} = [false for _ in header],
        header_hidden::Vector{Bool} = [false for _ in header],
        header_color::Vector{Symbol} = [:normal for _ in header],
        alignment::Vector{Symbol} = [:center for _ in header],
        bold::Vector{Bool} = [false for _ in header],
        italic::Vector{Bool} = [false for _ in header],
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

        style = (
            header = Style(
                alignment = header_alignment,
                bold = header_bold,
                italic = header_italic,
                underline = header_underline,
                blink = header_blink,
                reverse = header_reverse,
                hidden = header_hidden,
                color = header_color,
            ),
            body = Style(
                alignment = alignment,
                bold = bold,
                italic = italic,
                underline = underline,
                blink = blink,
                reverse = reverse,
                hidden = hidden,
                color = color,
            ),
        )

        separator_io = IOBuffer()
        if border
            print(separator_io, "├")
        end
        for (i, width) in enumerate(widths)
            print(separator_io, "─"^width)
            if i != size
                print(separator_io, "┼")
            end
        end
        if border
            println(separator_io, "┤")
        else
            println(separator_io)
        end

        return new(
            header,
            widths,
            [Printf.Format(fmt) for fmt in format],
            border,
            style,
            width,
            prefix_spacing,
            suffix_spacing,
            String(take!(separator_io)),
        )
    end
end

function initialize(io::IO, progress_table::IncrementalProgressTable)
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
        alignment = progress_table.style.header.alignment[i]

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
            bold = progress_table.style.header.bold[i],
            # italic = progress_table.style.header.italic[i],
            underline = progress_table.style.header.underline[i],
            blink = progress_table.style.header.blink[i],
            reverse = progress_table.style.header.reverse[i],
            hidden = progress_table.style.header.hidden[i],
            color = progress_table.style.header.color[i],
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
    progress_table::IncrementalProgressTable,
    row::AbstractVector;
    alignment::Vector{Symbol} = progress_table.style.body.alignment,
    bold::Vector{Bool} = progress_table.style.body.bold,
    italic::Vector{Bool} = progress_table.style.body.italic,
    underline::Vector{Bool} = progress_table.style.body.underline,
    blink::Vector{Bool} = progress_table.style.body.blink,
    reverse::Vector{Bool} = progress_table.style.body.reverse,
    hidden::Vector{Bool} = progress_table.style.body.hidden,
    color::Vector{Symbol} = progress_table.style.body.color,
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
            if prefix_spacing < 0
                throw(ArgumentError("Increase width of column $i to fit content"))
            end
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

function separator(io::IO, progress_table::IncrementalProgressTable)
    print(io, progress_table.separator)
    return nothing
end

function Base.finalize(io::IO, progress_table::IncrementalProgressTable)
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
