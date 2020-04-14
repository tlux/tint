defmodule Tint.CMYKTest do
  use ExUnit.Case, async: true

  alias Tint.CMYK
  alias Tint.HSV
  alias Tint.OutOfRangeError
  alias Tint.RGB

  doctest Tint.CMYK

  describe "new/4" do
    test "build CMYK color" do
      assert CMYK.new(1, 0, 0, 1) == %CMYK{
               cyan: 1.0,
               magenta: 0.0,
               yellow: 0.0,
               key: 1.0
             }

      assert CMYK.new(0.06, 0.32, 0.8846, 0.23) == %CMYK{
               cyan: 0.06,
               magenta: 0.32,
               yellow: 0.8846,
               key: 0.23
             }

      assert CMYK.new("0.06", "0.32", "0.8846", "0.23") == %CMYK{
               cyan: 0.06,
               magenta: 0.32,
               yellow: 0.8846,
               key: 0.23
             }
    end

    test "raise when cyan part out of range" do
      assert_raise OutOfRangeError, fn ->
        CMYK.new(-1, 0, 0, 0)
      end

      assert_raise OutOfRangeError, fn ->
        CMYK.new(1.1, 0, 0, 0)
      end
    end

    test "raise when magenta part out of range" do
      assert_raise OutOfRangeError, fn ->
        CMYK.new(0, -1, 0, 0)
      end

      assert_raise OutOfRangeError, fn ->
        CMYK.new(0, 1.1, 0, 0)
      end
    end

    test "raise when yellow part out of range" do
      assert_raise OutOfRangeError, fn ->
        CMYK.new(0, 0, -1, 0)
      end

      assert_raise OutOfRangeError, fn ->
        CMYK.new(0, 0, 1.1, 0)
      end
    end

    test "raise when key part out of range" do
      assert_raise OutOfRangeError, fn ->
        CMYK.new(0, 0, 0, -1)
      end

      assert_raise OutOfRangeError, fn ->
        CMYK.new(0, 0, 0, 1.1)
      end
    end
  end

  describe "from_tuple/1" do
    test "convert tuple to CMYK struct" do
      assert CMYK.from_tuple({1, 0, "0.8846", 0.23}) == %CMYK{
               cyan: 1.0,
               magenta: 0.0,
               yellow: 0.8846,
               key: 0.23
             }
    end

    test "raise when invalid arg given" do
      assert_raise FunctionClauseError, fn ->
        CMYK.from_tuple({332.763, 0.943})
      end

      assert_raise FunctionClauseError, fn ->
        CMYK.from_tuple(nil)
      end
    end
  end

  describe "to_tuple/1" do
    test "get tuple" do
      assert CMYK.to_tuple(CMYK.new(0.06, 0.32, 0.8846, 0.23)) ==
               {0.060, 0.320, 0.8846, 0.230}
    end
  end

  describe "Kernel.inspect/1" do
    test "inspect" do
      assert inspect(CMYK.new(0.06, 0.32, 0.8846, 0.23)) ==
               "#Tint.CMYK<6.0%,32.0%,88.46%,23.0%>"
    end
  end

  describe "CMYK.Convertible.convert/1" do
    test "convert to CMYK" do
      colors = [
        CMYK.new(0, 0, 0, 1),
        CMYK.new(0, 0, 0, 0),
        CMYK.new(1, 0, 0, "0.498"),
        CMYK.new(1, 1, 0, "0.498")
      ]

      Enum.each(colors, fn color ->
        assert CMYK.Convertible.convert(color) == color
      end)
    end
  end

  describe "HSV.Convertible.convert/1" do
    test "convert to HSV" do
      conversions = [
        {CMYK.new(0, 0, 0, 1), HSV.new(0, 0, 0)},
        {CMYK.new(0, 0, 0, 0), HSV.new(0, 0, 1)},
        {CMYK.new(0, 1, 1, 0), HSV.new(0, 1, 1)},
        {CMYK.new(1, 0, 1, 0), HSV.new(120, 1, 1)},
        {CMYK.new(1, 1, 0, 0), HSV.new(240, 1, 1)},
        {CMYK.new(0, 0, 1, 0), HSV.new(60, 1, 1)},
        {CMYK.new(1, 0, 0, 0), HSV.new(180, 1, 1)},
        {CMYK.new(0, 1, 0, 0), HSV.new(300, 1, 1)},
        {CMYK.new(0, 0, 0, "0.25"), HSV.new(0, 0, 0.749)},
        {CMYK.new(0, 0, 0, "0.498"), HSV.new(0, 0, 0.502)},
        {CMYK.new(0, 1, 1, "0.498"), HSV.new(0, 1, 0.502)},
        {CMYK.new(0, 0, 1, "0.498"), HSV.new(60, 1, 0.502)},
        {CMYK.new(1, 0, 1, "0.498"), HSV.new(120, 1, 0.502)},
        {CMYK.new(0, 1, 0, "0.498"), HSV.new(300, 1, 0.502)},
        {CMYK.new(1, 0, 0, "0.498"), HSV.new(180, 1, 0.502)},
        {CMYK.new(1, 1, 0, "0.498"), HSV.new(240, 1, 0.502)}
      ]

      Enum.each(conversions, fn {cmyk, hsv} ->
        assert HSV.Convertible.convert(cmyk) == hsv
      end)
    end
  end

  describe "RGB.Convertible.convert/1" do
    test "convert to RGB" do
      conversions = [
        {CMYK.new(0, 0, 0, 1), RGB.new(0, 0, 0)},
        {CMYK.new(0, 0, 0, 0), RGB.new(255, 255, 255)},
        {CMYK.new(0, 1, 1, 0), RGB.new(255, 0, 0)},
        {CMYK.new(1, 0, 1, 0), RGB.new(0, 255, 0)},
        {CMYK.new(1, 1, 0, 0), RGB.new(0, 0, 255)},
        {CMYK.new(0, 0, 1, 0), RGB.new(255, 255, 0)},
        {CMYK.new(1, 0, 0, 0), RGB.new(0, 255, 255)},
        {CMYK.new(0, 1, 0, 0), RGB.new(255, 0, 255)},
        {CMYK.new(0, 0, 0, "0.25"), RGB.new(191, 191, 191)},
        {CMYK.new(0, 0, 0, "0.498"), RGB.new(128, 128, 128)},
        {CMYK.new(0, 1, 1, "0.498"), RGB.new(128, 0, 0)},
        {CMYK.new(0, 0, 1, "0.498"), RGB.new(128, 128, 0)},
        {CMYK.new(1, 0, 1, "0.498"), RGB.new(0, 128, 0)},
        {CMYK.new(0, 1, 0, "0.498"), RGB.new(128, 0, 128)},
        {CMYK.new(1, 0, 0, "0.498"), RGB.new(0, 128, 128)},
        {CMYK.new(1, 1, 0, "0.498"), RGB.new(0, 0, 128)}
      ]

      Enum.each(conversions, fn {cmyk, rgb} ->
        assert RGB.Convertible.convert(cmyk) == rgb
      end)
    end
  end
end
