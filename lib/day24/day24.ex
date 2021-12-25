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
    unless Mix.env() == :test do
      data()
      |> Computer.debug([1,1,1,1,1,1,1,1,1,1,1,1,1,1])
      |> Computer.print()
    end
    -1
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
