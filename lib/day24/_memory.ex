defmodule Day24.Memory do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  defstruct [
    w: 0,
    x: 0,
    y: 0,
    z: 0,
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ACCESS HELPERS =============================

  def get(memory, key) do
    case key do
      :w -> memory.w
      :x -> memory.x
      :y -> memory.y
      :z -> memory.z
      _  -> key
    end
  end

  def put(memory, key, value) do
    val = get(memory, value)

    case key do
      :w -> %{ memory | w: val }
      :x -> %{ memory | x: val }
      :y -> %{ memory | y: val }
      :z -> %{ memory | z: val }
      _  -> memory
    end
  end


  # ========== STATE HELPERS ==============================

  def valid?(memory) do
    memory.z == 0
  end

end
