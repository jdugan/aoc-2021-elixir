defmodule Day21 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day21.Game, as: Game
  alias Day21.Pawn, as: Pawn


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 21")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Game.play(:deterministic)
  end

  def puzzle2 do
    data()
    |> Game.play(:quantum)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    pawns =
      Reader.to_lines("./data/day21/input.txt")
      |> Enum.map(fn line ->
        { id, position } = parse_line(line)
        %Pawn{ id: id, position: position }
      end)
      |> Enum.reduce(%{}, fn (p, acc) ->
        Map.put(acc, p.id, p)
      end)

    %Game{ pawns: pawns }
  end

  defp parse_line(line) do
    Regex.run(~r/^Player (\d+) starting position: (\d+)$/, line)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

end
