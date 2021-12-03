defmodule AocTest do
  use ExUnit.Case

  test "Day01" do
    assert Day01.puzzle1() == 1184
    assert Day01.puzzle2() == 1158
  end

  test "Day02" do
    assert Day02.puzzle1() == 2150351
    assert Day02.puzzle2() == 1842742223
  end

  test "Day03" do
    assert Day03.puzzle1() == 1082324
    assert Day03.puzzle2() == 1353024
  end
end
