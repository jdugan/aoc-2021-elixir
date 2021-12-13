defmodule Day13 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day13.Paper, as: Paper


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 13")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Paper.fold_once
    |> Paper.count_dots
  end

  def puzzle2 do
    unless Mix.env() == :test do
      data()
      |> Paper.fold_all
      |> Paper.print
    end
    "HZLEHJRK"
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    lines = Reader.to_lines("./data/day13/input.txt")

    { dots, folds } =
      lines
      |> Enum.reduce({ %{}, [] }, fn (line, { d_map, f_arr }) ->
        if String.starts_with?(line, "fold") do
          f = parse_fold(line)
          { d_map, [ f | f_arr ] }
        else
          k = parse_dot(line)
          { Map.put(d_map, k, "#"), f_arr }
        end
      end)

    %Paper{ dots: dots, folds: Enum.reverse(folds) }
  end

  defp parse_dot(line) do
    String.split(line, ",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

  defp parse_fold(line) do
    { dir, coord } =
      Regex.run(~r/^fold along ([xy])=(\d+)$/, line)
      |> Enum.drop(1)
      |> List.to_tuple()

    { String.to_atom(dir), String.to_integer(coord) }
  end

end
