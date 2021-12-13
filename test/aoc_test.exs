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

  test "Day08" do
    assert Day08.puzzle1() == 321
    assert Day08.puzzle2() == 1028926
  end

  test "Day09" do
    assert Day09.puzzle1() == 439
    assert Day09.puzzle2() == 900900
  end

  test "Day10" do
    assert Day10.puzzle1() == 344193
    assert Day10.puzzle2() == 3241238967
  end

  test "Day11" do
    assert Day11.puzzle1() == 1732
    assert Day11.puzzle2() == 290
  end

  test "Day12" do
    assert Day12.puzzle1() == 4411
    # assert Day12.puzzle2() == 136767        # too slow :(
  end

  test "Day13" do
    assert Day13.puzzle1() == 753
    assert Day13.puzzle2() == "HZLEHJRK"
  end
end
