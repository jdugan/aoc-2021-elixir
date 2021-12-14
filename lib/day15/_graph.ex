defmodule Day15.Graph do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__
  alias Day15.Point, as: Point

  defstruct points: %{}, max_distance: 0


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== DJIKSTRA HELPERS ===========================

  def shortest_distance(graph) do
    graph = apply_adjacency(graph)
    d_map = initial_distance_map(graph)
    c_map = initial_calculated_map()
    v_ids = MapSet.new([origin_id()])

    map = traverse(graph.points, d_map, c_map, v_ids)
    id  = terminus_id(graph)

    Map.get(map, id)
  end


  # ========== POINT HELPERS ==============================

  # TODO: Make this nicer, driven by an argument.
  #
  def expand(graph) do
    { x_size, y_size } = max_dimensions(graph)

    x0 = graph
    x1 = increment(x0, :x, x_size)
    x2 = increment(x1, :x, x_size)
    x3 = increment(x2, :x, x_size)
    x4 = increment(x3, :x, x_size)
    x_points =
      x0.points
      |> Map.merge(x1.points)
      |> Map.merge(x2.points)
      |> Map.merge(x3.points)
      |> Map.merge(x4.points)

    y0 = %Graph{ points: x_points, max_distance: map_size(x_points) * 10 }
    y1 = increment(y0, :y, y_size)
    y2 = increment(y1, :y, y_size)
    y3 = increment(y2, :y, y_size)
    y4 = increment(y3, :y, y_size)
    y_points =
      y0.points
      |> Map.merge(y1.points)
      |> Map.merge(y2.points)
      |> Map.merge(y3.points)
      |> Map.merge(y4.points)

    %Graph{ points: y_points, max_distance: map_size(y_points) * 10 }
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== DJIKSTRA HELPERS ===========================

  defp calculate_distances(point_map, distance_map, calculated_map, visited_ids, visit_id) do
    visit_dist  = Map.get(distance_map, visit_id)
    visit_point = Map.get(point_map, visit_id)
    visited_ids = MapSet.put(visited_ids, visit_id)

    initial_state = { distance_map, calculated_map }

    { d_map, c_map } =
      visit_point.adjacent_ids
      |> Enum.reject(fn id -> MapSet.member?(visited_ids, id) end)
      |> Enum.reduce(initial_state, fn (a_id, { d_map, c_map }) ->
        a_point = Map.get(point_map, a_id)
        a_dist  = visit_dist + a_point.value

        d_dist = Map.get(d_map, a_id)
        d_map =
          if d_dist > a_dist do
            Map.put(d_map, a_id, a_dist)
          else
            d_map
          end

        c_dist = Map.get(c_map, a_id)
        c_map =
          if c_dist == nil or c_dist > a_dist do
            Map.put(c_map, a_id, a_dist)
          else
            c_map
          end

        { d_map, c_map }
      end)

    { d_map, Map.delete(c_map, visit_id), visited_ids }
  end

  defp minimum_pair(calculated_map) do
    calculated_map
    |> Enum.sort(fn ({ _, d1 }, { _, d2 }) ->
      d1 < d2
    end)
    |> Enum.at(0)
  end

  defp traverse(_, distance_map, calculated_map, _) when map_size(calculated_map) == 0 do
    distance_map
  end

  defp traverse(point_map, distance_map, calculated_map, visited_ids) do
    { v_id, _ } =
      minimum_pair(calculated_map)
      
    { d_map, c_map, v_ids } =
      calculate_distances(
        point_map,
        distance_map,
        calculated_map,
        visited_ids,
        v_id
      )

    traverse(point_map, d_map, c_map, v_ids)
  end


  # ========== INITIALISATION HELPERS =====================

  defp initial_calculated_map() do
    Map.new()
    |> Map.put(origin_id(), 0)
  end

  defp initial_distance_map(graph) do
    graph.points
    |> Map.keys()
    |> Enum.reduce(Map.new(), fn (id, acc) ->
      Map.put(acc, id, graph.max_distance)
    end)
    |> Map.put(origin_id(), 0)
  end


  # ========== POINT HELPERS ==============================

  defp apply_adjacency(graph) do
    points =
      graph.points
      |> Enum.reduce(Map.new(), fn ({ id, p }, acc) ->
        a_ids =
          p
          |> Point.possible_adjacent_ids()
          |> Enum.filter(fn a_id ->
            Map.has_key?(graph.points, a_id)
          end)

        Map.put(acc, id, %{ p | adjacent_ids: a_ids })
      end)

    %{ graph | points: points }
  end

  defp origin_id() do
    { 0, 0 }
  end

  defp max_dimensions(graph) do
    { x, y } = terminus_id(graph)

    { x + 1, y + 1 }
  end

  defp terminus_id(graph) do
    keys = Map.keys(graph.points)
    xmax = keys |> Enum.map(fn { x, _ } -> x end) |> Enum.max()
    ymax = keys |> Enum.map(fn { _, y } -> y end) |> Enum.max()

    { xmax, ymax }
  end


  # ========== TILE HELPERS ===============================

  defp increment(graph, axis, size) do
    points =
      graph.points
      |> Enum.reduce(Map.new(), fn ({ _, p }, acc) ->
        id           = Point.increment_id(p.id, axis, size)
        adjacent_ids = Point.increment_adjacent_ids(p.adjacent_ids, axis, size)
        value        = Point.increment_value(p.value)

        point = %Point{
          id:           id,
          adjacent_ids: adjacent_ids,
          value:        value
        }

        Map.put(acc, point.id, point)
      end)

    %{ graph | points: points }
  end

end
