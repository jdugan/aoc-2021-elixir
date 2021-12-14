defmodule Day12.Path do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__

  defstruct nodes: [], restricted_nodes: MapSet.new(), restricted_type: nil


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ACTION HELPERS =============================

  def add_node(path, node) do
    nodes = [ node | path.nodes ]
    r_nodes =
      if is_restrictable_node?(node) do
        MapSet.put(path.restricted_nodes, node)
      else
        path.restricted_nodes
      end
    r_type =
      if MapSet.member?(path.restricted_nodes, node) do
        :anxious
      else
        path.restricted_type
      end

    %Path{ nodes: nodes, restricted_nodes: r_nodes, restricted_type: r_type }
  end


  # ========== ANALYSIS HELPERS ===========================

  def classify_nodes(path, nodes) do
    end_nodes =
      nodes
      |> Enum.filter(fn n -> n == "end" end)

    possible_nodes =
      nodes
      |> Enum.reject(fn n ->
        if path.restricted_type == :bold do
          n == "start" or n == "end"
        else
          MapSet.member?(path.restricted_nodes, n)
        end
      end)

    { end_nodes, possible_nodes }
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  def is_restrictable_node?(node) do
    Regex.match?(~r/^[a-z]+$/, node)
  end

end
