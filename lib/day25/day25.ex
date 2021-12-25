defmodule Day25 do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day25.Critter,  as: Critter
  alias Day25.SeaFloor, as: SeaFloor
  alias Day25.Tile,     as: Tile


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def both do
    IO.puts(" ")
    IO.puts("DAY 25")
    IO.puts("  Puzzle 1 => #{ puzzle1() }")
    IO.puts("  Puzzle 2 => Freebie!")
    IO.puts(" ")
  end

  def puzzle1 do
    data()
    |> SeaFloor.count_cycles()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DATA HELPERS ===============================

  defp data do
    lines = Reader.to_lines("./data/day25/input.txt")

    critters = parse_critter_lines(lines)
    tiles    = parse_tile_lines(lines)

    %SeaFloor{ critters: critters, tiles: tiles }
  end

  defp parse_critter_lines(lines) do
    lines
    |> Enum.with_index
    |> Enum.flat_map(&parse_critter_line/1)
    |> Enum.reduce(%{}, fn (c, acc) ->
      Map.put(acc, c.tile_id, c)
    end)
  end

  defp parse_critter_line({ line, y }) do
    line
    |> String.graphemes
    |> Enum.with_index
    |> Enum.map(fn { g, x } ->
      case g do
        ">" -> %Critter{ type: :east,  tile_id: { x, y } }
        "v" -> %Critter{ type: :south, tile_id: { x, y } }
        _   -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_tile_lines(lines) do
    lines
    |> Enum.with_index
    |> Enum.flat_map(&parse_tile_line/1)
    |> Enum.reduce(%{}, fn (t, acc) ->
      Map.put(acc, t.id, t)
    end)
    |> repair_tiles_at_eastern_edge()
    |> repair_tiles_at_southern_edge()
  end

  defp parse_tile_line({ line, y }) do
    line
    |> String.graphemes
    |> Enum.with_index
    |> Enum.map(fn { _, x } ->
        %Tile{
          id:       { x, y },
          east_id:  { x + 1, y },
          south_id: { x, y + 1 }
        }
    end)
  end

  defp repair_tiles_at_eastern_edge(tiles) do
    tiles
    |> Enum.reduce(%{}, fn ({ _, t }, acc) ->
      e_tile = Map.get(tiles, t.east_id)

      if e_tile do
        Map.put(acc, t.id, t)
      else
        { _, y } = t.east_id
        Map.put(acc, t.id, %{ t | east_id: { 0, y } })
      end
    end)
  end

  defp repair_tiles_at_southern_edge(tiles) do
    tiles
    |> Enum.reduce(%{}, fn ({ _, t }, acc) ->
      s_tile = Map.get(tiles, t.south_id)

      if s_tile do
        Map.put(acc, t.id, t)
      else
        { x, _ } = t.south_id
        Map.put(acc, t.id, %{ t | south_id: { x, 0 } })
      end
    end)
  end

end
