defmodule Day06 do

  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 6")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> process_turns(80)
    |> count_fish
  end

  def puzzle2 do
    data()
    |> process_turns(256)
    |> count_fish
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  defp count_fish(population) do
    Map.values(population)
    |> Enum.sum
  end

  defp process_turns(population, i) when i == 0 do
    population
  end

  defp process_turns(current_population, i) do
    population = process_turn(current_population)

    process_turns(population, i - 1)
  end

  defp process_turn(population) do
    Enum.reduce(population, %{}, fn ({ age, count }, acc) ->
      case age do
        0 ->
          Map.put(acc, 6, count)
          |> Map.put(8, count)
        7 ->
          current = Map.get(acc, age - 1) || 0
          current = current + count
          Map.put(acc, age - 1, current)
        _ ->
          Map.put(acc, age - 1, count)
      end
    end)
  end


  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day06/input.txt")
    |> Enum.at(0)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn (age, acc) ->
      count = Map.get(acc, age) || 0
      count = count + 1
      Map.put(acc, age, count)
    end)
  end

end
