defmodule Day12.CaveSystem do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day12.Cave, as: Cave

  defstruct caves: %{}, terminals: {}


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ATTRIBUTES =================================

  def set_terminals(cs) do
    start_cave = find_start_cave(cs)
    end_cave   = find_end_cave(cs)

    %{ cs | terminals: { start_cave, end_cave } }
  end


  # ========== COUNT HELPERS ==============================

  def count_paths(cs, :anxious) do
    { start_cave, _ } = cs.terminals
    complete_paths    = MapSet.new()
    working_paths     = [[start_cave]]

    explore(cs, cs.terminals, &anxious_reducer/3, complete_paths, working_paths)
    |> MapSet.size()
  end

  def count_paths(cs, :bold) do
    { start_cave, _ } = cs.terminals
    complete_paths    = MapSet.new()
    working_paths     = [[start_cave]]

    explore(cs, cs.terminals, &bold_reducer/3, complete_paths, working_paths)
    |> MapSet.size()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== NAVIGATION HELPERS =========================

  defp explore(_, _, _, complete_paths, working_paths) when length(working_paths) == 0  do
    complete_paths
  end

  defp explore(cs, { start_cave, end_cave }, restricted_reducer, complete_paths, working_paths) do
    initial_state = { complete_paths, [] }

    { nc_paths, nw_paths } =
      working_paths
      |> Enum.reduce(initial_state, fn (path, { c_paths, w_paths }) ->
        current_cave     = Enum.at(path, 0)
        restricted_caves = restricted_reducer.(path, start_cave, end_cave)

        all_steps =
          current_cave.connected_nodes
          |> Enum.map(fn n -> find_cave_by_node(cs, n) end)
        end_step =
          all_steps
          |> Enum.find(&Cave.is_end?/1)
        possible_steps =
          all_steps
          |> Enum.reject(fn c ->
            MapSet.member?(restricted_caves, c)
          end)

        rc_paths =
          if end_step do
            ep = [ end_step | path ]
            MapSet.put(c_paths, ep)
          else
            c_paths
          end

        rw_paths =
          possible_steps
          |> Enum.reduce(w_paths, fn (c, acc) ->
            np = [ c | path ]
            [ np | acc ]
          end)

        { rc_paths, rw_paths}
      end)

    explore(cs, { start_cave, end_cave }, restricted_reducer, nc_paths, nw_paths)
  end

  defp find_cave_by_node(cs, node) do
    Map.fetch!(cs.caves, node)
  end

  defp find_end_cave(cs) do
    find_cave_by_node(cs, "end")
  end

  defp find_start_cave(cs) do
    find_cave_by_node(cs, "start")
  end


  # ========== VISITED HELPERS ============================

  defp anxious_reducer(path, _, end_cave) do
    [ end_cave | path ]
    |> Enum.reject(&Cave.is_large?/1)
    |> MapSet.new()
  end

  defp bold_reducer(path, start_cave, end_cave) do
    anxious =
      [ end_cave | path ]
      |> Enum.reject(&Cave.is_large?/1)

    max =
      anxious
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.max()

    if max > 1 do
      anxious
      |> MapSet.new()
    else
      [ start_cave, end_cave ]
      |> MapSet.new()
    end
  end

end
