module TestIssues

using ProgressTables
using Test

@testset "Issue 6" begin
    io = IOBuffer()

    pt = IncrementalProgressTable(
        header = ["iter"],
    )
    initialize(io, pt)
    @test_throws ArgumentError next(io, pt, [1.234567890])
    finalize(io, pt)
end

end
