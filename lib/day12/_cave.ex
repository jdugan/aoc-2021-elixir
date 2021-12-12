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


  # ========== STATE HELPERS ==============================

  def is_end?(cave) do
    cave.node == "end"
  end

  def is_large?(cave) do
    Regex.match?(~r/^[A-Z]+$/, cave.node)
  end

  def is_small?(cave) do
    Regex.match?(~r/^[a-z]+$/, cave.node) and
      !(is_start?(cave) or is_end?(cave))
  end

  def is_start?(cave) do
    cave.node == "start"
  end

  def is_terminus?(cave) do
    is_start?(cave) or is_end?(cave)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------


end
