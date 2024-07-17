defmodule Day18.Expression do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias __MODULE__

  defstruct pair: []


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== ADDITION HELPERS ===========================

  def sum(list) do
    [ head | expressions ] = list

    expressions
    |> Enum.reduce(head, fn (exp, acc) ->
      %Expression{ pair: [acc, exp] }
      |> unparse()
      |> reduce()
      |> parse()
    end)
  end


  # ========== MAGNITUDE HELPERS ==========================

  def magnitude(expression) do
    { m1, m2 } =
      expression.pair
      |> Enum.map(fn p ->
        if is_number(p), do: p, else: magnitude(p)
      end)
      |> List.to_tuple()

    (3 * m1) + (2 * m2)
  end


  # ========== PARSING HELPERS ============================

  def parse(str) do
    comma_index = parse_comma_index(str)

    str0 =
      str
      |> String.slice(0, comma_index)
      |> String.slice(1..-1//1)
    str1 =
      str
      |> String.slice(comma_index+1..-1//1)
      |> String.slice(0..-2//1)

    pair =
      [str0, str1]
      |> Enum.map(fn p ->
        if Regex.match?(~r/^\d+$/, p) do
          String.to_integer(p)
        else
          parse(p)
        end
      end)

    %Expression{ pair: pair }
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== PARSING ====================================

  defp parse_comma_index(str) do
    graphemes =
      str
      |> String.graphemes()
      |> Enum.slice(1..-2//1)

    subindex =
      if Enum.at(graphemes, 0) == "[" do
        inner_index =
          graphemes
          |> Enum.drop(1)
          |> Enum.with_index()
          |> Enum.reduce({ 1, 0, nil }, fn ({ g, i }, { open, closed, index }) ->
            if index == nil do
              open   = if g == "[", do: open + 1,   else: open
              closed = if g == "]", do: closed + 1, else: closed
              index  = if open == closed, do: i + 1, else: nil

              { open, closed, index }
            else
              { open, closed, index }
            end
          end)
          |> Tuple.to_list()
          |> Enum.at(-1)

        inner_index + 1   # we skipped the first open bracket earlier
      else
        graphemes
        |> Enum.find_index(fn g -> g == "," end)
      end

    subindex + 1          # we removed the outermost []s earlier
  end

  def unparse(exp) do
    if is_number(exp) do
      exp
    else
      pair_str =
        exp.pair
        |> Enum.map(fn p ->
          unparse(p)
        end)
        |> Enum.join(",")

      "[#{ pair_str }]"
    end
  end


  # ========== REDUCE HELPERS =============================

  defp explode(base_str) do
    { explode_i, explode_len } = explode_index(base_str)

    exploding_str =
      base_str
      |> String.slice(explode_i, explode_len)

    { p1, p2 } =
      exploding_str
      |> String.slice(1..-2//1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    before_str =
      base_str
      |> String.slice(0, explode_i)
      |> String.reverse()
      |> String.replace(~r/\d+/, fn match ->
        imatch = match |> String.reverse() |> String.to_integer()
        "#{ imatch + p1 }" |> String.reverse()
      end, global: false)
      |> String.reverse()

    after_str =
      base_str
      |> String.slice(explode_i+explode_len..-1//1)
      |> String.replace(~r/\d+/, fn match ->
        imatch = String.to_integer(match)
        "#{ imatch + p2 }"
      end, global: false)

    "#{ before_str }0#{ after_str }"
  end

  defp explode_index(base_str) do
    { _, _, i_open, i_close }=
      base_str
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce({ 0, 0, nil, nil }, fn ({ g, i }, { ropen, rclosed, ro_index, rc_index }) ->
        open    = if g == "[", do: ropen + 1,   else: ropen
        closed  = if g == "]", do: rclosed + 1, else: rclosed

        c_found = rc_index == nil and g == "]" and closed > 0 and (open - closed) == 4
        c_index = if c_found, do: i, else: rc_index

        o_found = rc_index == nil and g == "["
        o_index = if o_found, do: i, else: ro_index

        { open, closed, o_index, c_index }
      end)

    if i_close != nil do
      { i_open, i_close - i_open + 1 }
    else
      { nil, 0 }
    end
  end

  defp reduce(base_str) do
    { explode_index, _ } = explode_index(base_str)
    { split_index, _ }   = split_index(base_str)

    can_explode = !!explode_index
    can_split   = !!split_index

    cond do
      can_explode -> base_str |> explode() |> reduce()
      can_split   -> base_str |> split()   |> reduce()
      true        -> base_str
    end
  end

  defp split(base_str) do
    base_str
    |> String.replace(~r/\d{2,}/, fn match ->
      imatch  = String.to_integer(match)
      fhalf   = imatch / 2
      isplit1 = fhalf |> :math.floor() |> trunc()
      isplit2 = fhalf |> :math.ceil()  |> trunc()
      "[#{ isplit1 },#{ isplit2 }]"
    end, global: false)
  end

  defp split_index(base_str) do
    result = Regex.run(~r/\d{2,}/, base_str, return: :index)

    if result do
      Enum.at(result, 0)
    else
      { nil, 0 }
    end
  end

end
