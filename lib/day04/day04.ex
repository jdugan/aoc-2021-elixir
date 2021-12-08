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
    { winner, final_number } = Game.play_to_win(boards, numbers)

    Board.score(winner, final_number)
  end

  def puzzle2 do
    { boards, numbers }      = data()
    { loser, _ }             = Game.play_to_lose(boards, numbers)
    { winner, final_number } = Game.play_to_win([loser], numbers)

    Board.score(winner, final_number)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    lines          = Reader.to_lines("./data/day04/input.txt")
    { boards, _ }  = parse_board_lines(Enum.drop(lines, 1))
    numbers        = parse_number_line(Enum.at(lines, 0))

    { boards, numbers }
  end

  def parse_board_lines(lines) do
    lines
    |> Enum.with_index
    |> Enum.reduce({ [], [] }, fn { line, index }, { boards, squares } ->
      line_squares = parse_board_line(line)
      new_squares  = Enum.concat(squares, line_squares)

      if rem(index, 5) == 4 do
        { [ new_squares | boards ], [] }
      else
        { boards, new_squares }
      end
    end)
  end

  def parse_board_line(line) do
    String.split(line, ~r/\s+/, trim: true)
    |> Enum.map(fn s ->
      { String.to_integer(s), false }
    end)
  end

  def parse_number_line(line) do
    String.split(line, ",")
    |> Enum.map(&String.to_integer/1)
  end

end
