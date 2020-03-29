defmodule Tint.Distance.EuclideanTest do
  use ExUnit.Case

  import Tint.Sigil

  alias Tint.Distance.Euclidean

  describe "distance/3" do
    test "get Euclidean distance for two colors" do
      assert Euclidean.distance(~K[#FFFFFF], ~K[#000000], []) ==
               441.6729559300637

      assert Euclidean.distance(~K[#FFFFFF], ~K[#000000], []) ==
               Euclidean.distance(~K[#FFFFFF], ~K[#000000], weight: {1, 1, 1})

      assert Euclidean.distance(~K[#FFFFFF], ~K[#000000], weights: {2, 4, 3}) ==
               765.0

      assert Euclidean.distance(~K[#000000], ~K[#FFFFFF], []) ==
               441.6729559300637

      assert Euclidean.distance(~K[#000000], ~K[#FFFFFF], weights: {2, 4, 3}) ==
               765.0

      assert Euclidean.distance(~K[#FF0000], ~K[#FC0000], []) == 3.0

      assert Euclidean.distance(~K[#FF0000], ~K[#FC0000], weights: {2, 4, 3}) ==
               4.242640687119285

      assert Euclidean.distance(~K[#FFCC00], ~K[#FCFFCC], []) ==
               210.2997860198626

      assert Euclidean.distance(~K[#FFCC00], ~K[#FCFFCC], weights: {2, 4, 3}) ==
               367.7907013506459
    end
  end
end
