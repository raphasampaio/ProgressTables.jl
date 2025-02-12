function test_issue6()
    pt = IncrementalProgressTable(
        header = ["iter"],
    )
    initialize(pt)
    @test_throws ArgumentError next(pt, [1.234567890])
    finalize(pt)

    return nothing
end