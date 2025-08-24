# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Testing
- Windows: `test\test.bat` - Run all tests using Julia 1.11
- Unix/Linux: `test/test.sh` - Run all tests using Julia 1.11
- Run specific test: `test\test.bat <test_name>` (Windows only)

### Code Formatting
- Windows: `format\format.bat` - Format code using JuliaFormatter
- The formatter will exit with code 1 if files need formatting

### Development Environment
- Windows: `revise\revise.bat` - Start interactive Julia session with Revise.jl
- Loads ProgressTables.jl with automatic code reloading for development

## Architecture

ProgressTables.jl is a Julia package for displaying progress and tracking values in visually appealing tables. The main components are:

### Core Types
- `AbstractProgressTable` and `AbstractSeparator`: Base abstract types in `src/abstract.jl`
- `IncrementalProgressTable`: Main table implementation in `src/incremental_table.jl`
- `IncrementalSeparator`: Separator functionality in `src/incremental_separator.jl`
- `Style`: Styling configuration in `src/style.jl`

### Key Functions
- `initialize(table)`: Start a new progress table display
- `next(table, row)`: Add a new row to the table
- `separator(table)`: Insert a separator line
- `finalize(table)`: Complete the table display

### Design Patterns
- The package uses Printf.Format for flexible data formatting
- Tables support customizable headers, widths, colors, alignment, and borders
- Styling is handled through a Style struct with separate header and body configurations
- Output is managed through IO streams, defaulting to stdout via `src/stdout.jl`

### Dependencies
- Uses only Printf from the Julia standard library
- Test dependencies: Aqua.jl and Test
- Development dependencies: JuliaFormatter.jl and Revise.jl

The package is designed for Julia 1.9+ and follows standard Julia package conventions with Project.toml configuration.