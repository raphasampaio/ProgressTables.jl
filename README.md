# ProgressTables.jl

[![CI](https://github.com/raphasampaio/ProgressTables.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/raphasampaio/ProgressTables.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/raphasampaio/ProgressTables.jl/graph/badge.svg?token=7tA9ajgsLf)](https://codecov.io/gh/raphasampaio/ProgressTables.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Introduction

ProgressTables.jl is a Julia package designed to display progress and track values in the form of visually appealing tables. It is ideal for use in tasks such as training machine learning models, monitoring simulations, or simply displaying iterative computations in a clean, tabular format. The package supports customizable table headers, column widths, data formatting, colors, alignment, and borders, providing full flexibility to suit various needs.

## Getting Started

### Installation

```julia
julia> ] add ProgressTables
```

### Example

```julia
using ProgressTables

pt = ProgressTable(
    header = ["Epoch", "Loss", "Accuracy"],
    widths = [10, 8, 16],
    format = ["%d", "%.2f", "%.3e"],
    color = [:normal, :normal, :blue],
    border = true,
    alignment = [:right, :center, :center],
)

initialize!(pt)
for epoch in 1:3
    next!(pt, [epoch, 1 / epoch, epoch * 0.1])
end
finalize!(pt)
```

```console
┌──────────┬────────┬────────────────┐
│   Epoch  │  Loss  │    Accuracy    │
├──────────┼────────┼────────────────┤
│        1 │  1.00  │    1.000e-01   │
│        2 │  0.50  │    2.000e-01   │
│        3 │  0.33  │    3.000e-01   │
└──────────┴────────┴────────────────┘
```

## Contributing

Contributions, bug reports, and feature requests are welcome! Feel free to open an issue or submit a pull request.