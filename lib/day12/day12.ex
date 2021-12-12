defmodule Day12 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day12.Cave,       as: Cave
  alias Day12.CaveSystem, as: CaveSystem


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 12")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> CaveSystem.count_paths(:anxious)
  end

  def puzzle2 do
    data()
    |> CaveSystem.count_paths(:bold)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    caves =
      Reader.to_lines("./data/day12/input.txt")
      |> parse_mappings
      |> parse_caves

    %CaveSystem{ caves: caves }
    |> CaveSystem.set_terminals()
  end

  defp parse_caves(mappings) do
    mappings
    |> Enum.reduce(%{}, fn ({ n1, n2 }, acc) ->
      c1 =
        Map.get(acc, n1, %Cave{ node: n1 })
        |> Cave.add_connected_node(n2)
      c2 =
        Map.get(acc, n2, %Cave{ node: n2 })
        |> Cave.add_connected_node(n1)

      acc
      |> Map.put(n1, c1)
      |> Map.put(n2, c2)
    end)
  end

  defp parse_mappings(lines) do
    lines
    |> Enum.map(fn line ->
      String.split(line, "-")
      |> List.to_tuple
    end)
  end

end
