defmodule Day15.Point do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct id: nil, adjacent_ids: [], value: 0


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ADJACENCY HELPERS ==========================

  def possible_adjacent_ids(point) do
    { x, y } = point.id
    up       = { x, y - 1 }
    down     = { x, y + 1 }
    left     = { x - 1, y }
    right    = { x + 1, y }

    [up, down, left, right]
  end


  # ========== TILE HELPERS ===============================

  def increment_adjacent_ids(adjacent_ids, axis, size) do
    adjacent_ids
    |> Enum.map(fn id -> increment_id(id, axis, size) end)
  end

  def increment_id({ x, y }, :x, size) do
    { x + size, y }
  end

  def increment_id({ x, y }, :y, size) do
    { x, y + size }
  end

  def increment_value(value) do
    if (value + 1 < 10) do
      value + 1
    else
      1
    end
  end

end
