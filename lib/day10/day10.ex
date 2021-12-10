defmodule Day10 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day10.SyntaxChecker, as: SyntaxChecker


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 10")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> SyntaxChecker.error_score()
  end

  def puzzle2 do
    data()
    |> SyntaxChecker.autocomplete_score()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day10/input.txt")
  end

end
