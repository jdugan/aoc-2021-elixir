defmodule Day21.Game do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  # alias __MODULE__
  alias Day21.Pawn, as: Pawn

  defstruct [
    goal:     21,
    pawns:    {},
    rolls:    0,
    winner:   nil,
    versions: 1
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== PLAY HELPERS ===============================

  def play(game, :deterministic) do
    p1   = Map.get(game.pawns, 1)
    p2   = Map.get(game.pawns, 2)
    game = %{ game | goal: 1000 }

    play_deterministically(game, p1.id, p2.id)
  end

  def play(game, :quantum) do
    # 18097631 - too low
    p1     = Map.get(game.pawns, 1)
    p2     = Map.get(game.pawns, 2)
    counts = %{ p1.id => 0, p2.id => 0 }
    games  = [game]

    play_nondeterministically(counts, games, p1.id, p2.id)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== PLAY HELPERS (COMMON) ======================

  defp process_turn(game, pawn_id, distance, versions) do
    pawn  =
      Map.get(game.pawns, pawn_id)
      |> Pawn.move(distance)

    pawns    = Map.put(game.pawns, pawn.id, pawn)
    rolls    = game.rolls + 3
    versions = game.versions * versions

    game = %{ game | pawns: pawns, rolls: rolls, versions: versions }
    if pawn.score >= game.goal do
      %{ game | winner: pawn }
    else
      game
    end
  end


  # ========== PLAY HELPERS (DETERMINISTIC) ===============

  defp play_deterministically(game, _, _) when game.winner != nil do
    checksum(game)
  end

  defp play_deterministically(game, playing_id, waiting_id) do
    distance = roll_deterministically(game)
    game     = process_turn(game, playing_id, distance, 1)

    play_deterministically(game, waiting_id, playing_id)
  end

  defp roll_deterministically(game) do
    3 * ((game.rolls + 3) - 1)
  end


  # ========== PLAY HELPERS (NON-DETERMINISTIC) ===========

  defp roll_nondeterministically() do
    Enum.map(1..3, fn a ->
      Enum.map(1..3, fn b ->
        Enum.map(1..3, fn c ->
          a + b + c
        end)
      end)
    end)
    |> List.flatten()
    |> Enum.frequencies()
  end

  defp play_nondeterministically(counts, games, _, _) when length(games) == 0 do
    counts
    |> Map.values()
    |> Enum.max()
  end

  defp play_nondeterministically(counts, current_games, playing_id, waiting_id) do
    { games, wins }  =
      current_games
      |> Enum.reduce({ [], 0 }, fn (r_game, { r_games, r_wins }) ->
        possible_games =
          roll_nondeterministically()
          |> Enum.map(fn { dist, versions } ->
            process_turn(r_game, playing_id, dist, versions)
          end)

        # { pending_games, win_count } =
        possible_games
        |> Enum.reduce({ r_games, r_wins }, fn (n_game, { n_games, n_wins }) ->
          if n_game.winner != nil do
            { n_games, n_wins + n_game.versions }
          else
            { [ n_game | n_games ], n_wins }
          end
        end)
      end)

    count  = Map.get(counts, playing_id) + wins
    counts = Map.put(counts, playing_id, count)

    play_nondeterministically(counts, games, waiting_id, playing_id)
  end


  # ========== SCORE HELPERS ==============================

  defp checksum(game) do
    p = loser(game)
    p.score * game.rolls
  end

  defp loser(game) do
    p1 = Map.get(game.pawns, 1)
    p2 = Map.get(game.pawns, 2)

    cond do
      game.winner == p1 -> p2
      game.winner == p2 -> p1
      true              -> nil
    end
  end

end
