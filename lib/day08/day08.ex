defmodule Day08 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day08.Decoder, as: Decoder
  alias Day08.Digit,   as: Digit


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 8")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    Enum.reduce(data(), 0, &short_reducer/2)
  end

  def puzzle2 do
    Enum.reduce(data(), 0, &full_reducer/2)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== ANALYSIS HELPERS ===========================

  defp full_reducer({ signals, outputs }, sum) do
    value =
      signals
      |> Decoder.perform_full_analysis()
      |> Decoder.evaluate(outputs)

    sum + value
  end

  defp short_reducer({ _, outputs }, sum) do
    count =
      outputs
      |> Decoder.perform_short_analysis()
      |> Enum.filter(fn d -> Digit.is_known?(d) end)
      |> length

    sum + count
  end


  # ========== DATA HELPERS ===============================

  defp data do
    Reader.to_lines("./data/day08/input.txt")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    { signals_str, outputs_str } =
      line
      |> String.split(" | ")
      |> List.to_tuple

    signals = parse_codes(signals_str)
    outputs = parse_codes(outputs_str)

    { signals, outputs }
  end

  defp parse_codes(list) do
    list
    |> String.split(" ")
    |> Enum.map(fn unordered_code ->
      graphemes = String.graphemes(unordered_code) |> MapSet.new
      code      = Enum.join(graphemes)

      %Digit{ code: code, graphemes: graphemes }
    end)
  end

end
