defmodule Day21.Pawn do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [
    id:       nil,
    position: nil,
    score:    0
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def move(pawn, distance) do
    pos   = rem(pawn.position + distance, 10)
    pos   = if pos == 0, do: 10, else: pos
    score = pawn.score + pos

    %{ pawn | position: pos, score: score }
  end

end
