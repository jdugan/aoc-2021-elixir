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

  # power
  defp findEpsilonRate() do
    maxValue() - findGammaRate()
  end

  defp findGammaRate() do
    countOccurrences(data(), initialCounts())
    |> convertCountsToBinaryArray(:higher)
    |> convertBinaryArrayToDecimal
  end

  # life support
  defp findCarbonRate() do
    findItemByCountOccurrences(data(), 0, :lower)
    |> convertBinaryArrayToDecimal
  end

  defp findOxygenRate() do
    findItemByCountOccurrences(data(), 0, :higher)
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
    if (mode == :higher), do: 0, else: 1
  end

  defp convertCountToFrequencyDigit({ c0, c1 }, mode) when c0 < c1 do
    if (mode == :higher), do: 1, else: 0
  end

  defp convertCountToFrequencyDigit({ c0, c1 }, mode) when c0 == c1 do
    if (mode == :higher), do: 1, else: 0
  end


  # ========== COUNT HELPERS ==============================

  defp applyDigitsToCounts(digits, counts) do
    digits
    |> Enum.with_index
    |> Enum.reduce(counts, fn ({ digit, index }, acc) ->
      { c0, c1 } = Enum.at(acc, index)
      changeset  = if digit == 0, do: { c0 + 1, c1 }, else: { c0, c1 + 1 }

      List.update_at(acc, index, fn _ -> changeset end)
    end)
  end

  defp countOccurrences(list, counts) do
    Enum.reduce(list, counts, fn (digits, acc) ->
       applyDigitsToCounts(digits, acc)
    end)
  end

  defp findItemByCountOccurrences(list, _, _) when length(list) == 1 do
    List.first(list)
  end

  defp findItemByCountOccurrences(list, index, mode) do
    freqs  = countOccurrences(list, initialCounts())
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
      |> Enum.map(&String.to_integer/1)
    end)
  end


  # ========== UTILITY HELPERS ============================

  defp digitsPerLineItem do
    List.first(data()) |> length
  end

  defp initialCounts do
    List.duplicate({ 0, 0 }, digitsPerLineItem())
  end

  defp maxValue do
    max = :math.pow(2, digitsPerLineItem()) |> trunc
    max - 1
  end


  # ========== DEPRECATED =================================



end
