defmodule Tint.XYZTest do
  use ExUnit.Case, async: true

  alias Tint.CIELAB
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

  describe "Convertible.CIELAB.to_lab/1" do
    test "convert to CIELAB" do
      conversions = [
        # #000000
        {XYZ.new(0, 0, 0), CIELAB.new(0, 0, 0)},
        # #FFFFFF
        {XYZ.new(95.05, 100, 108.9), CIELAB.new(100, 0.002, -0.010)},
        # ##FF0000
        {XYZ.new(41.24, 21.26, 1.93), CIELAB.new(53.233, 80.107, 67.220)}
      ]

      Enum.each(conversions, fn {xyz, lab} ->
        assert CIELAB.Convertible.to_lab(xyz) == lab
      end)
    end
  end

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
