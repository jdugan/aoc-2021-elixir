defmodule Day07 do

  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 7")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> findMinimumFuel(:simple)
  end

  def puzzle2 do
    data()
    |> findMinimumFuel(:complex)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== FUEL HELPERS ===============================

  defp findMinimumFuel(positions, mode) do
    keys    = positions |> Map.keys() |> Enum.sort()
    min     = keys |> Enum.at(0)
    max     = keys |> Enum.at(-1)
    initial = calculateFuelCost(positions, min, mode)

    (min + 1)..max
    |> Enum.reduce(initial, fn (alignment, acc) ->
      fuel = calculateFuelCost(positions, alignment, mode)
      if fuel < acc, do: fuel, else: acc
    end)
  end

  defp calculateFuelCost(positions, alignment, :complex) do
    Enum.reduce(positions, 0, fn ({ p, count }, acc) ->
      n     = abs(p - alignment)
      steps = (n * (n + 1)) / 2 |> trunc
      fuel  = steps * count
      acc + fuel
    end)
  end

  defp calculateFuelCost(positions, alignment, :simple) do
    Enum.reduce(positions, 0, fn ({ p, count }, acc) ->
      fuel = abs(p - alignment) * count
      acc + fuel
    end)
  end


  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day07/input.txt")
    |> Enum.at(0)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn (p, acc) ->
      count = Map.get(acc, p) || 0
      count = count + 1
      Map.put(acc, p, count)
    end)
  end

end
