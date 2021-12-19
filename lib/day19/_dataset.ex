defmodule Day19.Dataset do

  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ROTATE HELPERS =============================

  def generate_rotations(dataset) do
    0..23
    |> Enum.reduce([], fn (step, acc) ->
      [ rotate_dataset(dataset, step) | acc ]
    end)
    |> Enum.sort()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== ROTATE HELPERS =============================

  defp rotate_dataset(dataset, step) do
    dataset
    |> Enum.reduce([], fn (base_point, acc) ->
      [ rotate_point(base_point, step) | acc ]
    end)
    |> Enum.sort()
  end

  defp rotate_point({ x, y, z}, step) do
    case step do
      # top side
      0  -> {  x,  y,  z }
      1  -> {  y, -x,  z }
      2  -> { -x, -y,  z }
      3  -> { -y,  x,  z }

      # right side
      4  -> {  z,  x,  y }
      5  -> {  z,  y, -x }
      6  -> {  z, -x, -y }
      7  -> {  z, -y,  x }

      # left side
      8  -> { -z,  y,  x }
      9  -> { -z, -x,  y }
      10 -> { -z, -y, -x }
      11 -> { -z,  x, -y }

      # front side
      12 -> {  x, -z,  y }
      13 -> {  y, -z, -x }
      14 -> { -x, -z, -y }
      15 -> { -y, -z,  x }

      # back side
      16 -> { -x,  z,  y }
      17 -> { -y,  z, -x }
      18 -> {  x,  z, -y }
      19 -> {  y,  z,  x }

      # bottom side
      20 -> {  y,  x, -z }
      21 -> {  x, -y, -z }
      22 -> { -y, -x, -z }
      23 -> { -x,  y, -z }

      # default (no rotation)
      _  -> {  x,  y,  z }
    end
  end

end
