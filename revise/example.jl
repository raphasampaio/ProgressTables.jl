using ProgressTables

# separator = IncrementalSeparator("Hello, World!", 10)
# for _ in 1:10
#     next(separator)
#     sleep(1)
# end
# finalize(separator)

pt = IncrementalProgressTable(
    header = ["Epoch", "Loss", "Accuracy"],
    widths = [10, 8, 16],
    format = ["%d", "%.2f", "%.3e"],
    color = [:normal, :normal, :blue],
    border = true,
    header_alignment = [:right, :center, :left],
    alignment = [:right, :center, :left],
)

sp = IncrementalSeparator(pt)

epochs = 4

initialize(pt)
for epoch in 1:epochs
    next(pt, [epoch, 1 / epoch, epoch * 0.1])

    if epoch == 2
        for _ in 1:10
            next(sp)
            sleep(1)
        end
        finalize(sp)
    end
end
finalize(pt)
