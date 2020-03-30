defmodule TintTest do
  use ExUnit.Case

  alias Tint.Lab
  alias Tint.CMYK
  alias Tint.DIN99
  alias Tint.HSV
  alias Tint.RGB

  doctest Tint

  @rgb_color RGB.new(0, 50, 100)
  @hsv_color HSV.new(210, 1, 0.392)

  describe "to_cmyk/1" do
    test "convert color to HSV" do
      assert Tint.to_cmyk(@rgb_color) == CMYK.Convertible.to_cmyk(@rgb_color)
    end
  end

  describe "to_din99/1" do
    test "convert color to HSV" do
      assert Tint.to_din99(@rgb_color) == DIN99.Convertible.to_din99(@rgb_color)
    end
  end

  describe "to_hsv/1" do
    test "convert color to HSV" do
      assert Tint.to_hsv(@rgb_color) == HSV.Convertible.to_hsv(@rgb_color)
    end
  end

  describe "to_lab/1" do
    test "convert color to HSV" do
      assert Tint.to_lab(@rgb_color) == Lab.Convertible.to_lab(@rgb_color)
    end
  end

  describe "to_rgb/1" do
    test "convert color to RGB" do
      assert Tint.to_rgb(@hsv_color) == RGB.Convertible.to_rgb(@hsv_color)
    end
  end
end
