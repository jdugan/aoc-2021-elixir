defmodule Day04 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day04.Board, as: Board
  alias Day04.Game,  as: Game


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 4")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    { boards, numbers }      = data()
    { winner, final_number } = Game.playToWin(boards, numbers)

    Board.score(winner, final_number)
  end

  def puzzle2 do
    { boards, numbers }      = data()
    { loser, _ }             = Game.playToLose(boards, numbers)
    { winner, final_number } = Game.playToWin([loser], numbers)

    Board.score(winner, final_number)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    lines   = Reader.to_lines("./data/day04/input.txt")
    boards  = parseBoardLines(Enum.drop(lines, 1), 0, [], [])
    numbers = parseNumberLine(Enum.at(lines, 0))

    { boards, numbers }
  end

  def parseBoardLines(lines, index, boards, _) when index == length(lines) do
    boards
  end

  def parseBoardLines(lines, index, boards, squares) when rem(index, 5) == 4 do
    line_squares = parseBoardLine(Enum.at(lines, index))
    line_board   = Enum.concat(squares, line_squares)
    new_boards   = [ line_board | boards ]

    parseBoardLines(lines, index + 1, new_boards, [])
  end

  def parseBoardLines(lines, index, boards, squares) do
    line_squares = parseBoardLine(Enum.at(lines, index))
    new_squares  = Enum.concat(squares, line_squares)

    parseBoardLines(lines, index + 1, boards, new_squares)
  end

  def parseBoardLine(line) do
    String.split(line, ~r/\s+/, trim: true)
    |> Enum.map(fn s ->
      { String.to_integer(s), false }
    end)
  end

  def parseNumberLine(line) do
    String.split(line, ",")
    |> Enum.map(&String.to_integer/1)
  end

end
