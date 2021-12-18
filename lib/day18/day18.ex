defmodule Day18 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day18.Expression, as: Expression


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 18")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Expression.sum()
    |> Expression.magnitude()
  end

  def puzzle2 do
    data()
    |> permutations([])
    |> Enum.map(fn sublist ->
      sublist
      |> Expression.sum()
      |> Expression.magnitude()
    end)
    |> Enum.max()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day18/input.txt")
    |> Enum.map(fn line ->
      Expression.parse(line)
    end)
  end

  defp permutations(lines, list) when length(lines) == 0 do
    list
  end

  defp permutations(lines, list) do
    [ head | tail ] = lines

    local_list =
      tail
      |> Enum.reduce([], fn (exp, acc) ->
        [ [head, exp] | acc ]
      end)
      |> Enum.concat(list)

    permutations(tail, local_list)
  end

end
