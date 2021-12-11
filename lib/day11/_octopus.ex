defmodule Day11.Octopus do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [:coord, :energy]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def grow(octopus) do
    %{ octopus | energy: octopus.energy + 1}
  end

  def flash(octopus, cave) do
    flashed_octopus     = %{ octopus | energy: 0 }
    unflashed_neighbors =
      adjacent_octopuses(flashed_octopus, cave)
      |> Enum.reject(&flashed?/1)     # already processed
      |> Enum.reject(&flashable?/1)   # already tracked
      |> Enum.map(&grow/1)

    os = cave.octopuses
    os = Map.put(os, flashed_octopus.coord, flashed_octopus)
    os = Enum.reduce(unflashed_neighbors, os, fn (n, acc) ->
      Map.put(acc, n.coord, n)
    end)

    updated_cave = %{ cave | octopuses: os }
    ready_mapset =
      unflashed_neighbors
      |> Enum.filter(&flashable?/1)
      |> MapSet.new()

    { updated_cave, flashed_octopus, ready_mapset }
  end

  def flashable?(octopus) do
    octopus.energy > 9
  end

  def flashed?(octopus) do
    octopus.energy == 0
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  defp adjacent_octopuses(octopus, cave) do
    { x, y } = octopus.coord

    e  = { x + 1, y }
    n  = { x,     y - 1 }
    ne = { x + 1, y - 1 }
    nw = { x - 1, y - 1 }
    s  = { x,     y + 1 }
    se = { x + 1, y + 1 }
    sw = { x - 1, y + 1 }
    w  = { x - 1, y }

    [e, n, ne, nw, s, se, sw, w]
    |> Enum.map(fn k -> Map.get(cave.octopuses, k) end)
    |> Enum.reject(&is_nil/1)
  end

end
