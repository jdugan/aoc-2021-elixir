defmodule Day03 do

  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 3")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    find_gamma_rate() * find_epsilon_rate()
  end

  def puzzle2 do
    find_oxygen_rate() * find_carbon_rate()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # power
  defp find_epsilon_rate() do
    max_value() - find_gamma_rate()
  end

  defp find_gamma_rate() do
    count_occurrences(data(), initial_counts())
    |> convert_counts_to_binary_array(:higher)
    |> Conversion.binary_array_to_decimal
  end

  # life support
  defp find_carbon_rate() do
    find_item_by_count_occurrences(data(), 0, :lower)
    |> Conversion.binary_array_to_decimal
  end

  defp find_oxygen_rate() do
    find_item_by_count_occurrences(data(), 0, :higher)
    |> Conversion.binary_array_to_decimal
  end


  # ========== CONVERSION HELPERS =========================

  defp convert_counts_to_binary_array(counts, mode) do
    Enum.map(counts, fn(count) ->
      convert_count_to_frequency_digit(count, mode)
    end)
  end

  defp convert_count_to_frequency_digit({ c0, c1 }, mode) when c0 > c1 do
    if (mode == :higher), do: 0, else: 1
  end

  defp convert_count_to_frequency_digit({ c0, c1 }, mode) when c0 < c1 do
    if (mode == :higher), do: 1, else: 0
  end

  defp convert_count_to_frequency_digit({ c0, c1 }, mode) when c0 == c1 do
    if (mode == :higher), do: 1, else: 0
  end


  # ========== COUNT HELPERS ==============================

  defp apply_digits_to_counts(digits, counts) do
    digits
    |> Enum.with_index
    |> Enum.reduce(counts, fn ({ digit, index }, acc) ->
      { c0, c1 } = Enum.at(acc, index)
      changeset  = if digit == 0, do: { c0 + 1, c1 }, else: { c0, c1 + 1 }

      List.update_at(acc, index, fn _ -> changeset end)
    end)
  end

  defp count_occurrences(list, counts) do
    Enum.reduce(list, counts, fn (digits, acc) ->
       apply_digits_to_counts(digits, acc)
    end)
  end

  defp find_item_by_count_occurrences(list, _, _) when length(list) == 1 do
    List.first(list)
  end

  defp find_item_by_count_occurrences(list, index, mode) do
    freqs  = count_occurrences(list, initial_counts())
             |> convert_counts_to_binary_array(mode)
    filter = Enum.at(freqs, index)

    filtered_list = Enum.filter(list, fn (item) ->
      Enum.at(item, index) == filter
    end)

    find_item_by_count_occurrences(filtered_list, index + 1, mode)
  end


  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day03/input.txt")
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> Enum.map(&String.to_integer/1)
    end)
  end


  # ========== UTILITY HELPERS ============================

  defp digits_per_line_item do
    List.first(data()) |> length
  end

  defp initial_counts do
    List.duplicate({ 0, 0 }, digits_per_line_item())
  end

  defp max_value do
    max = :math.pow(2, digits_per_line_item()) |> trunc
    max - 1
  end

end
