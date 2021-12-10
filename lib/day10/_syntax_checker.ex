defmodule Day10.SyntaxChecker do

  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== SCORE HELPERS ==============================

  def autocomplete_score(lines) do
    lines
    |> Enum.map(&parse_line/1)
    |> filter_lines_by_type(:incomplete)
    |> calculate_autocomplete_score()
  end

  def error_score(lines) do
    lines
    |> Enum.map(&parse_line/1)
    |> filter_lines_by_type(:corrupt)
    |> calculate_error_score()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== PARSING HELPERS ============================

  defp classify_remainder(remainder) do
    type = classify_remainder_type(remainder)
    meta = classify_remainder_meta(remainder, type)

    { type, meta }
  end

  defp classify_remainder_meta(remainder, :corrupt) do
    determine_first_corrupt_char(remainder)
  end

  defp classify_remainder_meta(remainder, :incomplete) do
    determine_autocomplete_sequence(remainder)
  end

  defp classify_remainder_meta(_, :ok) do
    nil
  end

  defp classify_remainder_type(remainder) do
    cond do
      String.length(remainder) == 0 ->
        :ok
      is_corrupt?(remainder) ->
        :corrupt
      true ->
        :incomplete
    end
  end

  defp corrupt_chars do
    MapSet.new([")", "]", "}", ">"])
  end

  defp determine_autocomplete_sequence(line) do
    line
    |> String.graphemes
    |> Enum.reverse
    |> Enum.map(&invert_char/1)
    |> Enum.join
  end

  defp determine_first_corrupt_char(line) do
    chars = String.graphemes(line)
    index =
      corrupt_chars()
      |> Enum.map(fn ic ->
        Enum.find_index(chars, fn c -> c == ic end)
      end)
      |> Enum.min

    if index, do: String.at(line, index), else: nil
  end

  defp filter_lines_by_type(lines, type) do
    Enum.filter(lines, fn { t, _ } -> t == type end)
  end

  defp invert_char(char) do
    case char do
      "(" -> ")"
      "[" -> "]"
      "{" -> "}"
      "<" -> ">"
    end
  end

  defp parse_line(line) do
    shorten_line(line, nil)
    |> classify_remainder()
  end

  defp shorten_line(curr, prev) when curr == prev or curr == "" do
    curr
  end

  defp shorten_line(curr, _) do
    next =
      curr
      |> String.replace("()", "")
      |> String.replace("[]", "")
      |> String.replace("{}", "")
      |> String.replace("<>", "")

    shorten_line(next, curr)
  end


  # ========== SCORE HELPERS ==============================

  defp calculate_autocomplete_score(lines) do
    index  = length(lines)/2 |> trunc
    scores =
      lines
      |> Enum.map(fn { _, line } ->
        calculate_autocomplete_subscore(line)
      end)
      |> Enum.sort()

    Enum.at(scores, index)
  end

  defp calculate_autocomplete_subscore(line) do
    String.graphemes(line)
    |> Enum.reduce(0, fn (char, sum) ->
      subscore =
        case char do
          ")" -> 1
          "]" -> 2
          "}" -> 3
          ">" -> 4
        end

      (sum * 5) + subscore
    end)
  end

  defp calculate_error_score(lines) do
    lines
    |> Enum.reduce(0, fn ({ _, c }, sum) ->
      sum + calculate_error_subscore(c)
    end)
  end

  defp calculate_error_subscore(char) do
    case char do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end


  # ========== STATE HELPERS ==============================

  defp is_corrupt?(line) do
    match_count =
      line
      |> String.graphemes()
      |> MapSet.new()
      |> MapSet.intersection(corrupt_chars())
      |> MapSet.size()

    match_count > 0
  end

end
