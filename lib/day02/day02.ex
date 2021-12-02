defmodule Day02 do

  # --------------------------------------------------------
  # Public Methods
  # --------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 2")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    coords = %{ x: 0, y: 0 }
    coords = Enum.reduce(data(), coords, &reducer/2)
    coords.x * coords.y
  end

  def puzzle2 do
    coords = %{ x: 0, y: 0, a: 0 }
    coords = Enum.reduce(data(), coords, &reducer/2)
    coords.x * coords.y
  end


  # --------------------------------------------------------
  # Private Methods
  # --------------------------------------------------------

  defp move(:down, distance, coords) when map_size(coords) == 3 do
    %{ coords | a: coords.a + distance }
  end

  defp move(:up, distance, coords) when map_size(coords) == 3 do
    %{ coords | a: coords.a - distance }
  end

  defp move(:forward, distance, coords) when map_size(coords) == 3 do
    %{ coords | x: coords.x + distance, y: coords.y + (coords.a * distance) }
  end

  defp move(:down, distance, coords) do
    %{ coords | y: coords.y + distance }
  end

  defp move(:up, distance, coords) do
    %{ coords | y: coords.y - distance }
  end

  defp move(:forward, distance, coords) do
    %{ coords | x: coords.x + distance }
  end

  defp reducer(line, coords) do
    { dir, dist }  = parse(line)
    move(dir, dist, coords)
  end


  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day02/input.txt")
  end

  defp parse(line) do
    { dir, dist } =
      Regex.run(~r/^(\w+) (\w+)$/, line)
      |> Enum.drop(1)
      |> List.to_tuple()

    { String.to_atom(dir), String.to_integer(dist) }
  end

end
