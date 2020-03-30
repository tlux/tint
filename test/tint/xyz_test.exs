defmodule Tint.XYZTest do
  use ExUnit.Case, async: true

  alias Tint.Lab
  alias Tint.XYZ

  describe "new/3" do
    test "build XYZ color" do
      assert XYZ.new(0.9505, 1, 1.09) == %XYZ{
               x: Decimal.new("0.9505"),
               y: Decimal.new("1.0000"),
               z: Decimal.new("1.0900")
             }
    end
  end

  describe "Inspect.inspect/1" do
    test "inspect" do
      assert inspect(XYZ.new(0.9505, 1, 1.09)) == "#Tint.XYZ<0.9505,1,1.09>"
    end
  end

  describe "Lab.Convertible.to_lab/1" do
    test "convert to Lab" do
      conversions = [
        # #000000
        {XYZ.new(0, 0, 0), Lab.new(0, 0, 0)},
        # #FFFFFF
        {XYZ.new(95.05, 100, 108.9), Lab.new(100, 0.0019, -0.0098)},
        # ##FF0000
        {XYZ.new(41.24, 21.26, 1.93), Lab.new(53.2329, 80.1068, 67.2202)}
      ]

      Enum.each(conversions, fn {xyz, lab} ->
        assert Lab.Convertible.to_lab(xyz) == lab
      end)
    end
  end

  describe "XYZ.Convertible.to_xyz/1" do
    test "convert to DIN99" do
      color = XYZ.new(95.05, 100, 108.9)

      assert XYZ.Convertible.to_xyz(color) == color
    end
  end
end
