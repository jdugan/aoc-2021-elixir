defmodule Day14.Machine do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__

  defstruct char_map: %{}, chunk_map: %{}, rules: %{}


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def frequency_range(machine) do
    vals =
      machine.char_map
      |> Map.values()
      |> Enum.sort()

    min = Enum.at(vals, 0)
    max = Enum.at(vals, -1)

    max - min
  end


  # ========== CYCLE HELPERS ==============================

  def process_cycles(machine, cycles) do
    chunks = machine.chunk_map
    chars  = machine.char_map
    rules  = machine.rules

    process_cycles(chunks, chars, rules, cycles)
  end

  def process_cycles(chunks, chars, rules, cycles) when cycles < 1 do
    %Machine{ char_map: chars, chunk_map: chunks, rules: rules }
  end

  def process_cycles(current_chunks, current_chars, rules, cycles) do
    initial_state = { current_chars, current_chunks }

    { chars, chunks } =
      current_chunks
      |> Enum.reduce(initial_state, fn ({ chunk, chunk_count }, { char_map, chunk_map }) ->
        chunk_parts = String.graphemes(chunk)
        chunk_first = Enum.at(chunk_parts, 0)
        chunk_last  = Enum.at(chunk_parts, -1)

        insert_char = Map.get(rules, chunk)
        new_chunk1  = "#{ chunk_first }#{ insert_char }"
        new_chunk2  = "#{ insert_char }#{ chunk_last }"

        new_char_map  =
          char_map
          |> increment_by_count(insert_char, chunk_count)
        new_chunk_map =
          chunk_map
          |> increment_by_count(new_chunk1, chunk_count)
          |> increment_by_count(new_chunk2, chunk_count)
          |> decrement_by_count(chunk, chunk_count)
          |> Enum.reject(fn ({ _, v }) -> v == 0 end)
          |> Map.new()

        { new_char_map, new_chunk_map }
      end)

    process_cycles(chunks, chars, rules, cycles - 1)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== CYCLE HELPERS ==============================

  defp decrement_by_count(map, key, count) do
    current   = Map.get(map, key, 0)
    new_count = if (current - count < 1), do: 0, else: current - count

    Map.put(map, key, new_count)
  end

  defp increment_by_count(map, key, count) do
    current = Map.get(map, key, 0)
    Map.put(map, key, current + count)
  end

end
