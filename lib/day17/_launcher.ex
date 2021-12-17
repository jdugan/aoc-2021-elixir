defmodule Day17.Launcher do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day17.Probe,  as: Probe
  alias Day17.Target, as: Target

  defstruct [:target]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== TRAJECTORY HELPERS =========================

  def maximum_height(launcher) do
    launcher
    |> accurate_trajectories()
    |> Enum.reduce(nil, fn ({ _, path, _ }, apex) ->
      p_apex =
        path
        |> Enum.map(fn { _, y } -> y end)
        |> Enum.sort()
        |> Enum.at(-1)

      if (apex == nil or p_apex > apex), do: p_apex, else: apex
    end)
  end

  def total_trajectories(launcher) do
    launcher
    |> accurate_trajectories()
    |> length()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== TRAJECTORY HELPERS =========================

  defp accurate_trajectories(launcher) do
    dxs = 1..launcher.target.x_max
    dys = 250..launcher.target.y_min

    Enum.map(dxs, fn dx ->
      Enum.map(dys, fn dy ->
        test_trajectory(launcher, { dx, dy })
      end)
    end)
    |> List.flatten()
    |> Enum.filter(fn { _, _, hit } -> hit end)
  end

  defp test_trajectory(launcher, { dx, dy }) do
    probe = %Probe{ x: 0, y: 0, dx: dx, dy: dy }

    test_trajcetory(launcher, probe, { dx, dy }, [{0,0}], false, false)
  end

  defp test_trajcetory(_, _, initial, path, hit, _) when hit == true do
    { initial, path, true }
  end

  defp test_trajcetory(_, _, initial, path, _, out_of_range) when out_of_range == true do
    { initial, path, false }
  end

  defp test_trajcetory(launcher, probe, initial, path, _, _) do
    probe        = Probe.move(probe)
    path         = [ { probe.x, probe.y } | path ]
    hit          = Target.within?(launcher.target, probe)
    out_of_range = Target.out_of_range?(launcher.target, probe)

    test_trajcetory(launcher, probe, initial, path, hit, out_of_range)
  end

end
