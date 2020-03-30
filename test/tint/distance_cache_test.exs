defmodule Tint.DistanceCacheTest do
  use ExUnit.Case

  alias Tint.DistanceCache

  describe "get_or_put/3" do
    test "store and get new value" do
      start_supervised!({DistanceCache, size: 1000})

      assert DistanceCache.get_or_put("foo", fn -> 1.234 end) == 1.234
      assert DistanceCache.get_or_put("bar", fn -> 6.66 end) == 6.66

      assert :sys.get_state(DistanceCache) == %{
               size: 1000,
               results: %{"foo" => 1.234, "bar" => 6.66},
               keys: :queue.from_list(["foo", "bar"]),
               count: 2
             }
    end

    test "get cached value" do
      start_supervised!({DistanceCache, size: 1000})

      assert DistanceCache.get_or_put("bar", fn -> 1.234 end) == 1.234
      assert DistanceCache.get_or_put("bar", fn -> 6.66 end) == 1.234

      assert :sys.get_state(DistanceCache) == %{
               size: 1000,
               results: %{"bar" => 1.234},
               keys: :queue.from_list(["bar"]),
               count: 1
             }
    end

    test "remove old values when cache size exceeded" do
      start_supervised!({DistanceCache, size: 2})

      assert DistanceCache.get_or_put("foo", fn -> 1.234 end) == 1.234
      assert DistanceCache.get_or_put("bar", fn -> 6.66 end) == 6.66
      assert DistanceCache.get_or_put("baz", fn -> 22.07 end) == 22.07

      assert :sys.get_state(DistanceCache) == %{
               size: 2,
               results: %{"bar" => 6.66, "baz" => 22.07},
               keys: :queue.from_list(["bar", "baz"]),
               count: 2
             }
    end

    test "return function result when cache size is 0" do
      start_supervised!({DistanceCache, size: 0})

      assert DistanceCache.get_or_put("bar", fn -> 1.234 end) == 1.234
      assert DistanceCache.get_or_put("baz", fn -> 6.66 end) == 6.66

      assert :sys.get_state(DistanceCache) == %{
               size: 0,
               results: %{},
               keys: :queue.new(),
               count: 0
             }
    end
  end
end
