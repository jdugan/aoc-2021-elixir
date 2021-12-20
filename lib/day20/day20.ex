defmodule Day20 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day20.Pixel, as: Pixel
  alias Day20.Photo, as: Photo


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 20")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> Photo.enhance(2)
    |> Photo.count_lit_pixels()
  end

  def puzzle2 do
    data()
    |> Photo.enhance(50)
    |> Photo.count_lit_pixels()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    [ algorithm_str | lines ]
      = Reader.to_lines("./data/day20/input.txt")

    algorithm =
      algorithm_str
      |> String.graphemes()

    pixels =
      lines
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({ line, y }, map) ->
        line_map = parse_line(line, y)

        Map.merge(map, line_map)
      end)

    %Photo{ algorithm: algorithm, pixels: pixels }
  end

  defp parse_line(line, y) do
    line
    |> String.graphemes
    |> Enum.with_index
    |> Enum.reduce(%{}, fn ({ g, x }, acc) ->
      if g == "#" do
        p = %Pixel{ id: { x, y }, state: g }
        Map.put_new(acc, p.id, p)
      else
        acc
      end
    end)
  end

end
