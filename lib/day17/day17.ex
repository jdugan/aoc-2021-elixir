defmodule Day17 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day17.Launcher, as: Launcher
  alias Day17.Target,   as: Target


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 17")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Launcher.maximum_height()
  end

  def puzzle2 do
    data()
    |> Launcher.total_trajectories()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    line =
      Reader.to_lines("./data/day17/input.txt")
      |> Enum.at(0)

    { x0, x1, y0, y1 } =
      Regex.run(~r/^target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)$/, line)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    target = %Target { x_min: x0, x_max: x1, y_min: y0, y_max: y1 }

    %Launcher{ target: target }
  end

end
