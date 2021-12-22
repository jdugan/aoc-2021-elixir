defmodule Day22 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day22.Instruction, as: Instruction
  alias Day22.Reactor,     as: Reactor


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 22")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Reactor.initialise()
    |> Reactor.count_cubes()
  end

  def puzzle2 do
    data()
    |> Reactor.boot()
    |> Reactor.count_cubes()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    instructions =
      Reader.to_lines("./data/day22/input.txt")
      |> Enum.map(fn line ->
        { state, x_min, x_max, y_min, y_max, z_min, z_max } =
          parse_line(line)

        %Instruction{
          state: state,
          x_min: x_min, x_max: x_max,
          y_min: y_min, y_max: y_max,
          z_min: z_min, z_max: z_max
        }
      end)

    %Reactor{ instructions: instructions }
  end

  defp parse_line(line) do
    [ state | limits ] =
      Regex.run(~r/^(\w{2,3}) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/, line)
      |> Enum.drop(1)

    [ state | Enum.map(limits, &String.to_integer/1) ]
    |> List.to_tuple()
  end

end
