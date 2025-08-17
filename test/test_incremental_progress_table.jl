module TestIncrementalProgressTable

using ProgressTables
using Test

@testset "Incremental Progress Table" begin
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
end

end
