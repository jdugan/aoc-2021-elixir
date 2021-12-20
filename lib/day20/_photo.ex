defmodule Day20.Photo do

  # -------------------------------------------------------
  # Configuration
  # -------------------------------------------------------

  alias Day20.Pixel, as: Pixel

  defstruct [
    algorithm: [],
    pixels:   %{}
  ]


  # -------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------

  # ========== COUNT HELPERS ==============================

  def count_lit_pixels(photo) do
    photo.pixels
    |> map_size()
  end


  # ========== ENHANCE HELPERS ============================

  def enhance(photo, cycles) do
    enhance_iteratively(photo, cycles, 0)
  end


  # ========== PRINT HELPERS ==============================

  def print(photo) do
    IO.puts ""
    to_printable_list(photo)
    |> Enum.each(fn row ->
      IO.puts Enum.join(row)
    end)
    IO.puts ""
  end


  # -------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------

  # ========== ENHANCE HELPERS ============================

  defp enhancable_ids(photo) do
    { xmin, xmax, ymin, ymax } = enhancable_range(photo, 2)

    Enum.map(xmin..xmax, fn x ->
      Enum.map(ymin..ymax, fn y ->
        { x, y }
      end)
    end)
    |> List.flatten()
  end

  defp enhancable_range(photo, offset) do
    { xmin, xmax, ymin, ymax } = mapped_range(photo)
    { xmin - offset, xmax + offset, ymin - offset, ymax + offset }
  end

  defp enhance_iteratively(photo, cycles_requested, cycles) when cycles_requested == cycles do
    unless Mix.env() == :test do
      IO.puts ""
      IO.puts "-----------------------------"
      IO.puts "Iteration: #{ cycles }"
      IO.puts "-----------------------------"
      print(photo)
    end
    photo
  end

  defp enhance_iteratively(photo, cycles_requested, cycles) do
    limits = mapped_range(photo)
    pixels =
      photo
      |> enhancable_ids()
      |> Enum.reduce(%{}, fn (id, acc) ->
        pixel = %Pixel{ id: id }

        digits =
          pixel
          |> Pixel.ordered_algorithm_ids()
          |> Enum.map(fn id ->
            p =
              if Map.has_key?(photo.pixels, id) do
                Map.get(photo.pixels, id)
              else
                default_pixel(photo, limits, cycles, id)
              end

            if p.state == "#", do: 1, else: 0
          end)

        if enhanced_pixel_lit?(digits, photo.algorithm) do
          Map.put(acc, id, %{ pixel | state: "#" })
        else
          acc
        end
      end)


    enhance_iteratively(%{ photo | pixels: pixels }, cycles_requested, cycles + 1)
  end

  def enhanced_pixel_lit?(digits, algorithm) do
    index = Conversion.binary_array_to_decimal(digits)

    Enum.at(algorithm, index) == "#"
  end


  # ========== PIXEL MAP HELPERS ==========================

  defp default_pixel(photo, { xmin, xmax, ymin, ymax }, cycles, { x, y }) do
    pixel = %Pixel{ id: { x, y }, state: "." }

    in_range  = (xmin <= x and x <= xmax) and (ymin <= y and y <= ymax)
    is_static = List.first(photo.algorithm) == "."

    if in_range or is_static do
      pixel                         # simple off; unaffected by infinity conditions
    else
      if rem(cycles, 2) == 1 do
        %{ pixel | state: "#" }     # infinity switched on last iteration
      else
        pixel                       # infinity switched off last iteration
      end
    end
  end

  defp mapped_range(photo) do
    keys = Map.keys(photo.pixels)

    xs   = keys |> Enum.map(fn { x, _ } -> x end) |> Enum.sort()
    ys   = keys |> Enum.map(fn { _, y } -> y end) |> Enum.sort()

    xmin = List.first(xs)
    xmax = List.last(xs)
    ymin = List.first(ys)
    ymax = List.last(ys)

    { xmin, xmax, ymin, ymax }
  end


  # ========== PRINT HELPERS ==============================

  defp print_dimension_ranges(photo) do
    { xmin, xmax, ymin, ymax } = mapped_range(photo)

    xs = Enum.to_list(xmin..xmax)
    ys = Enum.to_list(ymin..ymax)

    { xs, ys }
  end

  defp to_printable_list(photo) do
    { xs, ys } = print_dimension_ranges(photo)

    Enum.map(ys, fn y ->
      Enum.map(xs, fn x ->
        p = Map.get(photo.pixels, { x, y }, %Pixel{})
        p.state
      end)
    end)
  end

end
