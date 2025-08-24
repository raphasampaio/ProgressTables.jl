module TestIncrementalTableAndSeparator

using ProgressTables
using Test

@testset "Incremental Table And Separator" begin
    pt = IncrementalProgressTable(
        header = ["Epoch", "Loss", "Accuracy"],
        widths = [10, 8, 16],
        format = ["%d", "%.2f", "%.3e"],
        color = [:normal, :normal, :blue],
        border = true,
        header_alignment = [:right, :center, :left],
        alignment = [:right, :center, :left],
    )

    epochs = 4

    initialize(pt)
    for epoch in 1:epochs
        next(pt, [epoch, 1 / epoch, epoch * 0.1])

        if epoch == 2
            max_steps = 5
            # sp = IncrementalSeparator(pt, max_steps)
            sp = IncrementalSeparator("└──────────┴────────┴────────────────┘", max_steps)
            for _ in 1:max_steps
                next(sp)
                sleep(1)
            end
            finalize(sp)
        end
    end
    finalize(pt)

    return nothing
end

end
