defmodule Day17.Target do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [:x_min, :x_max, :y_min, :y_max]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== STATE HELPERS ==============================

  def out_of_range?(target, probe) do
    cond do
      probe.x > target.x_max -> true
      probe.y < target.y_min -> true
      probe.dx == 0 and !within?(target, probe, :x) -> true
      true -> false
    end
  end

  def within?(target, probe) do
    within?(target, probe, :x) and within?(target, probe, :y)
  end

  def within?(target, probe, :x) do
    probe.x >= target.x_min and probe.x <= target.x_max
  end

  def within?(target, probe, :y) do
    probe.y >= target.y_min and probe.y <= target.y_max
  end

end
