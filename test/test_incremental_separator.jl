module TestIncrementalSeparator

using ProgressTables
using Test

@testset "Incremental Separator" begin
    @testset "string > max_steps" begin
        io = IOBuffer()

        max_steps = 5
        separator = IncrementalSeparator("Hello, World!", max_steps)
        for _ in 1:max_steps
            next(io, separator)
        end
        finalize(io, separator)

        @show output = String(take!(io))
        print(output)

        @test output == "Hello, World!"
    end

    @testset "string < max_steps" begin
        io = IOBuffer()

        max_steps = 5
        separator = IncrementalSeparator("Hello, World!", 20)
        for _ in 1:5
            next(io, separator)
        end
        finalize(io, separator)
    end
end

end
