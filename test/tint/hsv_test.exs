defmodule Tint.HSVTest do
  use ExUnit.Case, async: true

  alias Tint.HSV
  alias Tint.RGB

  describe "new/1" do
    # TODO
  end

  describe "HSV.Convertible.to_hsv/1" do
    test "convert to HSV" do
      colors = [
        HSV.new(0, 0.0, 0.0),
        HSV.new(0, 0.0, 1.0),
        HSV.new(48.0, 1.0, 1.0),
        HSV.new(
          332.7692307692308,
          0.9420289855072463,
          0.5411764705882353
        ),
        HSV.new(
          220.67796610169492,
          0.2458333333333333,
          0.9411764705882353
        )
      ]

      Enum.each(colors, fn color ->
        assert HSV.Convertible.to_hsv(color) == color
      end)
    end
  end

  describe "RGB.Convertible.to_rgb/1" do
    test "convert to RGB" do
      assert RGB.Convertible.to_rgb(HSV.new(0, 0.0, 0.0)) == RGB.new(0, 0, 0)

      assert RGB.Convertible.to_rgb(HSV.new(0, 0.0, 1.0)) ==
               RGB.new(255, 255, 255)

      assert RGB.Convertible.to_rgb(HSV.new(48.0, 1.0, 1.0)) ==
               RGB.new(255, 204, 0)

      assert RGB.Convertible.to_rgb(
               HSV.new(
                 332.7692307692308,
                 0.9420289855072463,
                 0.5411764705882353
               )
             ) == RGB.new(138, 8, 67)

      assert RGB.Convertible.to_rgb(
               HSV.new(
                 220.67796610169492,
                 0.2458333333333333,
                 0.9411764705882353
               )
             ) == RGB.new(181, 200, 240)
    end
  end
end
