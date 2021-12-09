defmodule Day09 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day09.Basin, as: Basin
  alias Day09.Coord, as: Coord


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 9")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    find_low_points(data())
    |> Enum.map(&Coord.risk_level/1)
    |> Enum.sum
  end

  def puzzle2 do
    find_basins(data())
    |> Enum.map(&Basin.size/1)
    |> Enum.sort
    |> Enum.take(-3)
    |> Enum.product
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== COLLECTION HELPERS =========================

  defp find_basins(sea_floor) do
    find_low_points(sea_floor)
    |> Enum.map(fn c ->
      b = %Basin{ nadir: c }
      Basin.expand(b, sea_floor)
    end)
  end

  defp find_low_points(sea_floor) do
    sea_floor
    |> Enum.reduce([], fn ({ _, coord }, list) ->
      if Coord.lowest?(sea_floor, coord) do
        [ coord | list ]
      else
        list
      end
    end)
  end


  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day09/input.txt")
    |> Enum.with_index
    |> Enum.reduce(%{}, fn ({ line, y }, map) ->
      line_map = parse_line(line, y)

      Map.merge(map, line_map)
    end)
  end

  defp parse_line(line, y) do
    line
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn ({ h, x }, acc) ->
      c = %Coord{ x: x, y: y, h: h }
      k = Coord.key(c)

      Map.put_new(acc, k, c)
    end)
  end

end
