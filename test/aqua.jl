function test_aqua()
    @testset "Ambiguities" begin
        Aqua.test_ambiguities(ProgressTables, recursive = false)
    end
    Aqua.test_all(ProgressTables, ambiguities = false)

    return nothing
end