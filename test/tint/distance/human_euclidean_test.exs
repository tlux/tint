defmodule Tint.Distance.HumanEuclideanTest do
  use ExUnit.Case

  import Tint.Sigil

  alias Tint.Distance.Euclidean
  alias Tint.Distance.HumanEuclidean

  describe "distance/3" do
    test "get Euclidean distance with weights optimized for human perception" do
      Enum.each(
        [
          {~K[127,0,255]r, ~K[#FFF], {2, 4, 3}},
          {~K[127,255,0]r, ~K[#000], {2, 4, 3}},
          {~K[128,0,255]r, ~K[#FFF], {3, 4, 2}},
          {~K[128,255,0]r, ~K[#000], {3, 4, 2}}
        ],
        fn {color, other_color, weights} ->
          assert HumanEuclidean.distance(color, other_color, []) ==
                   Euclidean.distance(color, other_color, weights: weights)
        end
      )
    end
  end
end
