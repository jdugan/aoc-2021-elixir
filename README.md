# 2021 Advent of Code (Elixir)

This repository implements solutions to the puzzles in the
[2021 Advent of Code](https://adventofcode.com/2021) using Elixir.


## Preface

This was a vehicle to learn Elixir, so I presume not everything done here will
be deemed idiomatic by language specialists.

Generally speaking, the solutions are organised predominantly for comprehension.
They strive to arrive at an answer in a reasonable period of time, but they
typically prioritise optimal understanding over optimal performance.

The examples are representative of my thinking and coding style.


## Getting Started

### Prerequisites

The project requires `elixir 1.17.1-otp-27`, but any reasonably current version of
Elixir will likely work.  I tend to code done the middle of any language
specification.

If you use an Elixir manager that responds to `.tool-versions`, you should
be switched to correct version automatically. I recommend [ASDF](https://github.com/asdf-vm/asdf)
for those on platforms that support it.

### Installation

The project does not have any external dependencies, so you only need to compile
the source files to run them.

```
$ mix compile
```

### File Structure

- [data](./data):   Puzzle input organised by day
- [lib](./lib):     Daily solutions and other homegrown utilities
- [site](./site):   A local version of the instruction pages
- [test](./test):   A simple set of regression tests


### Running Daily Solutions

The module can be loaded into an interactive console using
the standard command. Daily solutions can be run from the
iex session using the following methods.

```
$ iex -S mix
> Day01.puzzle1()
> Day01.puzzle2()
> Day01.both()
```

To quit the interactive console, press `Ctl + C` and then type
`a` for abort.


### Running Tests

The only tests are a set of checks to verify solved puzzles.

I often refactor my solutions for clarity (or as I learn new
techniques in subsequent puzzles), so it is helpful to have
these simple tests to give my refactors some confidence.

To execute the tests, simply execute the following command in
your terminal from the project root.

```
$ mix test
```