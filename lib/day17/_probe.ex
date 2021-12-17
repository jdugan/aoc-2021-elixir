defmodule Day17.Probe do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__

  defstruct [:x, :y, :dx, :dy]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== MOVE HELPERS ===============================

  def move(probe) do
    x = probe.x + probe.dx
    y = probe.y + probe.dy

    dx =
      cond do
        probe.dx > 0 -> probe.dx - 1
        probe.dx < 0 -> probe.dx + 1
        true -> 0
      end
    dy = probe.dy - 1

    %Probe{ x: x, y: y, dx: dx, dy: dy }
  end

end
