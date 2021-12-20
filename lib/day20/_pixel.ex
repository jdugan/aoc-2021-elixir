defmodule Day20.Pixel do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [
    id:    nil,
    state: "."
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ADJACENCY HELPERS ==========================

  def ordered_algorithm_ids(pixel) do
    { x, y } = pixel.id
    nw = { x - 1, y - 1 }
    n  = { x,     y - 1 }
    ne = { x + 1, y - 1 }
    w  = { x - 1, y }
    e  = { x + 1, y }
    sw = { x - 1, y + 1 }
    s  = { x,     y + 1 }
    se = { x + 1, y + 1 }

    [nw, n, ne, w, pixel.id, e, sw, s, se]
  end

end
