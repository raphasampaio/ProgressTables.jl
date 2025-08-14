module TestIncrementalSeparator

using ProgressTables
using Test

@testset "Incremental Separator" begin
    io = IOBuffer()

    separator = IncrementalSeparator("Hello, World!", 5)

    for _ in 1:5
        next!(io, separator)
    end
    finalize!(io, separator)

    @show output = String(take!(io))
    print(output)

    @test output == "Hello, World!"
end

end