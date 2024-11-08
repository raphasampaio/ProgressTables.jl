using ProgressTables

using Aqua
using Test

include("aqua.jl")

function test_all()
    @testset "Aqua.jl" begin
        test_aqua()
    end

    for border in [false, true]
        io = IOBuffer()

        pt = ProgressTable(
            header = ["Epoch", "Loss", "Accuracy"],
            widths = [10, 8, 16],
            format = ["%d", "%.2f", "%.3e"],
            color = [:normal, :normal, :blue],
            border = border,
                alignment = [:right, :center, :left],
        )

        initialize!(io, pt)
        for epoch in 1:3
            next!(io, pt, [epoch, 1 / epoch, epoch * 0.1])
        end
        finalize!(io, pt)

        if border
            @test String(take!(io)) == "┌──────────┬────────┬────────────────┐\n│   Epoch  │  Loss  │    Accuracy    │\n├──────────┼────────┼────────────────┤\n│        1 │  1.00  │ 1.000e-01      │\n│        2 │  0.50  │ 2.000e-01      │\n│        3 │  0.33  │ 3.000e-01      │\n└──────────┴────────┴────────────────┘\n"
        else
            @test String(take!(io)) =="   Epoch  │  Loss  │    Accuracy    \n        1 │  1.00  │ 1.000e-01      \n        2 │  0.50  │ 2.000e-01      \n        3 │  0.33  │ 3.000e-01      \n"
        end
    end

    return nothing
end

test_all()
