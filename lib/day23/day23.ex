defmodule Day23 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day23.Burrow,  as: Burrow
  alias Day23.Critter, as: Critter
  alias Day23.Tile,    as: Tile


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 23")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => #{ puzzle2() }")
    IO.puts(" ")
  end

  def puzzle1 do
    basic_data()
    |> Burrow.lowest_energy(13000)
  end

  def puzzle2 do
    extended_data()
    |> Burrow.lowest_energy(50000)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp basic_data do
    lines = Reader.to_lines("./data/day23/input.txt")

    build_burrow(lines)
  end

  defp extended_data do
    lines = Reader.to_lines("./data/day23/input-extended.txt")

    build_burrow(lines)
  end

  defp build_burrow(lines) do
    { critters, homes } = parse_critter_lines(lines)
    tiles               = parse_tile_lines(lines, homes)

    %Burrow{ critters: critters, homes: homes, tiles: tiles }
  end

  defp parse_critter_lines(lines) do
    critters =
      lines
      |> Enum.with_index
      |> Enum.flat_map(&parse_critter_line/1)
      |> Enum.reduce(%{}, fn (c, acc) ->
        Map.put(acc, c.tile_id, c)
      end)

    chunk_size =
      map_size(critters)/4
      |> trunc()

    homes =
      critters
      |> Map.keys()
      |> Enum.sort()
      |> Enum.chunk_every(chunk_size)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({ ids, i }, acc) ->
        type = Enum.at([:A, :B, :C, :D], i)
        Map.put(acc, type, MapSet.new(ids))
      end)

    { critters, homes }
  end

  defp parse_critter_line({ line, y }) do
    line
    |> String.graphemes
    |> Enum.with_index
    |> Enum.map(fn { g, x } ->
      case g do
        "A" -> %Critter{ tile_id: { x, y }, type: :A, cost: 1 }
        "B" -> %Critter{ tile_id: { x, y }, type: :B, cost: 10 }
        "C" -> %Critter{ tile_id: { x, y }, type: :C, cost: 100 }
        "D" -> %Critter{ tile_id: { x, y }, type: :D, cost: 1000 }
        _   -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_tile_lines(lines, homes) do
    tiles =
      lines
      |> Enum.with_index
      |> Enum.flat_map(&parse_tile_line/1)
      |> Enum.reduce(%{}, fn (t, acc) ->
        Map.put(acc, t.id, t)
      end)

    hall_tile =
      tiles
      |> Map.values()
      |> Enum.find(&Tile.is_hall?/1)
    { _, hall_y } = hall_tile.id

    homes
    |> Map.values()
    |> Enum.flat_map(&MapSet.to_list/1)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&List.first/1)
    |> Enum.uniq()
    |> Enum.reduce(tiles, fn (x, acc) ->
      id   = { x, hall_y }
      tile = Map.get(tiles, id)

      Map.put(acc, id, %{ tile | type: :door })
    end)
  end

  defp parse_tile_line({ line, y }) do
    line
    |> String.graphemes
    |> Enum.with_index
    |> Enum.map(fn { g, x } ->
      case g do
        "#" -> nil    # ignore walls
        "." -> %Tile{ id: { x, y }, type: :hall }
        _   -> %Tile{ id: { x, y }, type: :room }
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

end
