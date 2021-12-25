defmodule Day25.Critter do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [
    :type,
    :tile_id
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== MOVE HELPERS ===============================

  def next_tile(critter, tiles) do
    tile  = Map.get(tiles, critter.tile_id)

    if critter.type == :east do
      Map.get(tiles, tile.east_id)
    else
      Map.get(tiles, tile.south_id)
    end
  end

end
