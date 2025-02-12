function test_issue4()
    pt = IncrementalProgressTable(
        header = ["iter", "lower bound", "upper bound", "gap", "fwd (s)", "bck (s)", "time (s)"],
    )
    initialize(pt)
    next(pt, [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0])
    finalize(pt)

    return nothing
end