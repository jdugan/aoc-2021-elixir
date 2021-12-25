defmodule Day23.Critter do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [
    tile_id:  nil,
    state:    :start,
    type:     "A",
    cost:     1,
    steps:    0,
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def energy_consumed(critter) do
    critter.steps * critter.cost
  end

  def home_tile_ids(critter, burrow) do
    Map.get(burrow.homes, critter.type)
    |> MapSet.to_list()
    |> Enum.sort()
    |> Enum.reverse()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------


end
