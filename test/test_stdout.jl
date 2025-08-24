module TestStdout

using ProgressTables
using Test

@testset "Stdout" begin
    pt = IncrementalProgressTable(header = ["Test"], format = ["%d"])
    sp = IncrementalSeparator(pt, 10)

    @test initialize(pt) === nothing
    @test next(pt, [1]) === nothing
    @test separator(pt) === nothing
    @test finalize(pt) === nothing
    @test next(sp) === nothing
    @test finalize(sp) === nothing
end

end
