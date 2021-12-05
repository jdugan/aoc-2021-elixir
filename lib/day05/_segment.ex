defmodule Day05.Segment do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [:x0, :y0, :x1, :y1]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ATTRIBUTES =================================

  def points(segment) do
    case type(segment) do
      :diagonal   -> expand_points(segment, :diagonal)
      :horizontal -> expand_points(segment, :horizontal)
      :vertical   -> expand_points(segment, :vertical)
      _           -> []
    end
  end

  def type(segment) do
    cond do
      diagonal?(segment)   -> :diagonal
      horizontal?(segment) -> :horizontal
      vertical?(segment)   -> :vertical
      true                 -> :unknown
    end
  end


  # ========== STATE HELPERS ==============================

  def diagonal?(segment) do
    !horizontal?(segment) and !vertical?(segment)
  end

  def horizontal?(segment) do
    segment.y0 == segment.y1
  end

  def perpendicular?(segment) do
    horizontal?(segment) or vertical?(segment)
  end

  def vertical?(segment) do
    segment.x0 == segment.x1
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== POINT HELPERS ==============================

  defp expand_points(segment, :diagonal) do
    xs = Enum.to_list(segment.x0..segment.x1)
    ys = Enum.to_list(segment.y0..segment.y1)

    Enum.zip(xs, ys)
  end

  defp expand_points(segment, :horizontal) do
    segment.x0..segment.x1
    |> Enum.map(fn x -> { x, segment.y0 } end)
  end

  defp expand_points(segment, :vertical) do
    segment.y0..segment.y1
    |> Enum.map(fn y -> { segment.x0, y } end)
  end

end
