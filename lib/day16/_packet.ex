defmodule Day16.Packet do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__

  defstruct [
    version:    nil,
    type_id:    nil,
    value:      nil,
    subpackets: []
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== PARSE HELPERS ==============================

  def decode(binary_string) do
    { packets, _ } = parse(binary_string, [])

    Enum.at(packets, 0)
  end


  # ========== COUNT HELPERS ==============================

  def evaluate(packet) do
    packet.value
  end

  def sum_versions(packet) do
    packet.subpackets
    |> Enum.reduce(packet.version, fn (sp, sum) ->
      sum + Packet.sum_versions(sp)
    end)
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== PARSING HELPERS ============================

  defp parse(binary_string, acc) do
    { packet, rem } = parse_string(binary_string)
    list            = [ packet | acc ]

    if String.length(rem) > 0 do
      parse(rem, list)
    else
      { list, rem }
    end
  end

  defp parse_body(body, 4) do
    { binary_partials, _ } =
      body
      |> String.graphemes()
      |> Enum.chunk_every(5, 5, :discard)
      |> Enum.reduce({ [], false }, fn ([ prefix | bits ], { partials, end_found }) ->
        if end_found do
          { partials, true }
        else
          ps  = [ Enum.join(bits) | partials ]
          eof = if (prefix == "0"), do: true, else: false
          { ps, eof }
        end
      end)

    value =
      binary_partials
      |> Enum.reverse()
      |> Enum.join()
      |> Conversion.binary_string_to_decimal()

    remainder =
      body
      |> String.slice(length(binary_partials)*5..-1//1)
      |> scrub_remainder()

    { value, [], remainder }
  end

  defp parse_body(body, _) do
    { len_type, msg } = match_string(body, ~r/^(\d)(\d+)$/)

    if len_type == "0" do
      { sp_len0, str0 } = match_string(msg, ~r/^(\d{15})(\d+)$/)

      sp_len    = Conversion.binary_string_to_decimal(sp_len0)
      b_str     = String.slice(str0, 0, sp_len)
      { sp, _ } = parse(b_str, [])
      remainder = String.slice(str0, sp_len..-1//1) |> scrub_remainder()

      { nil, Enum.reverse(sp), remainder }
    else
      { sp_num0, str0 } = match_string(msg, ~r/^(\d{11})(\d+)$/)

      sp_num    = Conversion.binary_string_to_decimal(sp_num0)
      { sp, remainder } =
        1..sp_num
        |> Enum.reduce({ [], str0 }, fn (_, { r_sp, r_rem }) ->
          { p, r } = parse_string(r_rem)

          { [ p | r_sp ], r }
        end)

      { nil, Enum.reverse(sp), remainder }
    end
  end

  defp parse_string(binary_string) do
    { bv, bt_id, body } =
      match_string(binary_string, ~r/^(\d{3})(\d{3})(\d+)$/)

    version      = Conversion.binary_string_to_decimal(bv)
    type_id      = Conversion.binary_string_to_decimal(bt_id)
    { v, sp, r } = parse_body(body, type_id)
    value        =
      if type_id == 4 do
        v
      else
        evaluate_subpackets(sp, type_id)
      end

    packet = %Packet{
      version:    version,
      type_id:    type_id,
      value:      value,
      subpackets: sp
    }

    { packet, r }
  end

  # ========== VALUE HELPERS ==============================

  defp evaluate_subpackets(subpackets, 0) do
    subpackets
    |> Enum.map(fn sp -> sp.value end)
    |> Enum.sum()
  end

  defp evaluate_subpackets(subpackets, 1) do
    subpackets
    |> Enum.map(fn sp -> sp.value end)
    |> Enum.product()
  end

  defp evaluate_subpackets(subpackets, 2) do
    subpackets
    |> Enum.map(fn sp -> sp.value end)
    |> Enum.min()
  end

  defp evaluate_subpackets(subpackets, 3) do
    subpackets
    |> Enum.map(fn sp -> sp.value end)
    |> Enum.max()
  end

  defp evaluate_subpackets(subpackets, 5) do
    p0 = subpackets |> Enum.at(0)
    p1 = subpackets |> Enum.at(1)

    if p0.value > p1.value, do: 1, else: 0
  end

  defp evaluate_subpackets(subpackets, 6) do
    p0 = subpackets |> Enum.at(0)
    p1 = subpackets |> Enum.at(1)

    if p0.value < p1.value, do: 1, else: 0
  end

  defp evaluate_subpackets(subpackets, 7) do
    p0 = subpackets |> Enum.at(0)
    p1 = subpackets |> Enum.at(1)

    if p0.value == p1.value, do: 1, else: 0
  end


  # ========== UTILITY HELPERS ============================

  defp match_string(str, regex) do
    Regex.run(regex, str)
    |> Enum.drop(1)
    |> List.to_tuple()
  end

  defp scrub_remainder(remainder) do
    zeroes =
      remainder
      |> String.graphemes()

    if Enum.all?(zeroes, &(&1 == "0")) do
      ""
    else
      remainder
    end
  end

end
