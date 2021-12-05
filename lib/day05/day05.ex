defmodule Day05 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day05.Segment, as: Segment


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 5")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Enum.filter(&Segment.perpendicular?/1)
    |> countOverlappingPoints
  end

  def puzzle2 do
    data()
    |> countOverlappingPoints
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day05/input.txt")
    |> Enum.map(&parseLineIntoSegment/1)
  end

  defp parseLineIntoSegment(line) do
    { x0, y0, x1, y1 } =
      Regex.run(~r/^(\d+),(\d+) -> (\d+),(\d+)$/, line)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    %Segment{ x0: x0, y0: y0, x1: x1, y1: y1 }
  end


  # ========== GRID HELPERS ===============================

  defp countOverlappingPoints(segments) do
    points =
      Enum.map(segments, &Segment.points/1)
      |> List.flatten

    count_map =
      Enum.reduce(points, %{}, fn (p, acc) ->
        count = Map.get(acc, p) || 0
        count = count + 1
        Map.put(acc, p, count)
      end)

    Enum.filter(count_map, fn {_, v} -> v > 1 end)
    |> length
  end

end
