defmodule Day09.Basin do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day09.Coord, as: Coord

  defstruct [:nadir, :coords]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ATTRIBUTES =================================

  def size(basin) do
    MapSet.size(basin.coords)
  end


  # ========== ACTIONS ====================================

  def expand(basin, sea_floor) do
    found  = MapSet.new([basin.nadir])
    check  = MapSet.new([basin.nadir])
    coords = find_coords(sea_floor, found, check)

    Map.put(basin, :coords, coords)
  end


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  defp find_coords(_, found_coords, check_coords) when length(check_coords) == 0 do
    found_coords
  end

  defp find_coords(sea_floor, found_coords, check_coords) do
    initial_state = { found_coords, MapSet.new() }
    
    { found, check } =
      check_coords
      |> Enum.reduce(initial_state, fn (c_coord, { f_mapset, c_mapset }) ->
        a_mapset =
          Coord.adjacent_coords(sea_floor, c_coord)
          |> Enum.reject(fn c ->
            !Coord.drainable?(c) or MapSet.member?(f_mapset, c)
          end)
          |> MapSet.new

        {
          MapSet.union(f_mapset, a_mapset),
          MapSet.union(c_mapset, a_mapset)
        }
      end)

    find_coords(sea_floor, found, MapSet.to_list(check))
  end

end
