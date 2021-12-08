defmodule Day04.Game do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day04.Board, as: Board


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def play_to_lose(boards, numbers) do
    process_rounds_to_lose(boards, numbers, 0, boards)
  end

  def play_to_win(boards, numbers) do
    process_rounds_to_win(boards, numbers, 0, nil)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  defp process_rounds_to_lose(_, numbers, index, losers) when length(losers) == 1 do
    final_number = Enum.at(numbers, index - 1)
    loser        = Enum.at(losers, 0)

    { loser, final_number }
  end

  defp process_rounds_to_lose(boards, numbers, index, _) do
    number = Enum.at(numbers, index)
    boards = Enum.map(boards, fn board -> Board.mark(board, number) end)
    losers = Enum.filter(boards, fn board -> !Board.winner?(board) end)

    process_rounds_to_lose(boards, numbers, index + 1, losers)
  end

  defp process_rounds_to_win(_, numbers, index, winner) when winner != nil do
    final_number = Enum.at(numbers, index - 1)

    { winner, final_number }
  end

  defp process_rounds_to_win(boards, numbers, index, _) do
    number = Enum.at(numbers, index)
    boards = Enum.map(boards, fn board -> Board.mark(board, number) end)
    winner = Enum.find(boards, fn board -> Board.winner?(board) end)

    process_rounds_to_win(boards, numbers, index + 1, winner)
  end

end
