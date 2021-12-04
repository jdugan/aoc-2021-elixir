defmodule Day04.Board do

  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def mark(board, number) do
    List.keyreplace(board, number, 0, { number, true })
  end

  def score(board, final_number) do
    { _, unmarked } = separate_keys(board)
    Enum.sum(unmarked) * final_number
  end

  def winner?(board) do
    marked  = marked_indices(board)
    winning = winning_indices()

    Enum.any?(winning, fn w ->
      MapSet.intersection(w, marked) == w
    end)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== SCORE HELPERS ==============================

  defp reducer_marked({ number, marked }, list) do
    if marked, do: [ number | list ], else: list
  end

  defp reducer_unmarked({ number, marked }, list) do
    if marked, do: list, else: [ number | list ]
  end

  defp separate_keys(board) do
    marked   = Enum.reduce(board, [], &reducer_marked/2)
    unmarked = Enum.reduce(board, [], &reducer_unmarked/2)

    { MapSet.new(marked), MapSet.new(unmarked) }
  end


  # ========== WIN HELPERS ================================

  defp marked_indices(board) do
    board
    |> Enum.with_index
    |> Enum.reduce([], fn ({{_, marked}, index}, acc) ->
      if marked, do: [ index | acc ], else: acc
    end)
    |> MapSet.new
  end

  defp winning_indices do
    [
      MapSet.new([0, 1, 2, 3, 4]),
      MapSet.new([5, 6, 7, 8, 9]),
      MapSet.new([10, 11, 12, 13, 14]),
      MapSet.new([15, 16, 17, 18, 19]),
      MapSet.new([20, 21, 22, 23, 24]),
      MapSet.new([0, 5, 10, 15, 20]),
      MapSet.new([1, 6, 11, 16, 21]),
      MapSet.new([2, 7, 12, 17, 22]),
      MapSet.new([3, 8, 13, 18, 23]),
      MapSet.new([4, 9, 14, 19, 24])
    ]
  end

end
