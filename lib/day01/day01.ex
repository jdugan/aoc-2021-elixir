defmodule Day01 do
  @moduledoc """
  This day's puzzle had a fun little trick. In part two, the
  windows being compared mostly contain the same values—the
  last two values of Window A are the same as the first two
  values of Window B.

  So, to compare the sums of the windows, we really only need
  to compare the values which are distinct—i.e., the first value
  of Window A and the last value of Window B.

  This means part 1 and part 2 use the same solution
  pattern. The only difference is how far apart the numbers
  being compared are in the list.  In part 1, the numbers
  are 1 position apart (i.e., adjacent); in part 2, they
  are 3 positions apart.
  """

  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 1")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    countIncreasesByWindowSize(1)
  end

  def puzzle2 do
    countIncreasesByWindowSize(3)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  defp countIncreasesByWindowSize(window) do
    countIncreases(data(), 0, window, 0)
  end

  defp countIncreases(list, _, i1, count) when i1 == length(list) do
    count
  end

  defp countIncreases(list, i0, i1, count) do
    if Enum.at(list, i1) > Enum.at(list, i0) do
      countIncreases(list, i0 + 1, i1 + 1, count + 1)
    else
      countIncreases(list, i0 + 1, i1 + 1, count)
    end
  end


  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day01/input.txt")
    |> Enum.map(&String.to_integer/1)
  end

end
