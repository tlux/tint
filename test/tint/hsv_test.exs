defmodule Tint.HSVTest do
  use ExUnit.Case, async: true

  alias Tint.CMYK
  alias Tint.DIN99
  alias Tint.HSV
  alias Tint.Lab
  alias Tint.OutOfRangeError
  alias Tint.RGB
  alias Tint.XYZ

  describe "new/1" do
    test "build HSV color" do
      assert HSV.new(332, 1, 0) == %HSV{
               hue: 332.0,
               saturation: 1.0,
               value: 0.0
             }

      assert HSV.new(332.763, 0.94356, 0.4) == %HSV{
               hue: 332.763,
               saturation: 0.94356,
               value: 0.4
             }

      assert HSV.new("332.763", "0.94356", "0.4343") == %HSV{
               hue: 332.763,
               saturation: 0.94356,
               value: 0.4343
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
      assert HSV.from_tuple({332.763, 0.943, 0.4}) ==
               HSV.new(332.763, 0.943, 0.4)
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
      assert HSV.to_tuple(HSV.new(332.763, 0.943, 0.4)) ==
               {332.763, 0.943, 0.4}
    end
  end

  describe "grayscale?/1" do
    test "true when color is grayscale color" do
      assert HSV.grayscale?(HSV.new(0, 1, 0)) == true
      assert HSV.grayscale?(HSV.new(0, 0, 0)) == true
      assert HSV.grayscale?(HSV.new(0, 0, 0.5)) == true
      assert HSV.grayscale?(HSV.new(0, 0, 1)) == true
    end

    test "false when color is no grayscale color" do
      assert HSV.grayscale?(HSV.new(0, 1, 1)) == false
      assert HSV.grayscale?(HSV.new(45, 0.5, 1)) == false
      assert HSV.grayscale?(HSV.new(60, 0.25, 1)) == false
      assert HSV.grayscale?(HSV.new(90, 0.25, 1)) == false
      assert HSV.grayscale?(HSV.new(180, 0.25, 0.5)) == false
    end
  end

  describe "hue_between?/3" do
    @color HSV.new(332.7, 0.943, 0.4)

    test "is true when hue in range" do
      assert HSV.hue_between?(@color, 0, 359) == true
      assert HSV.hue_between?(@color, 0, 360) == true
      assert HSV.hue_between?(@color, 332, 340) == true
      assert HSV.hue_between?(@color, 332.7, 340) == true
    end

    test "is false when hue not in range" do
      assert HSV.hue_between?(@color, 0, 332) == false
      assert HSV.hue_between?(@color, 0, 332.7) == false
      assert HSV.hue_between?(@color, 333, 350) == false
    end

    test "raise min greater than max" do
      assert_raise FunctionClauseError, fn ->
        HSV.hue_between?(@color, 120, 50)
      end
    end
  end

  describe "Kernel.inspect/1" do
    test "inspect" do
      assert inspect(HSV.new(332.763, 0.943, 0.4)) ==
               "#Tint.HSV<332.763°,94.3%,40.0%>"
    end
  end

  describe "CMYK.Convertible.convert/1" do
    test "convert to CMYK" do
      conversions = [
        {HSV.new(0, 0, 0), CMYK.new(0, 0, 0, 1)},
        {HSV.new(0, 0, 1), CMYK.new(0, 0, 0, 0)},
        {HSV.new(0, 1, 1), CMYK.new(0, 1, 1, 0)},
        {HSV.new(120, 1, 1), CMYK.new(1, 0, 1, 0)},
        {HSV.new(240, 1, 1), CMYK.new(1, 1, 0, 0)},
        {HSV.new(60, 1, 1), CMYK.new(0, 0, 1, 0)},
        {HSV.new(180, 1, 1), CMYK.new(1, 0, 0, 0)},
        {HSV.new(300, 1, 1), CMYK.new(0, 1, 0, 0)},
        {HSV.new(0, 0, 0.749), CMYK.new(0, 0, 0, "0.251")},
        {HSV.new(0, 0, 0.501), CMYK.new(0, 0, 0, "0.498")},
        {HSV.new(0, 1, 0.501), CMYK.new(0, 1, 1, "0.498")},
        {HSV.new(60, 1, 0.501), CMYK.new(0, 0, 1, "0.498")},
        {HSV.new(120, 1, 0.501), CMYK.new(1, 0, 1, "0.498")},
        {HSV.new(300, 1, 0.501), CMYK.new(0, 1, 0, "0.498")},
        {HSV.new(180, 1, 0.501), CMYK.new(1, 0, 0, "0.498")},
        {HSV.new(240, 1, 0.501), CMYK.new(1, 1, 0, "0.498")}
      ]

      Enum.each(conversions, fn {hsv, cmyk} ->
        assert CMYK.Convertible.convert(hsv) == cmyk
      end)
    end
  end

  describe "DIN99.Convertible.convert/1" do
    test "convert to DIN99" do
      color = HSV.new(332.763, 0.94356, 0.4)

      assert DIN99.Convertible.convert(color) ==
               DIN99.new(29.9041, -22.9248, 4.1468)
    end
  end

  describe "HSV.Convertible.convert/1" do
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
        assert HSV.Convertible.convert(color) == color
      end)
    end
  end

  describe "Lab.Convertible.convert/1" do
    test "convert to Lab" do
      color = HSV.new(332.763, 0.94356, 0.4)

      assert Lab.Convertible.convert(color) == Lab.new(20.7385, 41.8182, 1.6384)
    end
  end

  describe "RGB.Convertible.convert/1" do
    test "convert to RGB" do
      conversions = [
        {HSV.new(0, 0, 0), RGB.new(0, 0, 0)},
        {HSV.new(0, 0, 1), RGB.new(255, 255, 255)},
        {HSV.new(0, 1, 1), RGB.new(255, 0, 0)},
        {HSV.new(120, 1, 1), RGB.new(0, 255, 0)},
        {HSV.new(240, 1, 1), RGB.new(0, 0, 255)},
        {HSV.new(60, 1, 1), RGB.new(255, 255, 0)},
        {HSV.new(180, 1, 1), RGB.new(0, 255, 255)},
        {HSV.new(300, 1, 1), RGB.new(255, 0, 255)},
        {HSV.new(0, 0, "0.75"), RGB.new(191, 191, 191)},
        {HSV.new(0, 0, "0.5"), RGB.new(128, 128, 128)},
        {HSV.new(0, 1, "0.5"), RGB.new(128, 0, 0)},
        {HSV.new(60, 1, "0.5"), RGB.new(128, 128, 0)},
        {HSV.new(120, 1, "0.5"), RGB.new(0, 128, 0)},
        {HSV.new(300, 1, "0.5"), RGB.new(128, 0, 128)},
        {HSV.new(180, 1, "0.5"), RGB.new(0, 128, 128)},
        {HSV.new(240, 1, "0.5"), RGB.new(0, 0, 128)}
      ]

      Enum.each(conversions, fn {hsv, rgb} ->
        assert RGB.Convertible.convert(hsv) == rgb
      end)
    end
  end

  describe "XYZ.Convertible.convert/1" do
    test "convert to Lab" do
      color = HSV.new(332.763, 0.94356, 0.4)

      assert XYZ.Convertible.convert(color) == XYZ.new(6.099, 3.1768, 3.1975)
    end
  end
end
