using ProgressTables

using Aqua
using Test

# include("aqua.jl")

function test_all()
    # @testset "Aqua.jl" begin
    #     test_aqua()
    # end

    @show pt = ProgressTable(
        header = ["Epoch", "Loss", "Accuracy"],
        widths = [10, 8, 16],
        format = ["%d", "%.2f", "%.3e"],
        color = [:normal, :normal, :green],
        border = false,
    )

    initialize!(pt)

    for epoch in 1:10
        next!(pt, [epoch, 0.1, 0.9])
    end

    finalize!(pt)

    return nothing
end

test_all()
