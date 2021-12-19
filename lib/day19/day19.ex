defmodule Day19 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day19.Dataset, as: Dataset
  alias Day19.Scanner, as: Scanner


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 19")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Scanner.count_beacons()
  end

  def puzzle2 do
    data()
    |> Scanner.largest_spread()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    [ line | lines ] = Reader.to_lines("./data/day19/input.txt")

    scanner = %Scanner{ id: parse_id(line), position: { 0, 0, 0 } }
    initial = { [], scanner, [] }

    { scanners, scanner, dataset } =
      lines
      |> Enum.reduce(initial, fn (line, { r_scanners, r_scanner, r_dataset }) ->
        if parsable_id?(line) do
          datasets =
            if Scanner.origin?(r_scanner),
              do:   [Enum.sort(r_dataset)],
              else: Dataset.generate_rotations(r_dataset)

          scanners = [ %{ r_scanner | datasets: datasets } | r_scanners ]
          scanner  = %Scanner{ id: parse_id(line) }

          { scanners, scanner, [] }
        else
          { r_scanners, r_scanner, [ parse_point(line) | r_dataset ] }
        end
      end)

    datasets = Dataset.generate_rotations(dataset)
    scanners = [ %{ scanner | datasets: datasets } | scanners ]

    Enum.reverse(scanners)
  end

  defp parse_id(line) do
    Regex.run(~r/^--- scanner (\d+) ---$/, line)
    |> Enum.at(1)
    |> String.to_integer()
  end

  defp parsable_id?(line) do
    Regex.match?(~r/^--- scanner/, line)
  end

  defp parse_point(line) do
    Regex.run(~r/^(-?\d+),(-?\d+),(-?\d+)$/, line)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

end
