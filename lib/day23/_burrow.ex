defmodule Day23.Burrow do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day23.Critter, as: Critter
  alias Day23.Tile,    as: Tile

  defstruct [
    critters: nil,
    homes:    nil,
    tiles:    nil,
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def lowest_energy(burrow, initial_lowest) do
    find_lowest_energy(MapSet.new([burrow]), 1, initial_lowest)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== ENERGY HELPERS =============================

  defp find_lowest_energy(_, scenario_length, lowest) when scenario_length == 0 do
    lowest
  end

  defp find_lowest_energy(current_scenarios, _, current_lowest) do
    initial_state = { MapSet.new(), current_lowest }

    { scenarios, lowest } =
      current_scenarios
      |> Enum.reduce(initial_state, fn (scenario, { scenarios, lowest }) ->
        { possibles, lowest } =
          scenario
          |> find_possible_moves(Map.values(scenario.critters), [])
          |> Enum.reduce({ MapSet.new(), lowest }, fn ({ critter, tile_id, steps }, { possibles, lowest }) ->
            burrow = move_critter(scenario, critter, tile_id, steps)

            if is_solved?(burrow) do
              if total_energy(burrow) < lowest do
                { possibles, total_energy(burrow) }
              else
                { possibles, lowest }
              end
            else
              { MapSet.put(possibles, burrow), lowest }
            end
          end)

        { MapSet.union(scenarios, possibles), lowest}
      end)

    find_lowest_energy(scenarios, MapSet.size(scenarios), lowest)
  end

  defp total_energy(burrow) do
    burrow.critters
    |> Map.values()
    |> Enum.map(&Critter.energy_consumed/1)
    |> Enum.sum()
  end


  # ========== MOVE HELPERS ===============================

  defp find_possible_moves(_, critters, moves) when length(critters) == 0 do
    moves
  end

  defp find_possible_moves(burrow, current_critters, current_moves) do
    [ critter | critters ] = current_critters

    moves =
      burrow
      |> reachable_tile_ids(critter)
      |> Enum.map(fn { tile_id, steps } ->
        { critter, tile_id, steps }
      end)

    find_possible_moves(burrow, critters, Enum.concat(current_moves, moves))
  end

  def move_critter(burrow, critter, tile_id, steps) do
    critters = Map.delete(burrow.critters, critter.tile_id)

    home_ids   = Critter.home_tile_ids(critter, burrow)
    state      = if Enum.member?(home_ids, tile_id), do: :finish, else: :halfway
    steps      = critter.steps + steps

    critter  = %{ critter | tile_id: tile_id, state: state, steps: steps }
    critters = Map.put(critters, tile_id, critter)

    %{ burrow | critters: critters }
  end


  # ========== TILE HELPERS ===============================

  defp possible_tile_ids(burrow, critter, :halfway) do
    tile_ids  = Critter.home_tile_ids(critter, burrow)
    occupants =
      tile_ids
      |> Enum.map(fn id -> Map.get(burrow.critters, id) end)
      |> Enum.reject(&is_nil/1)

    if Enum.any?(occupants, fn o -> o.type != critter.type end) do
      []                                                    # home not ready yet
    else
      tile_ids
      |> Enum.reject(fn id -> Map.get(burrow.critters, id) end)
      |> Enum.take(1)                                       # take deepest unoccupied
    end
  end

  defp possible_tile_ids(_, _, :finish) do
    []                                                      # no need to move
  end

  defp possible_tile_ids(burrow, _, :start) do
    burrow.tiles
    |> Map.values()
    |> Enum.filter(&Tile.is_hall?/1)                        # cant be door
    |> Enum.reject(fn t -> Tile.occupied?(t, burrow) end)   # cant be occupied
    |> Enum.map(fn t -> t.id end)
    |> Enum.sort()
  end

  defp reachable_tile_ids(burrow, critter) do
    burrow
    |> possible_tile_ids(critter, critter.state)
    |> Enum.map(fn tile_id ->
      path =
        tile_path(critter.tile_id, tile_id)
        |> List.delete(critter.tile_id)

      blockers =
        path
        |> Enum.map(fn id -> Map.get(burrow.critters, id) end)
        |> Enum.reject(&is_nil/1)

      if length(blockers) > 0, do: nil, else: { tile_id, length(path) }
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp tile_path(start_id, finish_id) do
    { _, start_y }  = start_id
    { _, finish_y } = finish_id

    { { hall_x, hall_y }, { home_x, home_y } } =
      if start_y < finish_y do
        { start_id, finish_id }
      else
        { finish_id, start_id }
      end

    hall_to_door = Enum.map(hall_x..home_x, fn x -> { x, hall_y } end)
    door_to_home = Enum.map(hall_y..home_y, fn y -> { home_x, y } end)

    Enum.concat(hall_to_door, door_to_home)
    |> Enum.uniq()
  end


  # ========== STATE HELPERS ==============================

  defp is_solved?(burrow) do
    homes =
      burrow.critters
      |> Enum.reduce(%{}, fn ({ _, c }, acc) ->
        ms = Map.get(acc, c.type) || MapSet.new()
        ms = MapSet.put(ms, c.tile_id)

        Map.put(acc, c.type, ms)
      end)

    homes == burrow.homes
  end

end
