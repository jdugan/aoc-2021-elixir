defmodule AocTest do
  use ExUnit.Case
  # doctest Aoc

  test "Day01" do
    assert Day01.puzzle1() == 1184
    assert Day01.puzzle2() == 1158
  end
  test "Day02" do
    assert Day02.puzzle1() == 2150351
    assert Day02.puzzle2() == 1842742223
  end
end
