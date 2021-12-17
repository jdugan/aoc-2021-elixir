defmodule Day16 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day16.Packet, as: Packet


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 16")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Conversion.hex_string_to_binary_string()
    |> Packet.decode()
    |> Packet.sum_versions()
  end

  def puzzle2 do
    data()
    |> Conversion.hex_string_to_binary_string()
    |> Packet.decode()
    |> Packet.evaluate()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day16/input.txt")
    |> Enum.at(0)
  end

end
