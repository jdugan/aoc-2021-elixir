defmodule Day23.Tile do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [
    id:   nil,
    type: :hall,
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== STATE HELPERS ==============================

  def is_door?(tile) do
    tile.type == :door
  end

  def is_hall?(tile) do
    tile.type == :hall
  end

  def is_room?(tile) do
    tile.type == :room
  end

  def occupied?(tile, burrow) do
    Map.has_key?(burrow.critters, tile.id)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------


end
