defmodule Tint.Distance.EuclideanTest do
  use ExUnit.Case

  import Tint.Sigil

  alias Tint.Distance.Euclidean

  describe "euclidean_distance/2" do
    test "get Euclidean distance for two colors" do
      assert Euclidean.euclidean_distance(~K[#FFCC00], ~K[#FCFFCC]) ==
               Euclidean.euclidean_distance(~K[#FFCC00], ~K[#FCFFCC], [])
    end
  end

  describe "euclidean_distance/3" do
    test "get Euclidean distance for two colors" do
      assert Euclidean.euclidean_distance(~K[#FFFFFF], ~K[#000000], []) ==
               441.6729559300637

      assert Euclidean.euclidean_distance(~K[#FFFFFF], ~K[#000000], []) ==
               Euclidean.euclidean_distance(~K[#FFFFFF], ~K[#000000],
                 weight: {1, 1, 1}
               )

      assert Euclidean.euclidean_distance(~K[#FFFFFF], ~K[#000000],
               weights: {2, 4, 3}
             ) ==
               765.0

      assert Euclidean.euclidean_distance(~K[#000000], ~K[#FFFFFF], []) ==
               441.6729559300637

      assert Euclidean.euclidean_distance(~K[#000000], ~K[#FFFFFF],
               weights: {2, 4, 3}
             ) ==
               765.0

      assert Euclidean.euclidean_distance(~K[#FF0000], ~K[#FC0000], []) == 3.0

      assert Euclidean.euclidean_distance(~K[#FF0000], ~K[#FC0000],
               weights: {2, 4, 3}
             ) ==
               4.242640687119285

      assert Euclidean.euclidean_distance(~K[#FFCC00], ~K[#FCFFCC], []) ==
               210.2997860198626

      assert Euclidean.euclidean_distance(~K[#FFCC00], ~K[#FCFFCC],
               weights: {2, 4, 3}
             ) ==
               367.7907013506459
    end
  end

  describe "human_euclidean_distance/2" do
    test "get Euclidean distance with weights optimized for human perception" do
      Enum.each(
        [
          {~K[127,0,255]r, ~K[#FFF], {2, 4, 3}},
          {~K[127,255,0]r, ~K[#000], {2, 4, 3}},
          {~K[128,0,255]r, ~K[#FFF], {3, 4, 2}},
          {~K[128,255,0]r, ~K[#000], {3, 4, 2}}
        ],
        fn {color, other_color, weights} ->
          assert Euclidean.human_euclidean_distance(color, other_color) ==
                   Euclidean.euclidean_distance(color, other_color,
                     weights: weights
                   )
        end
      )
    end
  end
end
