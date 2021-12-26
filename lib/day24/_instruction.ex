defmodule Day24.Instruction do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__

  defstruct [
    cmd: nil,
    a:   nil,
    b:   nil
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def cast(str) do
    case str do
      nil -> nil
      "w" -> :w
      "x" -> :x
      "y" -> :y
      "z" -> :z
      _   -> String.to_integer(str)
    end
  end

  def parse(str) do
    { cmd, a, b } =
      Regex.run(~r/^(\w+) (\w+)\s?(-?\w+)?$/, str)
      |> Enum.drop(1)
      |> Enum.concat([nil])
      |> Enum.take(3)
      |> List.to_tuple()

      %Instruction{
        cmd: String.to_atom(cmd),
        a:   cast(a),
        b:   cast(b)
      }
  end

end
