defmodule Day08.Decoder do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day08.Digit, as: Digit


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def evaluate(analysed_signals, outputs) do
    outputs
    |> Enum.map(fn o -> find_digit_by_code(analysed_signals, o.code) end)
    |> Enum.map(fn o -> o.value end)
    |> Enum.join
    |> String.to_integer
  end

  def perform_full_analysis(digits) do
    digits
    |> determine_unique_digits()
    |> determine_digit(:six)
    |> determine_digit(:zero)
    |> determine_digit(:nine)
    |> determine_digit(:five)
    |> determine_digit(:two)
    |> determine_digit(:three)
  end

  def perform_short_analysis(digits) do
    digits
    |> determine_unique_digits()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== ANALYSE HELPERS ============================

  defp determine_digit(digits, :zero) do
    candidates = find_candidates_by_length(digits, 6)
    baseline   = find_digit_by_value(digits, 4)

    match =
      candidates
      |> Enum.find(fn digit ->
        match_size = Digit.intersection(baseline, digit) |> MapSet.size()
        match_size == Digit.size(baseline) - 1
      end)

    replace_matched_digit(digits, %{ match | value: 0 })
  end

  defp determine_digit(digits, :two) do
    candidates = find_candidates_by_length(digits, 5)
    grapheme   = find_special_grapheme(digits)
    match      = find_digit_by_grapheme(candidates, grapheme)

    replace_matched_digit(digits, %{ match | value: 2 })
  end

  defp determine_digit(digits, :three) do
    candidates = find_candidates_by_length(digits, 5)
    match      = Enum.at(candidates, 0)

    replace_matched_digit(digits, %{ match | value: 3 })
  end

  defp determine_digit(digits, :five) do
    candidates = find_candidates_by_length(digits, 5)
    d6         = find_digit_by_value(digits, 6)
    grapheme   = find_special_grapheme(digits)
    code       = MapSet.delete(d6.graphemes, grapheme) |> Enum.join()
    match      = find_digit_by_code(candidates, code)

    replace_matched_digit(digits, %{ match | value: 5 })
  end

  defp determine_digit(digits, :six) do
    candidates = find_candidates_by_length(digits, 6)
    baseline   = find_digit_by_value(digits, 1)
    match =
      candidates
      |> Enum.find(fn digit ->
        match_size = Digit.intersection(baseline, digit) |> MapSet.size()
        match_size == Digit.size(baseline) - 1
      end)

    replace_matched_digit(digits, %{ match | value: 6 })
  end

  defp determine_digit(digits, :nine) do
    candidates = find_candidates_by_length(digits, 6)
    match      = Enum.at(candidates, 0)

    replace_matched_digit(digits, %{ match | value: 9 })
  end

  defp determine_unique_digits(digits) do
    digits
    |> Enum.map(fn digit ->
      value =
        case Digit.size(digit) do
          2 -> 1
          3 -> 7
          4 -> 4
          7 -> 8
          _ -> nil
        end

      %{ digit | value: value }
    end)
  end


  # ========== DIGIT HELPERS ==============================

  defp find_candidates_by_length(digits, len) do
    digits
    |> Enum.filter(fn d ->
      !Digit.is_known?(d) and Digit.size(d) == len
    end)
  end

  defp find_digit_by_code(digits, val) do
    digits
    |> Enum.find(fn d -> d.code == val end)
  end

  defp find_digit_by_grapheme(digits, val) do
    digits
    |> Enum.find(fn d -> MapSet.member?(d.graphemes, val) end)
  end

  defp find_digit_by_value(digits, val) do
    digits
    |> Enum.find(fn d -> d.value == val end)
  end

  defp find_special_grapheme(digits) do
    d8 = find_digit_by_value(digits, 8)
    d9 = find_digit_by_value(digits, 9)

    Digit.difference(d8, d9)
    |> Enum.at(0)
  end

  defp replace_matched_digit(digits, match) do
    index = Enum.find_index(digits, fn d ->
      d.code == match.code
    end)

    List.update_at(digits, index, fn _ -> match end)
  end

end
