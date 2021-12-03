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
    findGammaRate() * findEpsilonRate()
  end

  def puzzle2 do
    findOxygenRate() * findCarbonRate()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  defp findCarbonRate() do
    findItemByCountOccurrences(data(), 0, :down)
    |> convertBinaryArrayToDecimal
  end

  defp findEpsilonRate() do
    maxValue() - findGammaRate()
  end

  defp findGammaRate() do
    countOccurrences(data(), 0, initialCounts())
    |> convertCountsToBinaryArray(:up)
    |> convertBinaryArrayToDecimal
  end

  defp findOxygenRate() do
    findItemByCountOccurrences(data(), 0, :up)
    |> convertBinaryArrayToDecimal
  end


  # ========== CONVERSION HELPERS =========================

  defp convertBinaryArrayToDecimal(digits) do
    Enum.reverse(digits)
    |> Enum.with_index
    |> Enum.reduce(0, fn({n, i}, acc) ->
      if n == 1 do
        acc + (:math.pow(2, i)) |> trunc
      else
        acc
      end
    end)
  end

  defp convertCountsToBinaryArray(counts, mode) do
    Enum.map(counts, fn(count) ->
      convertCountToFrequencyDigit(count, mode)
    end)
  end

  defp convertCountToFrequencyDigit({ c0, c1 }, mode) when c0 > c1 do
    if (mode == :up), do: 0, else: 1
  end

  defp convertCountToFrequencyDigit({ c0, c1 }, mode) when c0 < c1 do
    if (mode == :up), do: 1, else: 0
  end

  defp convertCountToFrequencyDigit({ c0, c1 }, mode) when c0 == c1 do
    if (mode == :up), do: 1, else: 0
  end


  # ========== COUNT HELPERS ==============================

  defp applyDigitsToCounts(digits, index, counts) when index == length(digits) do
    counts
  end

  defp applyDigitsToCounts(digits, index, counts) do
    { c0, c1 } = Enum.at(counts, index)
    digit      = Enum.at(digits, index)
    changeset  = if digit == 0, do: { c0 + 1, c1 }, else: { c0, c1 + 1 }
    new_counts = List.update_at(counts, index, fn _ -> changeset end)

    applyDigitsToCounts(digits, index + 1, new_counts)
  end

  defp countOccurrences(list, index, counts) when index == length(list) do
    counts
  end

  defp countOccurrences(list, index, counts) do
    digits = Enum.at(list, index)
    counts = applyDigitsToCounts(digits, 0, counts)
    countOccurrences(list, index + 1, counts)
  end

  defp findItemByCountOccurrences(list, _, _) when length(list) == 1 do
    List.first(list)
  end

  defp findItemByCountOccurrences(list, index, mode) do
    freqs  = countOccurrences(list, 0, initialCounts())
             |> convertCountsToBinaryArray(mode)
    filter = Enum.at(freqs, index)

    filtered_list = Enum.filter(list, fn (item) ->
      Enum.at(item, index) == filter
    end)

    findItemByCountOccurrences(filtered_list, index + 1, mode)
  end


  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day03/input.txt")
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> Enum.map(fn s -> String.to_integer(s) end)
    end)
  end


  # ========== UTILITY HELPERS ============================

  defp digitRange do
    0..digitsPerValue() - 1
  end

  defp digitsPerValue do
    List.first(data()) |> length
  end

  defp initialCounts do
    digitRange()
    |> Enum.map(fn (_) -> { 0, 0 } end)
  end

  defp maxValue do
    max = :math.pow(2, digitsPerValue()) |> trunc
    max - 1
  end

end
