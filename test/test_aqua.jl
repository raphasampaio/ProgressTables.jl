module TestAqua

using Aqua
using ProgressTables
using Test

@testset "Aqua" begin
    Aqua.test_ambiguities(ProgressTables, recursive = false)
    Aqua.test_all(ProgressTables, ambiguities = false)
    return nothing
end

end
