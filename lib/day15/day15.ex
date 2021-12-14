defmodule Day15 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day15.Graph, as: Graph
  alias Day15.Point, as: Point


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 15")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    ts0 = DateTime.utc_now()
    answer =
      data()
      |> Graph.shortest_distance()
    ts1 = DateTime.utc_now()

    if Mix.env() == :test do
      answer
    else
      "#{ answer },  Clock: #{ DateTime.diff(ts1, ts0, :millisecond)/1000.0 }s"
    end
  end

  def puzzle2 do
    ts0 = DateTime.utc_now()
    answer =
      data()
      |> Graph.expand()
      |> Graph.shortest_distance()
    ts1 = DateTime.utc_now()

    if Mix.env() == :test do
      answer
    else
      "#{ answer }, Clock: #{ DateTime.diff(ts1, ts0, :millisecond)/1000.0 }s"
    end
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    points =
      Reader.to_lines("./data/day15/input.txt")
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({ line, y }, map) ->
        line_map = parse_line(line, y)

        Map.merge(map, line_map)
      end)

    %Graph{
      points:       points,
      max_distance: map_size(points) * 10
    }
  end

  defp parse_line(line, y) do
    line
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn ({ v, x }, acc) ->
      p = %Point{ id: { x, y }, value: v }

      Map.put_new(acc, p.id, p)
    end)
  end

end
