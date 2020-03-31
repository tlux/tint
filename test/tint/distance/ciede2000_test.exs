defmodule Tint.Distance.CIEDE2000Test do
  use ExUnit.Case, async: true

  alias Tint.Distance.CIEDE2000
  alias Tint.Lab

  @test_data [
    {{50, 2.6772, -79.7751}, {50, 0, -82.7485}, 2.0425},
    {{50, 3.1571, -77.2803}, {50, 0, -82.7485}, 2.8615},
    {{50, 2.5, 0}, {61, -5, 29}, 22.8977},
    {{35.0831, -44.1164, 3.7933}, {35.0232, -40.0716, 1.5901}, 1.8645},
    {{22.7233, 20.0904, -46.6940}, {23.0331, 14.9730, -42.5619}, 2.0373},
    {{2.0776, 0.0795, -1.1350}, {0.9033, -0.0636, -0.5514}, 0.9082},
    {{50, 0, 0}, {50, -1, 2}, 2.3669},
    {{50, -1, 2}, {50, 0, 0}, 2.3669},
    {{50, 0, 0}, {50, 0, 0}, 0},
    {{50, 2.5, 0}, {50, 3.2972, 0}, 1},
    {{50, 2.49, -0.001}, {50, -2.49, 0.0012}, 7.2195}
  ]

  describe "ciede_2000_distance/2" do
    test "matches test data" do
      for {lab_tuple_a, lab_tuple_b, distance} <- @test_data,
          color = Lab.from_tuple(lab_tuple_a),
          other_color = Lab.from_tuple(lab_tuple_b) do
        assert_in_delta CIEDE2000.distance(color, other_color, []),
                        distance,
                        0.4
      end
    end
  end
end
