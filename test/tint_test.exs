defmodule TintTest do
  use ExUnit.Case

  alias Tint.HSV
  alias Tint.RGB

  doctest Tint

  describe "to_hsv/1" do
    test "convert color to HSV" do
      assert Tint.to_hsv(RGB.new(0, 50, 100)) == HSV.new(210, 1, 0.392)
    end
  end

  describe "to_rgb/1" do
    test "convert color to RGB" do
      assert Tint.to_rgb(HSV.new(210, 1, 0.392)) == RGB.new(0, 50, 100)
    end
  end
end
