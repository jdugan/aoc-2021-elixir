defmodule Day24.Computer do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day24.Memory, as: Memory

  defstruct [
    input:   [],
    program: [],
    memory:  %Memory{},
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  def test(computer, input) do
    run(computer, computer.program, input)
    |> print()
  end


  # ========== RUN HELPERS ================================

  def run(computer, program, _) when length(program) == 0 do
    computer
  end

  def run(current_computer, remaining_program, remaining_input) do
    memory                    = current_computer.memory
    [ instruction | program ] = remaining_program

    cmd   = instruction.cmd
    raw_a = instruction.a
    raw_b = instruction.b

    { computer, program, input } =
      if cmd == :inp do
        [ b | input ] = remaining_input
        memory        = Memory.put(memory, raw_a, b)
        computer      = %{ current_computer | memory: memory }

        { computer, program, input }
      else
        { status, response } =
          case cmd do
            :add -> process_add(memory, raw_a, raw_b)
            :div -> process_div(memory, raw_a, raw_b)
            :eql -> process_eql(memory, raw_a, raw_b)
            :mod -> process_mod(memory, raw_a, raw_b)
            :mul -> process_mul(memory, raw_a, raw_b)
          end

        if status == :ok do
          computer = %{ current_computer | memory: response }

          { computer, program, remaining_input }
        else
          computer = %{ current_computer | memory: Memory.put(memory, :z, -400) }

          { computer, [], [] }    # halt loop
        end
      end

    run(computer, program, input)
  end


  # ========== PRINT HELPERS ==============================

  def print(computer) do
    IO.inspect computer.memory
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== INSTRUCTION HELPERS ========================

  # add
  defp process_add(memory, raw_a, raw_b) do
    a = Memory.get(memory, raw_a)
    b = Memory.get(memory, raw_b)

    { :ok, Memory.put(memory, raw_a, a + b) }
  end

  # div
  defp process_div(memory, raw_a, raw_b) do
    a = Memory.get(memory, raw_a)
    b = Memory.get(memory, raw_b)

    case b do
      0 -> { :error, "process_div -> division by zero"}
      _ -> { :ok, Memory.put(memory, raw_a, trunc(a / b)) }
    end
  end

  # eql
  defp process_eql(memory, raw_a, raw_b) do
    a = Memory.get(memory, raw_a)
    b = Memory.get(memory, raw_b)
    v = if (a == b), do: 1, else: 0

    { :ok, Memory.put(memory, raw_a, v) }
  end

  # mod
  defp process_mod(memory, raw_a, raw_b) do
    a = Memory.get(memory, raw_a)
    b = Memory.get(memory, raw_b)

    cond do
      a < 0  -> { :error, "process_mod -> modulus of negative base"}
      b <= 0 -> { :error, "process_mod -> modulus by non-positive value"}
      true   -> { :ok, Memory.put(memory, raw_a, rem(a, b)) }
    end
  end

  # mul
  defp process_mul(memory, raw_a, raw_b) do
    a = Memory.get(memory, raw_a)
    b = Memory.get(memory, raw_b)

    { :ok, Memory.put(memory, raw_a, a * b) }
  end

end
