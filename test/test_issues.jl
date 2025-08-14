module TestIssues

using ProgressTables
using Test

@testset "Issue 6" begin
    pt = IncrementalProgressTable(
        header = ["iter"],
    )
    initialize(pt)
    @test_throws ArgumentError next(pt, [1.234567890])
    finalize(pt)
end

end
