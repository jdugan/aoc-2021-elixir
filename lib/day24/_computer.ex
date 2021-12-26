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

  def debug(computer, z0, input) do
    m = %{ computer.memory | z: z0 }
    c = %{ computer | memory: m }

    run(c, c.program, input, true)
  end


  # ========== MONAD HELPERS ==============================

  def closest_model_number(computer, seed) do
    find_valid_model_number(computer, seed, nil)
  end


  # ========== RUN HELPERS ================================

  def run(computer, program, _, _) when length(program) == 0 do
    computer
  end

  def run(current_computer, remaining_program, remaining_input, debug_mode) do
    memory                    = current_computer.memory
    [ instruction | program ] = remaining_program

    cmd   = instruction.cmd
    raw_a = instruction.a
    raw_b = instruction.b

    { computer, program, input } =
      if cmd == :inp do
        if debug_mode do
          print(current_computer)
        end
        
        [ b | input ] = remaining_input
        memory        = Memory.put(memory, raw_a, b)
        computer      = %{ current_computer | memory: memory }

        { computer, program, input }
      else
        { status, response } =
          case cmd do
            :add -> process_add(memory, raw_a, raw_b)
            :div -> process_div(memory, raw_a, raw_b)
            :eql -> process_eql(memory, raw_a, raw_b, debug_mode)
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

    run(computer, program, input, debug_mode)
  end


  # ========== PRINT HELPERS ==============================

  def print(computer) do
    IO.inspect computer.memory
    IO.inspect rem(computer.memory.z, 26)
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
  defp process_eql(memory, raw_a, raw_b, debug_mode) do
    a = Memory.get(memory, raw_a)
    b = Memory.get(memory, raw_b)
    v = if (a == b), do: 1, else: 0

    if debug_mode and raw_a == :x and raw_b == :w do
      IO.puts "------------------------"
      IO.inspect { a, b }
    end

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


  # ========== MONAD HELPERS ==============================

  def find_valid_model_number(_, _, valid_number) when valid_number != nil do
    valid_number
  end

  def find_valid_model_number(computer, current_number, valid_number) do
    digits = number_to_digits(current_number)

    if Enum.any?(digits, fn i -> i == 0 end) do
      index       = digits |> Enum.find_index(fn d -> d == 0 end)
      power       = length(digits) - index
      mod_divisor = :math.pow(10, power) |> trunc()
      mod_diff    = rem(current_number, mod_divisor)
      next_number = current_number - mod_diff - 1
      IO.puts "skipping => #{ current_number } for #{ next_number }"

      find_valid_model_number(computer, next_number, valid_number)
    else
      input = number_to_padded_digits(current_number)
      c     = run(computer, computer.program, input, false)
      z     = Memory.get(c.memory, :z)
      vn    = if z == 0, do: current_number, else: nil

      find_valid_model_number(computer, current_number - 1, vn)
    end
  end


  # ========== UTILITY HELPERS ============================

  defp number_to_digits(number) do
    number
    |> Integer.to_string()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp number_to_padded_digits(number) do
    number
    |> Integer.to_string()
    |> String.pad_leading(14, "00000000000000")
    |> String.graphemes()
    |> Enum.take(-14)
    |> Enum.map(&String.to_integer/1)
  end

end
