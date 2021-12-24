defmodule Day24 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day24.Computer,    as: Computer
  alias Day24.Instruction, as: Instruction


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 24")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Computer.largest_model_number()
  end

  def puzzle2 do
    -2
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    program =
      Reader.to_lines("./data/day24/input.txt")
      |> Enum.map(&Instruction.parse/1)

    %Computer{ program: program }
  end

end
