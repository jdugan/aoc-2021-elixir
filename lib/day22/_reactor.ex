defmodule Day22.Reactor do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day22.Instruction, as: Instruction

  defstruct [
    cubesets:     [],
    instructions: []
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def count_cubes(reactor) do
    reactor.cubesets
    |> Enum.map(fn c -> Instruction.size(c) end)
    |> Enum.sum()
  end


  # ========== INSTRUCTION HELPERS ========================

  def boot(reactor) do
    reactor
    |> apply_instructions()
  end

  def initialise(reactor) do
    reactor
    |> filter_instructions(:initialisation)
    |> apply_instructions()
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== COLLECTION HELPERS =========================

  defp filter_instructions(reactor, :initialisation) do
    list =
      reactor.instructions
      |> Enum.filter(fn i ->
        (-50 <= i.x_min and i.x_max <= 50) and
        (-50 <= i.y_min and i.y_max <= 50) and
        (-50 <= i.z_min and i.z_max <= 50)
      end)

    %{ reactor | instructions: list }
  end


  # ========== SET HELPERS ================================

  defp apply_instructions(reactor) do
    cubesets =
      reactor.instructions
      |> Enum.reduce(reactor.cubesets, fn (i, acc) ->
        if i.state == "on" do
          apply_add(i, acc)
        else
          apply_remove(i, acc)
        end
      end)

    %{ reactor | cubesets: cubesets }
  end

  defp apply_add(instruction, cubesets) do
    additions = Instruction.add(instruction, cubesets)

    if length(additions) > 0 do
      Enum.concat(cubesets, additions)
    else
      cubesets
    end
  end

  defp apply_remove(instruction, cubesets) do
    Instruction.remove(instruction, cubesets)
  end

end
