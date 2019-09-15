defmodule Tint.HSVTest do
  use ExUnit.Case, async: true

  alias Tint.HSV
  alias Tint.OutOfRangeError
  alias Tint.RGB

  describe "new/1" do
    test "build HSV color" do
      assert HSV.new(332.763, 0.94356, 0.4) == %HSV{
               hue: Decimal.new("332.7"),
               saturation: Decimal.new("0.943"),
               value: Decimal.new("0.400")
             }

      assert HSV.new(332.763, 0.9, 0.4343) == %HSV{
               hue: Decimal.new("332.7"),
               saturation: Decimal.new("0.900"),
               value: Decimal.new("0.434")
             }
    end

    test "raise when hue out of range" do
      assert_raise OutOfRangeError, fn ->
        HSV.new(-1, 0, 0)
      end

      assert_raise OutOfRangeError, fn ->
        HSV.new(360, 0, 0)
      end
    end

    test "raise when saturation out of range" do
      assert_raise OutOfRangeError, fn ->
        HSV.new(0, -1, 0)
      end

      assert_raise OutOfRangeError, fn ->
        HSV.new(0, 1.1, 0)
      end

      assert_raise OutOfRangeError, fn ->
        HSV.new(0, 2, 0)
      end
    end

    test "raise when value out of range" do
      assert_raise OutOfRangeError, fn ->
        HSV.new(0, 0, -1)
      end

      assert_raise OutOfRangeError, fn ->
        HSV.new(0, 0, 1.1)
      end

      assert_raise OutOfRangeError, fn ->
        HSV.new(0, 0, 2)
      end
    end
  end

  describe "from_tuple/1" do
    test "convert tuple to HSV struct" do
      assert HSV.from_tuple({332.763, 0.943, 0.4}) == HSV.new(332.7, 0.943, 0.4)
    end

    test "raise when invalid arg given" do
      assert_raise FunctionClauseError, fn ->
        HSV.from_tuple({332.763, 0.943})
      end

      assert_raise FunctionClauseError, fn ->
        HSV.from_tuple(nil)
      end
    end
  end

  describe "to_tuple/1" do
    test "get tuple" do
      assert HSV.to_tuple(HSV.new(332.763, 0.943, 0.4)) == {332.7, 0.943, 0.4}
    end
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
