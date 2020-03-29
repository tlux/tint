defmodule Tint.XYZTest do
  use ExUnit.Case, async: true

  alias Tint.Lab
  alias Tint.XYZ

  describe "new/3" do
    test "build XYZ color" do
      assert XYZ.new(0.9505, 1, 1.09) == %XYZ{
               x: Decimal.new("0.951"),
               y: Decimal.new("1.000"),
               z: Decimal.new("1.090")
             }
    end
  end

  describe "Convertible.Lab.to_lab/1" do
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

  # TODO:
  # describe "Convertible.RGB.to_rgb/1" do
  #   test "convert to RGB" do
  #     conversions = [
  #       {XYZ.new(0, 0, 0), RGB.new(0, 0, 0)},
  #       {XYZ.new(42.282, 74.129, 46.262), RGB.new(0, 255, 162)},
  #       {XYZ.new(95.05, 100, 108.9), RGB.new(255, 255, 255)}
  #     ]

  #     Enum.each(conversions, fn {xyz, rgb} ->
  #       assert RGB.Convertible.to_rgb(xyz) == rgb
  #     end)
  #   end
  # end
end
