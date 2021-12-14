defmodule Day12.CaveSystem do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day12.Path, as: Path

  defstruct caves: %{}


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def count_paths(cs, restricted_type) do
    start_path = %Path{
      nodes:            ["start"],
      restricted_nodes: MapSet.new(["start","end"]),
      restricted_type:  restricted_type
    }

    explore(cs, [start_path], 0)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== NAVIGATION HELPERS =========================

  defp explore(_, paths, count) when length(paths) == 0  do
    count
  end

  defp explore(cs, paths, count) do
    initial_state = { [], count }

    { n_paths, n_count } =
      paths
      |> Enum.reduce(initial_state, fn (path, { acc_paths, acc_count }) ->
        node = Enum.at(path.nodes, 0)
        cave = find_cave_by_node(cs, node)

        { end_nodes, possible_nodes } =
          Path.classify_nodes(path, cave.connected_nodes)

        r_paths =
          possible_nodes
          |> Enum.reduce(acc_paths, fn (n, acc) ->
            np  = Path.add_node(path, n)
            [ np | acc ]
          end)

        r_count = acc_count + length(end_nodes)

        { r_paths, r_count }
      end)

    explore(cs, n_paths, n_count)
  end

  defp find_cave_by_node(cs, node) do
    Map.fetch!(cs.caves, node)
  end

end
