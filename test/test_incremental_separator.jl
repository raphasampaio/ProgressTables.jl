module TestIncrementalSeparator

using ProgressTables
using Test

@testset "Incremental Separator" begin
    string = "Hello, World!"
    for max_steps in [10, 15, 20]
        io = IOBuffer()

        separator = IncrementalSeparator(string, max_steps)
        for _ in 1:max_steps
            next(io, separator)
        end
        finalize(io, separator)

        output = String(take!(io))
        @test output == "Hello, World!\n"
    end
end

end
