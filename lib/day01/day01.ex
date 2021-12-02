defmodule Day01 do

  #========== PUBLIC FNS ==================================

  def both do
    IO.puts(" ")
    IO.puts("DAY 1")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    countIncreasesByWindow(1)
  end

  def puzzle2 do
    countIncreasesByWindow(3)
  end


  #========== PRIVATE FNS =================================

  defp data do
    Reader.to_lines("./data/day01/input.txt") |>
      Enum.map(&String.to_integer/1)
  end

  defp countIncreasesByWindow (window) do
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

end
