defmodule Day11 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day11.Cave,    as: Cave
  alias Day11.Octopus, as: Octopus


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 11")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Cave.count_flashes(100)
  end

  def puzzle2 do
    data()
    |> Cave.count_cycles_until_sync()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    octopuses =
      Reader.to_lines("./data/day11/input.txt")
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({ line, y }, map) ->
        line_map = parse_line(line, y)

        Map.merge(map, line_map)
      end)

    %Cave{ octopuses: octopuses }
  end

  defp parse_line(line, y) do
    line
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn ({ v, x }, acc) ->
      o = %Octopus{ coord: { x, y }, energy: v }

      Map.put_new(acc, o.coord, o)
    end)
  end

end
