defmodule Day08.Digit do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [:code, :graphemes, :value]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def difference(d1, d2) do
    MapSet.difference(d1.graphemes, d2.graphemes)
  end

  def intersection(d1, d2) do
    MapSet.intersection(d1.graphemes, d2.graphemes)
  end

  def is_known?(d) do
    d.value != nil
  end

  def size(d) do
    MapSet.size(d.graphemes)
  end

end
