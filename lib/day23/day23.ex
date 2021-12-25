defmodule Day23 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day23.Sprite, as: Sprite
  alias Day23.Tile,   as: Tile


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 23")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    12240   # solved on paper! :P
  end

  def puzzle2 do
    -2
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day23/input-test.txt")
  end

end
