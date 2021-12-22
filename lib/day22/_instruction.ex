defmodule Day22.Instruction do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__

  defstruct [
    state: nil,
    x_min: nil, x_max: nil,
    y_min: nil, y_max: nil,
    z_min: nil, z_max: nil
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def size(instruction) do
    xs = instruction.x_max - instruction.x_min + 1
    ys = instruction.y_max - instruction.y_min + 1
    zs = instruction.z_max - instruction.z_min + 1

    xs * ys * zs
  end


  # ========== RANGE HELPERS ==============================

  def overlapping?(i0, i1) do
    { x0, y0, z0 } = to_tupleset(i0)
    { x1, y1, z1 } = to_tupleset(i1)

    range_overlap?(x0, x1) and range_overlap?(y0, y1) and range_overlap?(z0, z1)
  end


  # ========== SET HELPERS ================================

  def add(instruction, cubesets) do
    print = instruction.x_min == 2
    apply_union(cubesets, [instruction], print)
  end

  def remove(instruction, cubesets) do
    apply_difference([], cubesets, instruction)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DIFFERENCE HELPERS =========================

  defp apply_difference(remainder, cubesets, _) when length(cubesets) == 0 do
    remainder
  end

  defp apply_difference(current_remainder, current_cubesets, instruction) do
    [ cs | cubesets ] = current_cubesets
    remainder         = calculate_difference(cs, instruction)
    remainder         = Enum.concat(current_remainder, remainder)

    apply_difference(remainder, cubesets, instruction)
  end

  defp calculate_difference(i0, i1) do
    if overlapping?(i0, i1) do
      { x0, y0, z0 } = to_tupleset(i0)
      { x1, y1, z1 } = to_tupleset(i1)

      { xl, xm, xr } = range_groups(x0, x1)
      { yl, ym, yr } = range_groups(y0, y1)
      { zl, _, zr  } = range_groups(z0, z1)

      ts = calculate_tuplesets([], xl, xr, y0, z0, :x)
      ts = calculate_tuplesets(ts, xm, yl, yr, z0, :y)
      ts = calculate_tuplesets(ts, xm, ym, zl, zr, :z)
      ts = Enum.reject(ts, &is_nil/1)

      Enum.map(ts, &from_tupleset/1)
    else
      [i0]
    end
  end

  defp calculate_tuplesets(current_ts, xl, xr, yt, zt, :x) do
    t0 = if xl, do: { xl, yt, zt }, else: nil
    t1 = if xr, do: { xr, yt, zt }, else: nil

    [t0, t1]
    |> Enum.reject(&is_nil/1)
    |> Enum.concat(current_ts)
  end

  defp calculate_tuplesets(current_ts, xm, yl, yr, zt, :y) do
    t0 = if yl, do: { xm, yl, zt }, else: nil
    t1 = if yr, do: { xm, yr, zt }, else: nil

    [t0, t1]
    |> Enum.reject(&is_nil/1)
    |> Enum.concat(current_ts)
  end

  defp calculate_tuplesets(current_ts, xm, ym, zl, zr, :z) do
    t0 = if zl, do: { xm, ym, zl }, else: nil
    t1 = if zr, do: { xm, ym, zr }, else: nil

    [t0, t1]
    |> Enum.reject(&is_nil/1)
    |> Enum.concat(current_ts)
  end


  # ========== RANGE HELPERS ==============================

  defp range_groups({ min0, max0 }, { min1, max1 }) do
    left   = if min1 <= min0, do: nil, else: { min0, min1 - 1 }
    middle = { Enum.max([min0, min1]), Enum.min([max0, max1]) }
    right  = if max1 >= max0, do: nil, else: { max1 + 1, max0 }

    { left, middle, right }
  end

  defp range_overlap?({ min0, max0 }, { min1, max1 }) do
    (min0 <= min1 and min1 <= max0) or
    (min0 <= max1 and max1 <= max0) or
    (min1 <= min0 and min0 <= max1) or
    (min1 <= max0 and max0 <= max1)
  end


  # ========== UNION HELPERS ==============================

  defp apply_union(cubesets, additions, _) when length(cubesets) == 0 or length(additions) == 0 do
    additions
  end

  defp apply_union(current_cubesets, current_additions, print) do
    [ cs | cubesets ] = current_cubesets
    additions         = remove(cs, current_additions)

    apply_union(cubesets, additions, print)
  end


  # ========== UTILITY HELPERS ============================

  defp from_tupleset(tupleset) do
    list             = Tuple.to_list(tupleset)
    { x_min, x_max } = Enum.at(list, 0)
    { y_min, y_max } = Enum.at(list, 1)
    { z_min, z_max } = Enum.at(list, 2)

    %Instruction{
      state: "on",
      x_min: x_min, x_max: x_max,
      y_min: y_min, y_max: y_max,
      z_min: z_min, z_max: z_max
    }
  end

  def to_tupleset(instruction) do
    xt = { instruction.x_min, instruction.x_max }
    yt = { instruction.y_min, instruction.y_max }
    zt = { instruction.z_min, instruction.z_max }

    { xt, yt, zt }
  end

end
