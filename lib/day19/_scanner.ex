defmodule Day19.Scanner do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [
    id:       nil,
    position: nil,
    datasets: []
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== CALCULATION HELPERS ========================

  def count_beacons(scanners) do
    { combined, _ } = align(scanners)

    combined.datasets
    |> List.first()
    |> length()
  end

  def largest_spread(scanners) do
    { _, matched_map } = align(scanners)

    matched_map
    |> Map.values()
    |> generate_origin_permutations()
    |> Enum.map(&manhattan_distance/1)
    |> Enum.max()
  end


  # ========== STATE HELPERS ==============================

  def origin?(scanner) do
    scanner.position == { 0, 0, 0 }
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== ALIGNMENT HELPERS ==========================

  def align(scanners) do
    [ s0 | unmatched_scanners ] = scanners

    combined_scanner = %{ s0 | id: "combined" }
    matched_map      = %{ s0.id => s0.position }

    align_scanners(combined_scanner, matched_map, unmatched_scanners)
  end

  defp align_scanners(combined, matched, unmatched) when length(unmatched) == 0 do
    { combined, matched }
  end

  defp align_scanners(combined, matched, unmatched) do
    { new_combined, new_matched, new_unmatched } =
      unmatched
      |> Enum.reduce({ combined, matched, unmatched }, fn (r_scanner, { r_combined, r_matched, r_unmatched }) ->
        { m_dataset, m_offset } = match_scanners(r_combined, r_scanner)

        if m_dataset do
          sm_dataset   = shift_dataset(m_dataset, m_offset)
          rc_dataset  = Enum.at(r_combined.datasets, 0)
          nc_dataset  = Enum.concat(rc_dataset, sm_dataset) |> Enum.uniq() |> Enum.sort()
          n_combined  = %{ r_combined | datasets: [nc_dataset] }

          n_scanner   = %{ r_scanner | position: m_offset, datasets: [m_dataset] }
          n_matched   = Map.put(r_matched, n_scanner.id, m_offset)

          n_unmatched = List.delete(r_unmatched, r_scanner)

          { n_combined, n_matched, n_unmatched }
        else
          { r_combined, r_matched, r_unmatched }
        end
      end)

    align_scanners(new_combined, new_matched, new_unmatched)
  end

  defp generate_dataset_permutations(ds0, ds1) do
    ds0
    |> Enum.map(fn p0 ->
      Enum.map(ds1, fn p1 ->
        { p0, p1 }
      end)
    end)
    |> List.flatten()
  end

  defp match_datasets(ds0, ds1) do
    ds_perms = generate_dataset_permutations(ds0, ds1)

    { max_offset, max_freq} =
      ds_perms
      |> Enum.map(fn { { x0, y0, z0 }, { x1, y1, z1 } } ->
        { x0 - x1, y0 - y1, z0 - z1 }
      end)
      |> Enum.frequencies()
      |> Enum.reduce({ nil, 0 }, fn ({ k, v }, { r_offset, r_freq }) ->
        if v > r_freq do
          { k, v }
        else
          { r_offset, r_freq }
        end
      end)

    if max_freq > 11 do
      { ds1, max_offset }
    else
      { nil, nil }
    end
  end

  defp match_scanners(combined, scanner) do
    c_dataset = Enum.at(combined.datasets, 0)

    scanner.datasets
    |> Enum.reduce({ nil, nil }, fn (ds, { m_dataset, m_offset }) ->
      if m_dataset == nil do
        match_datasets(c_dataset, ds)
      else
        { m_dataset, m_offset }
      end
    end)
  end

  defp shift_dataset(dataset, { dx, dy, dz }) do
    dataset
    |> Enum.reduce([], fn ({ x, y, z }, acc) ->
      [ { x + dx, y + dy, z + dz } | acc ]
    end)
  end


  # ========== DISTANCE HELPERS ===========================

  defp generate_origin_permutations(list) do
    [head | tail ] = list

    generate_origin_permutations([], head, tail)
  end

  defp generate_origin_permutations(list, _, other_points) when length(other_points) == 0 do
    list
  end

  defp generate_origin_permutations(list, point, other_points) do
    sublist   = Enum.map(other_points, fn op -> { point, op } end)
    new_list  = [ sublist | list ] |> List.flatten()
    [ h | t ] = other_points

    generate_origin_permutations(new_list, h, t)
  end

  def manhattan_distance({ { x0, y0, z0 }, { x1, y1, z1 } }) do
    dx = abs(x0 - x1)
    dy = abs(y0 - y1)
    dz = abs(z0 - z1)

    dx + dy + dz
  end

end
