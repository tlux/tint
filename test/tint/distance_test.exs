defmodule Tint.DistanceTest do
  use ExUnit.Case

  import Tint.Sigil

  alias Tint.Distance
  alias Tint.DistanceCache

  @color ~K[#FF0000]

  @palette [
    ~K[#FFCC00],
    ~K[#CC0000],
    ~K[#FFFFFF]
  ]

  describe "distance/3" do
    @other_color ~K[#FFCC00]

    test "delegate to calculator module" do
      assert Distance.distance(@color, @other_color, Distance.Euclidean) ==
               Distance.Euclidean.distance(@color, @other_color, [])
    end

    test "delegate to calculator module with opts" do
      opts = [weights: {0.2, 0.4, 0.3}]

      assert Distance.distance(@color, @other_color, {Distance.Euclidean, opts}) ==
               Distance.Euclidean.distance(@color, @other_color, opts)
    end

    test "delegate to calculator function" do
      fun = &Distance.Euclidean.distance(&1, &2, [])

      assert Distance.distance(@color, @other_color, fun) ==
               fun.(@color, @other_color)
    end

    test "cache result from calc module when cache available" do
      start_supervised!({DistanceCache, size: 5})

      result = Distance.Euclidean.distance(@color, @other_color, [])

      assert Distance.distance(@color, @other_color, Distance.Euclidean) ==
               result

      assert :sys.get_state(DistanceCache).results[
               {@color, @other_color, Distance.Euclidean, []}
             ] == result
    end

    test "cache result from calc module with opts when cache available" do
      start_supervised!({DistanceCache, size: 5})

      opts = [weights: {0.2, 0.4, 0.3}]
      result = Distance.Euclidean.distance(@color, @other_color, opts)

      assert Distance.distance(@color, @other_color, {Distance.Euclidean, opts}) ==
               result

      assert :sys.get_state(DistanceCache).results[
               {@color, @other_color, Distance.Euclidean, opts}
             ] == result
    end

    test "cache result from calc function when cache available" do
      start_supervised!({DistanceCache, size: 5})

      fun = &Distance.Euclidean.distance(&1, &2, [])
      result = fun.(@color, @other_color)

      assert Distance.distance(@color, @other_color, fun) == result

      assert :sys.get_state(DistanceCache).results[{@color, @other_color, fun}] ==
               result
    end
  end

  describe "nearest_color/3" do
    test "get nearest color" do
      assert Distance.nearest_color(@color, @palette, Distance.Euclidean) ==
               ~K[#CC0000]
    end

    test "nil when palette empty" do
      assert Distance.nearest_color(@color, [], Distance.Euclidean) == nil
    end
  end

  describe "nearest_colors/4" do
    test "get n nearest colors" do
      assert Distance.nearest_colors(@color, @palette, 2, Distance.Euclidean) ==
               [~K[#CC0000], ~K[#FFCC00]]
    end

    test "get entire palette when palette size is less than n" do
      assert Distance.nearest_colors(@color, @palette, 4, Distance.Euclidean) ==
               [~K[#CC0000], ~K[#FFCC00], ~K[#FFFFFF]]
    end

    test "get empty list when palette empty" do
      assert Distance.nearest_colors(@color, [], 3, Distance.Euclidean) == []
    end
  end
end
