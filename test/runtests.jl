using ProgressTables

using Aqua
using Test

include("aqua.jl")
include("issues.jl")

function test_incremental_progress_table()
    for border in [true, false]
        io = IOBuffer()

        pt = IncrementalProgressTable(
            header = ["Epoch", "Loss", "Accuracy"],
            widths = [10, 8, 16],
            format = ["%d", "%.2f", "%.3e"],
            color = [:normal, :normal, :blue],
            border = border,
            header_alignment = [:right, :center, :left],
            alignment = [:right, :center, :left],
        )

        epochs = 4

        initialize(io, pt)
        for epoch in 1:epochs
            next(io, pt, [epoch, 1 / epoch, epoch * 0.1])

            if epoch == 2
                separator(io, pt)
            end
        end
        finalize(io, pt)

        @show output = String(take!(io))
        print(output)

        if border
            @test output ==
                  "┌──────────┬────────┬────────────────┐\n│    Epoch │  Loss  │ Accuracy       │\n├──────────┼────────┼────────────────┤\n│        1 │  1.00  │ 1.000e-01      │\n│        2 │  0.50  │ 2.000e-01      │\n├──────────┼────────┼────────────────┤\n│        3 │  0.33  │ 3.000e-01      │\n│        4 │  0.25  │ 4.000e-01      │\n└──────────┴────────┴────────────────┘\n"
        else
            @test output ==
                  "    Epoch │  Loss  │ Accuracy       \n──────────┼────────┼────────────────\n        1 │  1.00  │ 1.000e-01      \n        2 │  0.50  │ 2.000e-01      \n──────────┼────────┼────────────────\n        3 │  0.33  │ 3.000e-01      \n        4 │  0.25  │ 4.000e-01      \n"
        end
    end

    return nothing
end

function test_incremental_separator()
    io = IOBuffer()

    separator = IncrementalSeparator("Hello, World!", 5)

    for _ in 1:5
        next!(io, separator)
    end
    finalize!(io, separator)

    @show output = String(take!(io))
    print(output)

    @test output == "Hello, World!"

    return nothing
end

function test_issues()
    test_issue6()

    return nothing
end

function test_all()
    @testset "Aqua.jl" begin
        test_aqua()
    end

    @testset "ProgressTables.jl" begin
        test_incremental_progress_table()
    end

    @testset "IncrementalSeparator" begin
        test_incremental_separator()
    end

    @testset "Issues" begin
        test_issues()
    end

    return nothing
end

test_all()
