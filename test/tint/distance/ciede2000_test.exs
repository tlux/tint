defmodule Tint.Distance.CIEDE2000Test do
  use ExUnit.Case, async: true

  alias Tint.CIELAB
  alias Tint.Distance.CIEDE2000

  @test_data [
    {{50, 2.6772, -79.7751}, {50, 0, -82.7485}, 2.0425},
    {{50, 3.1571, -77.2803}, {50, 0, -82.7485}, 2.8615},
    {{50, 2.5, 0}, {61, -5, 29}, 22.8977}
  ]

  describe "ciede_2000/2" do
    test "matches test data" do
      for {lab_tuple_a, lab_tuple_b, distance} <- @test_data,
          color = CIELAB.from_tuple(lab_tuple_a),
          other_color = CIELAB.from_tuple(lab_tuple_b) do
        assert_in_delta CIEDE2000.ciede2000_distance(color, other_color),
                        distance,
                        0.5
      end
    end
  end
end
