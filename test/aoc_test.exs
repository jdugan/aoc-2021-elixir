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

  test "Day04" do
    assert Day04.puzzle1() == 89001
    assert Day04.puzzle2() == 7296
  end

  test "Day05" do
    assert Day05.puzzle1() == 6856
    assert Day05.puzzle2() == 20666
  end

  test "Day06" do
    assert Day06.puzzle1() == 366057
    assert Day06.puzzle2() == 1653559299811
  end

  test "Day07" do
    assert Day07.puzzle1() == 344535
    assert Day07.puzzle2() == 95581659
  end
end
