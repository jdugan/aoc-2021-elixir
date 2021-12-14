defmodule Day14 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day14.Machine, as: Machine


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 14")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Machine.process_cycles(10)
    |> Machine.frequency_range()
  end

  def puzzle2 do
    data()
    |> Machine.process_cycles(40)
    |> Machine.frequency_range()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    lines = Reader.to_lines("./data/day14/input.txt")

    graphemes =
      lines
      |> Enum.at(0)
      |> String.graphemes

    char_map =
      graphemes
      |> Enum.reduce(%{}, fn (g, acc) ->
        count = Map.get(acc, g, 0)
        Map.put(acc, g, count + 1)
      end)
    chunk_map =
      graphemes
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({ g, i }, acc) ->
        if i + 1 < length(graphemes) do
          chunk = "#{ g }#{ Enum.at(graphemes, i + 1) }"
          count = Map.get(acc, chunk, 0)
          Map.put(acc, chunk, count + 1)
        else
          acc
        end
      end)
    rules =
      lines
      |> Enum.drop(1)
      |> Enum.map(fn s -> String.split(s, " -> ") end)
      |> Enum.map(&List.to_tuple/1)
      |> Enum.into(%{})

    %Machine{ char_map: char_map, chunk_map: chunk_map, rules: rules }
  end

end
