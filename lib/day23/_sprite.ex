defmodule Day23.Sprite do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [
    id:       nil,
    tile_id:  nil,
    state:    :initial,
    type:     "A",
    cost:     1,
    steps:    0,
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def energy_consumed(amphipod) do
    amphipod.steps * amphipod.cost
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------


end
