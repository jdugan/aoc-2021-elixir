defmodule Day00 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  # alias Day00.Thing, as: Thing


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 0")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    length(data())
  end

  def puzzle2 do
    length(data())
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day00/input-test.txt")
  end

end
