defmodule Day09.Coord do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [:x, :y, :h]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ATTRIBUTES =================================

  def key(coord) do
    { coord.x, coord.y }
  end

  def risk_level(coord) do
    coord.h + 1
  end


  # ========== ADJACENT HELPERS ===========================

  def adjacent_coords(map, coord) do
    up    = { coord.x, coord.y - 1 }
    down  = { coord.x, coord.y + 1 }
    left  = { coord.x - 1, coord.y }
    right = { coord.x + 1, coord.y }

    [up, down, left, right]
    |> Enum.map(fn k -> Map.get(map, k) end)
    |> Enum.reject(&is_nil/1)
  end

  def adjacent_heights(map, coord) do
    adjacent_coords(map, coord)
    |> Enum.map(fn c -> c.h end)
  end


  # ========== STATE HELPERS ==============================

  def lowest?(map, coord) do
    ahs = adjacent_heights(map, coord)
    coord.h < Enum.min(ahs)
  end

  def drainable?(coord) do
    coord.h != 9
  end

end
