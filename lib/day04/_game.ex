defmodule Day04.Game do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day04.Board, as: Board


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def playToLose(boards, numbers) do
    processRoundsToLose(boards, numbers, 0, boards)
  end

  def playToWin(boards, numbers) do
    processRoundsToWin(boards, numbers, 0, nil)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  defp processRoundsToLose(_, numbers, index, losers) when length(losers) == 1 do
    final_number = Enum.at(numbers, index - 1)
    loser        = Enum.at(losers, 0)

    { loser, final_number }
  end

  defp processRoundsToLose(boards, numbers, index, _) do
    number = Enum.at(numbers, index)
    boards = Enum.map(boards, fn board -> Board.mark(board, number) end)
    losers = Enum.filter(boards, fn board -> !Board.winner?(board) end)

    processRoundsToLose(boards, numbers, index + 1, losers)
  end

  defp processRoundsToWin(_, numbers, index, winner) when winner != nil do
    final_number = Enum.at(numbers, index - 1)

    { winner, final_number }
  end

  defp processRoundsToWin(boards, numbers, index, _) do
    number = Enum.at(numbers, index)
    boards = Enum.map(boards, fn board -> Board.mark(board, number) end)
    winner = Enum.find(boards, fn board -> Board.winner?(board) end)

    processRoundsToWin(boards, numbers, index + 1, winner)
  end

end
