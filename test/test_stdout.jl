module TestStdout

using ProgressTables
using Test

@testset "Stdout" begin
    pt = IncrementalProgressTable(header=["Test"], widths=[5])
    sep = IncrementalSeparator(width=10)
    
    @test initialize(pt) === nothing
    @test next(pt, ["A"]) === nothing  
    @test separator(pt) === nothing
    @test finalize(pt) === nothing
    @test next(sep) === nothing
    @test finalize(sep) === nothing
end

end
