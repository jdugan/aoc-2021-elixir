defmodule Day25.SeaFloor do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__
  alias Day25.Critter, as: Critter
  alias Day25.Tile,    as: Tile

  defstruct [
    critters: [],
    tiles:    []
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def count_cycles(sea_floor) do
    tiles    = sea_floor.tiles
    critters = sea_floor.critters
    wanderers = find_wanderers(tiles, critters)

    process_cycle(tiles, critters, wanderers, 0)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== CYCLE HELPERS ==============================

  defp find_wanderers(tiles, critters) do
    critters
    |> Enum.reduce([], fn ({ _, c }, acc) ->
      tile = Critter.next_tile(c, tiles)
      if Tile.open?(tile, critters) do
        [ c | acc ]
      else
        acc
      end
    end)
  end

  defp process_cycle(_, _, wanderers, cycles) when length(wanderers) == 0 do
    cycles + 1
  end

  defp process_cycle(tiles, current_critters, current_wanderers, cycles) do
    # move east
    critters =
      current_wanderers
      |> Enum.filter(fn c -> c.type == :east end)
      |> Enum.reduce(current_critters, fn (w, acc) ->
        next_tile = Critter.next_tile(w, tiles)

        Map.delete(acc, w.tile_id)
        |> Map.put(next_tile.id, %{ w | tile_id: next_tile.id })
      end)
    wanderers = find_wanderers(tiles, critters)

    # move south
    critters =
      wanderers
      |> Enum.filter(fn c -> c.type == :south end)
      |> Enum.reduce(critters, fn (w, acc) ->
        next_tile = Critter.next_tile(w, tiles)

        Map.delete(acc, w.tile_id)
        |> Map.put(next_tile.id, %{ w | tile_id: next_tile.id })
      end)
    wanderers = find_wanderers(tiles, critters)

    process_cycle(tiles, critters, wanderers, cycles + 1)
  end


  # ========== PRINT HELPERS ==============================

  # defp print(sea_floor, cycles) do
  #   IO.puts ""
  #   IO.puts "-----------------------------"
  #   IO.puts "Cycle: #{ cycles }"
  #   IO.puts "-----------------------------"
  #   to_printable_list(sea_floor)
  #   |> Enum.each(fn row ->
  #     IO.puts Enum.join(row)
  #   end)
  #   IO.puts "-----------------------------"
  #   IO.puts ""
  # end
  #
  # defp print_dimension_ranges(sea_floor) do
  #   keys = Map.keys(sea_floor.tiles)
  #   xmax = keys |> Enum.map(fn { x, _ } -> x end) |> Enum.max
  #   ymax = keys |> Enum.map(fn { _, y } -> y end) |> Enum.max
  #
  #   { Enum.to_list(0..xmax), Enum.to_list(0..ymax) }
  # end
  #
  # defp to_printable_list(sea_floor) do
  #   { xs, ys } = print_dimension_ranges(sea_floor)
  #
  #   Enum.map(ys, fn y ->
  #     Enum.map(xs, fn x ->
  #       critter = Map.get(sea_floor.critters, { x, y })
  #
  #       if critter == nil do
  #         "."
  #       else
  #         if critter.type == :east do
  #           ">"
  #         else
  #           "v"
  #         end
  #       end
  #     end)
  #   end)
  # end

end
