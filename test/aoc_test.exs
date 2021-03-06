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
    assert Day12.puzzle2() == 136767
  end

  test "Day13" do
    assert Day13.puzzle1() == 753
    assert Day13.puzzle2() == "HZLEHJRK"
  end

  test "Day14" do
    assert Day14.puzzle1() == 2590
    assert Day14.puzzle2() == 2875665202438
  end

  test "Day15" do
    assert Day15.puzzle1() == 720
    # assert Day15.puzzle2() == 3025              # Clock => ~39s
  end

  test "Day16" do
    assert Day16.puzzle1() == 1002
    assert Day16.puzzle2() == 1673210814091
  end

  test "Day17" do
    assert Day17.puzzle1() == 30628
    assert Day17.puzzle2() == 4433
  end

  test "Day18" do
    assert Day18.puzzle1() == 4173
    assert Day18.puzzle2() == 4706                # Clock -> ~3s
  end

  test "Day19" do
    assert Day19.puzzle1() == 326
    assert Day19.puzzle2() == 10630
  end

  test "Day20" do
    assert Day20.puzzle1() == 5765
    assert Day20.puzzle2() == 18509
  end

  test "Day21" do
    assert Day21.puzzle1() == 920079
    # assert Day21.puzzle2() == 56852759190649    # Clock -> ~30s
  end

  test "Day22" do
    assert Day22.puzzle1() == 576028
    assert Day22.puzzle2() == 1387966280636636
  end

  test "Day23" do
    # assert Day23.puzzle1() == 12240             # Clock -> ~12m :(
    assert Day23.puzzle2() == 44618               # Clock -> ~1m
  end

  test "Day24" do
    assert Day24.puzzle1() == 92969593497992
    assert Day24.puzzle2() == 81514171161381
  end

  test "Day25" do
    assert Day25.puzzle1() == 378
    # freebie!
  end

end
