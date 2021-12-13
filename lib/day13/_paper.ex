defmodule Day13.Paper do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [:dots, :folds]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def count_dots(paper) do
    map_size(paper.dots)
  end


  # ========== FOLD HELPERS ===============================

  def fold_all(paper) do
    initial = %Day13.Paper{ dots: paper.dots }

    paper.folds
    |> Enum.reduce(initial, fn ({ dir, crease }, p) ->
      fold(p, dir, crease)
    end)
  end

  def fold_once(paper) do
    { dir, crease } = Enum.at(paper.folds, 0)

    fold(paper, dir, crease)
  end


  # ========== PRINT HELPERS ==============================

  def print(paper) do
    IO.puts ""
    to_printable_list(paper)
    |> Enum.each(fn row ->
      IO.puts Enum.join(row)
    end)
    IO.puts ""
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== FOLD HELPERS ===============================

  defp fold(paper, dir, crease) do
    dots =
      paper.dots
      |> Map.keys()
      |> Enum.reduce(%{}, fn (coord, map) ->
        Map.put(map, fold_coord(coord, dir, crease), "#")
      end)

    %Day13.Paper{ dots: dots, folds: paper.folds }
  end

  defp fold_coord({ x, y }, :x, crease) do
    x1 = if x > crease, do: (2 * crease) - x, else: x
    { x1, y }
  end

  defp fold_coord({ x, y }, :y, crease) do
    y1 = if y > crease, do: (2 * crease) - y, else: y
    { x, y1 }
  end


  # ========== PRINT HELPERS ==============================

  defp print_dimension_ranges(paper) do
    keys = Map.keys(paper.dots)
    xmax = keys |> Enum.map(fn { x, _ } -> x end) |> Enum.max
    ymax = keys |> Enum.map(fn { _, y } -> y end) |> Enum.max

    { Enum.to_list(0..xmax), Enum.to_list(0..ymax) }
  end

  defp to_printable_list(paper) do
    { xs, ys } = print_dimension_ranges(paper)

    Enum.map(ys, fn y ->
      Enum.map(xs, fn x ->
        Map.get(paper.dots, { x, y }, ".")
      end)
    end)
  end

end
