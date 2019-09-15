defmodule Tint.RGBTest do
  use ExUnit.Case

  alias Tint.HSV
  alias Tint.OutOfRangeError
  alias Tint.RGB

  describe "new/3" do
    test "success" do
      for num <- 0..255 do
        assert RGB.new(num, 0, 0) == %RGB{red: num, green: 0, blue: 0}

        assert RGB.new(to_string(num), 0, 0) == %RGB{
                 red: num,
                 green: 0,
                 blue: 0
               }

        assert RGB.new(0, num, 0) == %RGB{red: 0, green: num, blue: 0}

        assert RGB.new(0, to_string(num), 0) == %RGB{
                 red: 0,
                 green: num,
                 blue: 0
               }

        assert RGB.new(0, 0, num) == %RGB{red: 0, green: 0, blue: num}

        assert RGB.new(0, 0, to_string(num)) == %RGB{
                 red: 0,
                 green: 0,
                 blue: num
               }
      end
    end

    test "raise when red part out of range" do
      assert_raise OutOfRangeError, fn ->
        RGB.new(256, 0, 0)
      end

      assert_raise OutOfRangeError, fn ->
        RGB.new(-1, 0, 0)
      end
    end

    test "raise when green part out of range" do
      assert_raise OutOfRangeError, fn ->
        RGB.new(0, 256, 0)
      end

      assert_raise OutOfRangeError, fn ->
        RGB.new(0, -1, 0)
      end
    end

    test "raise when blue part out of range" do
      assert_raise OutOfRangeError, fn ->
        RGB.new(0, 0, 256)
      end

      assert_raise OutOfRangeError, fn ->
        RGB.new(0, 0, -1)
      end
    end
  end

  describe "from_hex/1" do
    test "convert hex code to RGB color struct" do
      assert RGB.from_hex("#000000") == {:ok, RGB.new(0, 0, 0)}
      assert RGB.from_hex("#000") == {:ok, RGB.new(0, 0, 0)}
      assert RGB.from_hex("#FFFFFF") == {:ok, RGB.new(255, 255, 255)}
      assert RGB.from_hex("#FFF") == {:ok, RGB.new(255, 255, 255)}
      assert RGB.from_hex("#ffffff") == {:ok, RGB.new(255, 255, 255)}
      assert RGB.from_hex("#fff") == {:ok, RGB.new(255, 255, 255)}
      assert RGB.from_hex("#FFcc00") == {:ok, RGB.new(255, 204, 0)}
      assert RGB.from_hex("#fc0") == {:ok, RGB.new(255, 204, 0)}
      assert RGB.from_hex("#8a0843") == {:ok, RGB.new(138, 8, 67)}
      assert RGB.from_hex("#B5C8F0") == {:ok, RGB.new(181, 200, 240)}
    end

    test "parse error" do
      assert RGB.from_hex("000000") == :error
      assert RGB.from_hex("#FFFFF") == :error
      assert RGB.from_hex("#FFFFFG") == :error
      assert RGB.from_hex("#fffffg") == :error
      assert RGB.from_hex("#-ABDDE") == :error
    end
  end

  describe "from_hex!/1" do
    test "convert hex code to RGB color struct" do
      assert RGB.from_hex!("#000000") == RGB.new(0, 0, 0)
      assert RGB.from_hex!("#000") == RGB.new(0, 0, 0)
      assert RGB.from_hex!("#FFFFFF") == RGB.new(255, 255, 255)
      assert RGB.from_hex!("#FFF") == RGB.new(255, 255, 255)
      assert RGB.from_hex!("#ffffff") == RGB.new(255, 255, 255)
      assert RGB.from_hex!("#fff") == RGB.new(255, 255, 255)
      assert RGB.from_hex!("#FFcc00") == RGB.new(255, 204, 0)
      assert RGB.from_hex!("#fc0") == RGB.new(255, 204, 0)
      assert RGB.from_hex!("#8a0843") == RGB.new(138, 8, 67)
      assert RGB.from_hex!("#B5C8F0") == RGB.new(181, 200, 240)
    end

    test "parse error" do
      Enum.each(
        [
          "000000",
          "#FFFFF",
          "#FFFFFG",
          "#fffffg",
          "#-ABDDE"
        ],
        fn hex_code ->
          assert_raise ArgumentError,
                       "Invalid hex code: #{hex_code}",
                       fn ->
                         RGB.from_hex!(hex_code)
                       end
        end
      )
    end
  end

  describe "to_hex/1" do
    test "convert RGB color struct to hex code" do
      assert RGB.to_hex(RGB.new(0, 0, 0)) == "#000000"
      assert RGB.to_hex(RGB.new(255, 255, 255)) == "#FFFFFF"
      assert RGB.to_hex(RGB.new(255, 204, 0)) == "#FFCC00"
      assert RGB.to_hex(RGB.new(138, 8, 67)) == "#8A0843"
      assert RGB.to_hex(RGB.new(181, 200, 240)) == "#B5C8F0"
    end
  end

  describe "RGB.Convertible.to_rgb/1" do
    test "convert to RGB" do
      colors = [
        RGB.new(0, 0, 0),
        RGB.new(255, 255, 255),
        RGB.new(255, 204, 0),
        RGB.new(138, 8, 67),
        RGB.new(181, 200, 240)
      ]

      Enum.each(colors, fn color ->
        assert RGB.Convertible.to_rgb(color) == color
      end)
    end
  end

  describe "HSV.Convertible.to_hsv/1" do
    test "convert to HSV" do
      assert HSV.Convertible.to_hsv(RGB.new(0, 0, 0)) ==
               HSV.new(0, 0.0, 0.0)

      assert HSV.Convertible.to_hsv(RGB.new(255, 255, 255)) ==
               HSV.new(0, 0.0, 1.0)

      assert HSV.Convertible.to_hsv(RGB.new(255, 204, 0)) ==
               HSV.new(48.0, 1.0, 1.0)

      assert HSV.Convertible.to_hsv(RGB.new(138, 8, 67)) ==
               HSV.new(
                 Decimal.new("332.7"),
                 Decimal.new("0.942"),
                 Decimal.new("0.541")
               )

      assert HSV.Convertible.to_hsv(RGB.new(181, 200, 240)) ==
               HSV.new(
                 Decimal.new("220.6"),
                 Decimal.new("0.245"),
                 Decimal.new("0.941")
               )
    end
  end
end
