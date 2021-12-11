defmodule Day11.Cave do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day11.Octopus, as: Octopus

  defstruct cycle_count: 0, flash_count: 0, octopuses: nil


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def count_cycles_until_sync(cave) do
    total   = map_size(cave.octopuses)
    flashed = length(collect_flashed(cave))

    iterate_until_sync(cave, total, flashed)
  end

  def count_flashes(cave, cycles_remaining) when cycles_remaining < 1 do
    cave.flash_count
  end

  def count_flashes(current_cave, cycles_remaining) do
    cave = iterate(current_cave)

    count_flashes(cave, cycles_remaining - 1)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== CYCLE HELPERS ==============================

  defp iterate(current_cave) do
    cave    = process_gain(current_cave)
    flashed = MapSet.new()
    ready   = collect_flashable(cave)
    cave    = process_flashes(cave, flashed, ready)

    %{ cave | cycle_count: cave.cycle_count + 1 }
  end

  defp iterate_until_sync(current_cave, total, flashed) when total == flashed do
    current_cave.cycle_count
  end

  defp iterate_until_sync(current_cave, total, _) do
    cave          = iterate(current_cave)
    flashed_count = collect_flashed(cave) |> length()

    iterate_until_sync(cave, total, flashed_count)
  end

  defp process_flashes(cave, flashed, ready) when length(ready) == 0 do
    flashes = cave.flash_count + MapSet.size(flashed)

    %{ cave | flash_count: flashes }
  end

  defp process_flashes(current_cave, current_flashed, current_ready) do
    initial_state = { current_cave, current_flashed, MapSet.new() }

    { cave, flashed, ready } =
      current_ready
      |> Enum.reduce(initial_state, fn (r_octopus, { c, f_mapset, r_mapset }) ->
        {
          updated_cave,
          flashed_octopus,
          ready_neighbors
        } =
          Octopus.flash(r_octopus, c)

        {
          updated_cave,
          MapSet.put(f_mapset, flashed_octopus),
          MapSet.union(r_mapset, ready_neighbors)
        }
      end)

    process_flashes(cave, flashed, MapSet.to_list(ready))
  end

  defp process_gain(cave) do
    os =
      cave.octopuses
      |> Enum.reduce(%{}, fn ({c, o}, acc) ->
        Map.put(acc, c, Octopus.grow(o))
      end)

    %{ cave | octopuses: os}
  end


  # ========== OCTOPUS HELPERS ============================

  defp collect_flashable(cave) do
    cave.octopuses
    |> Map.values
    |> Enum.filter(fn o -> Octopus.flashable?(o) end)
  end

  defp collect_flashed(cave) do
    cave.octopuses
    |> Map.values
    |> Enum.filter(fn o -> Octopus.flashed?(o) end)
  end


  # ========== PRINT HELPERS ==============================

  # defp print(cave) do
  #   IO.puts ""
  #   IO.puts "-----------------------------"
  #   IO.puts "Cycle: #{ cave.cycle_count }, Flashes: #{ cave.flash_count }"
  #   IO.puts "-----------------------------"
  #   to_printable_list(cave)
  #   |> Enum.each(fn row ->
  #     levels = Enum.map(row, fn o -> o.energy end)
  #     IO.puts Enum.join(levels)
  #   end)
  #   IO.puts "-----------------------------"
  #   IO.puts ""
  # end
  #
  # defp print_dimension_ranges(cave) do
  #   keys = Map.keys(cave.octopuses)
  #   xmax = keys |> Enum.map(fn { x, _ } -> x end) |> Enum.max
  #   ymax = keys |> Enum.map(fn { _, y } -> y end) |> Enum.max
  #
  #   { Enum.to_list(0..xmax), Enum.to_list(0..ymax) }
  # end
  #
  # defp to_printable_list(cave) do
  #   { xs, ys } = print_dimension_ranges(cave)
  #
  #   Enum.map(ys, fn y ->
  #     Enum.map(xs, fn x ->
  #       Map.get(cave.octopuses, { x, y })
  #     end)
  #   end)
  # end

end
