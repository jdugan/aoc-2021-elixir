defmodule Day12.Cave do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct node: nil, connected_nodes: MapSet.new()


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== MAP HELPERS ================================

  def add_connected_node(cave, node) do
    cnodes = MapSet.put(cave.connected_nodes, node)

    %{ cave | connected_nodes: cnodes }
  end

end
