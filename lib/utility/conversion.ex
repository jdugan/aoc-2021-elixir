defmodule Conversion do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  @hex_char_to_binary_string_map %{
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
  }


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def binary_array_to_decimal(digits) do
    Enum.reverse(digits)
    |> Enum.with_index
    |> Enum.reduce(0, fn({n, i}, acc) ->
      if n == 1 do
        acc + (:math.pow(2, i)) |> trunc
      else
        acc
      end
    end)
  end

  def binary_string_to_decimal(binary_string) do
    binary_string
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> binary_array_to_decimal()
  end

  def hex_char_to_binary_string(hex_char) do
    Map.get(@hex_char_to_binary_string_map, hex_char)
  end

  def hex_string_to_binary_string(hex_string) do
    hex_string
    |> String.graphemes()
    |> Enum.map(fn g -> hex_char_to_binary_string(g) end)
    |> Enum.join()
  end

end
