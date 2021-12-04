defmodule Reader do
  # ========== PUBLIC FNS ==================================

  def to_lines(path) do
    {_, raw} = File.read(path)
    raw |> String.split("\n", trim: true)
  end
end