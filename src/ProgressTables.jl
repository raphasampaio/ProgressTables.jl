module ProgressTables

using Printf

export ProgressTable,
    initialize!,
    next!,
    finalize!

abstract type AbstractProgressTable end

struct ProgressTable <: AbstractProgressTable
    header::Vector{String}
    widths::Vector{Int}
    format::Vector{Printf.Format}
    border::Bool

    header_bold::Vector{Bool}
    header_italic::Vector{Bool}
    header_underline::Vector{Bool}
    header_blink::Vector{Bool}
    header_reverse::Vector{Bool}
    header_hidden::Vector{Bool}
    header_color::Vector{Symbol}

    bold::Vector{Bool}
    italic::Vector{Bool}
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
        header_bold::Vector{Bool} = [true for _ in header],
        header_italic::Vector{Bool} = [false for _ in header],
        header_underline::Vector{Bool} = [false for _ in header],
        header_blink::Vector{Bool} = [false for _ in header],
        header_reverse::Vector{Bool} = [false for _ in header],
        header_hidden::Vector{Bool} = [false for _ in header],
        header_color::Vector{Symbol} = [:normal for _ in header],
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
            push!(suffix_spacing, remaining ÷ 2)
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
            header_bold,
            header_italic,
            header_underline,
            header_blink,
            header_reverse,
            header_hidden,
            header_color,
            bold,
            italic,
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

function initialize!(progress_table::ProgressTable)
    size = length(progress_table.widths)

    if progress_table.border
        print("┌")
    end

    for (i, width) in enumerate(progress_table.widths)
        print("─"^width)

        if i != size
            print("┬")
        end
    end

    if progress_table.border
        println("┐")
        print("│")
    end

    for (i, column) in enumerate(progress_table.header)
        print(" "^progress_table.prefix_spacing[i])
        printstyled(
            column,
            bold = progress_table.header_bold[i],
            italic = progress_table.header_italic[i],
            underline = progress_table.header_underline[i],
            blink = progress_table.header_blink[i],
            reverse = progress_table.header_reverse[i],
            hidden = progress_table.header_hidden[i],
            color = progress_table.header_color[i],
        )
        print(" "^progress_table.suffix_spacing[i])

        if i != size
            print("│")
        end
    end

    if progress_table.border
        println("│")
        print("├")
    end

    for (i, width) in enumerate(progress_table.widths)
        print("─"^width)

        if i != size
            print("┼")
        end
    end

    if progress_table.border
        println("┤")
    end

    return nothing
end

function next!(progress_table::ProgressTable, row::Vector)
    size = length(progress_table.widths)

    @assert length(row) == size

    if progress_table.border
    print("│")
    end

    for (i, value) in enumerate(row)
        format = progress_table.format[i]
        string = Printf.format(format, value)
        suffix_spacing = (progress_table.widths[i] - length(string)) ÷ 2
        prefix_spacing = progress_table.widths[i] - length(string) - suffix_spacing

        print(" "^prefix_spacing)
        printstyled(
            string, 
            bold = progress_table.bold[i],
            italic = progress_table.italic[i],
            underline = progress_table.underline[i],
            blink = progress_table.blink[i],
            reverse = progress_table.reverse[i],
            hidden = progress_table.hidden[i],
            color = progress_table.color[i],
        )
        print(" "^suffix_spacing)

        if i != size
        print("│")
        end
    end

    if progress_table.border
    println("│")
    end

    return nothing
end

function finalize!(progress_table::ProgressTable)
    size = length(progress_table.widths)

    if progress_table.border
    print("└")
    end
    for (i, width) in enumerate(progress_table.widths)
        print("─"^width)

        if i != size
            print("┴")
        end
    end

    if progress_table.border
    println("┘")
    end

    return nothing
end

end
