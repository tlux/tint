defmodule Tint.LabTest do
  use ExUnit.Case, async: true

  import Tint.Sigil

  alias Tint.Distance
  alias Tint.Distance.CIEDE2000
  alias Tint.Lab

  describe "new/3" do
    test "build Lab color" do
      assert Lab.new(50.1234, 10.7643, 10.4322) == %Lab{
               lightness: Decimal.new("50.1234"),
               a: Decimal.new("10.7643"),
               b: Decimal.new("10.4322")
             }
    end
  end

  describe "ciede2000_distance/2" do
    test "delegate to Distance.CIEDE2000" do
      color = Tint.to_lab(~K[#FF0000])
      other_color = Tint.to_lab(~K[#0000FF])

      assert Lab.ciede2000_distance(color, other_color) ==
               Distance.CIEDE2000.distance(color, other_color, [])
    end
  end

  describe "ciede2000_distance/3" do
    test "delegate to Distance.CIEDE2000" do
      color = Tint.to_lab(~K[#FF0000])
      other_color = Tint.to_lab(~K[#0000FF])
      opts = [weights: {0.4, 0.1, 0.6}]

      assert Lab.ciede2000_distance(color, other_color, opts) ==
               Distance.CIEDE2000.distance(color, other_color, opts)
    end
  end

  describe "nearest_color/2" do
    test "delegate to nearest_color/3 with CIEDE2000 distance algorithm" do
      color = Tint.to_lab(~K[#FF0000])
      palette = [~K[#FCFF00], ~K[#CCFF00], ~K[#CC0000]]

      assert Lab.nearest_color(color, []) ==
               Lab.nearest_color(color, [], CIEDE2000)

      assert Lab.nearest_color(color, palette) ==
               Lab.nearest_color(color, palette, CIEDE2000)
    end
  end

  describe "nearest_color/3" do
    test "is nil when palette is empty" do
      assert Lab.nearest_color(Tint.to_lab(~K[#FF0000]), [], CIEDE2000) == nil
    end

    test "get nearest color" do
      palette = [
        ~K[#FCFF00],
        ~K[#00FF00],
        ~K[#CC0000],
        ~K[#FF9900],
        ~K[#00CCFF],
        ~K[#000FFF],
        ~K[#333333],
        ~K[#CCCCCC]
      ]

      assert Lab.nearest_color(Tint.to_lab(~K[#000000]), palette, CIEDE2000) ==
               ~K[#333333]

      assert Lab.nearest_color(Tint.to_lab(~K[#004CA8]), palette, CIEDE2000) ==
               ~K[#000FFF]

      assert Lab.nearest_color(Tint.to_lab(~K[#0497D6]), palette, CIEDE2000) ==
               ~K[#00CCFF]

      assert Lab.nearest_color(Tint.to_lab(~K[#094F6E]), palette, CIEDE2000) ==
               ~K[#333333]

      assert Lab.nearest_color(Tint.to_lab(~K[#10A110]), palette, CIEDE2000) ==
               ~K[#00FF00]

      assert Lab.nearest_color(Tint.to_lab(~K[#666666]), palette, CIEDE2000) ==
               ~K[#333333]

      assert Lab.nearest_color(Tint.to_lab(~K[#FF0000]), palette, CIEDE2000) ==
               ~K[#CC0000]

      assert Lab.nearest_color(Tint.to_lab(~K[#FFCC00]), palette, CIEDE2000) ==
               ~K[#FCFF00]

      assert Lab.nearest_color(Tint.to_lab(~K[#FFEC70]), palette, CIEDE2000) ==
               ~K[#FCFF00]

      assert Lab.nearest_color(Tint.to_lab(~K[#FFFFFF]), palette, CIEDE2000) ==
               ~K[#CCCCCC]
    end
  end

  describe "nearest_colors/3" do
    test "delegate to nearest_colors/4 with CIEDE2000 distance algorithm" do
      color = Tint.to_lab(~K[#FF0000])
      palette = [~K[#FCFF00], ~K[#CCFF00], ~K[#CC0000]]

      assert Lab.nearest_colors(color, [], 2) ==
               Lab.nearest_colors(color, [], 2, CIEDE2000)

      assert Lab.nearest_colors(color, palette, 2) ==
               Lab.nearest_colors(color, palette, 2, CIEDE2000)
    end
  end

  describe "nearest_colors/4" do
    test "is empty list when palette is empty" do
      assert Lab.nearest_colors(Tint.to_lab(~K[#FF0000]), [], 2, Euclidean) ==
               []
    end

    test "get nearest color" do
      palette = [
        ~K[#FCFF00],
        ~K[#CC0000],
        ~K[#FF9900],
        ~K[#000FFF],
        ~K[#333333],
        ~K[#CCCCCC]
      ]

      assert Lab.nearest_colors(Tint.to_lab(~K[#000000]), palette, 2, CIEDE2000) ==
               [~K[#333333], ~K[#000FFF]]

      assert Lab.nearest_colors(Tint.to_lab(~K[#004CA8]), palette, 2, CIEDE2000) ==
               [~K[#000FFF], ~K[#333333]]

      assert Lab.nearest_colors(Tint.to_lab(~K[#FF0000]), palette, 3, CIEDE2000) ==
               [~K[#CC0000], ~K[#FF9900], ~K[#CCCCCC]]

      assert Lab.nearest_colors(Tint.to_lab(~K[#FFCC00]), palette, 2, CIEDE2000) ==
               [~K[#FCFF00], ~K[#FF9900]]
    end
  end

  describe "from_tuple/1" do
    test "convert tuple to Lab struct" do
      assert Lab.from_tuple(
               {Decimal.new("50.1234"), Decimal.new("10.7643"),
                Decimal.new("10.4322")}
             ) == Lab.new(50.1234, 10.7643, 10.4322)
    end

    test "raise when invalid arg given" do
      assert_raise FunctionClauseError, fn ->
        Lab.from_tuple({50.1234, 10.7643})
      end

      assert_raise FunctionClauseError, fn ->
        Lab.from_tuple(nil)
      end
    end
  end

  describe "to_tuple/1" do
    test "get tuple" do
      assert Lab.to_tuple(Lab.new(50.1234, 10.7643, 10.4322)) ==
               {Decimal.new("50.1234"), Decimal.new("10.7643"),
                Decimal.new("10.4322")}
    end
  end

  describe "Kernel.inspect/1" do
    test "inspect" do
      assert inspect(Lab.new(50.1234, 10.7643, 10.4322)) ==
               "#Tint.Lab<50.1234,10.7643,10.4322>"
    end
  end

  describe "Lab.Convertible.to_lab/1" do
    test "convert to Lab" do
      color = Lab.new(50, 10, 10)

      assert Lab.Convertible.to_lab(color) == color
    end
  end
end
