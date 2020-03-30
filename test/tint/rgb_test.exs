defmodule Tint.RGBTest do
  use ExUnit.Case

  import Tint.Sigil

  alias Tint.CMYK
  alias Tint.DIN99
  alias Tint.Distance.Euclidean
  alias Tint.HSV
  alias Tint.Lab
  alias Tint.OutOfRangeError
  alias Tint.RGB
  alias Tint.XYZ

  doctest Tint.RGB

  describe "new/3" do
    test "build RGB color" do
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

  describe "euclidean_distance/2" do
    test "delegate to Distance.Euclidean" do
      color = ~K[#FFFF00]
      other_color = ~K[#FF0000]

      assert RGB.euclidean_distance(color, other_color) ==
               Euclidean.distance(color, other_color, [])
    end
  end

  describe "euclidean_distance/3" do
    test "delegate to Distance.Euclidean" do
      color = ~K[#FFFF00]
      other_color = ~K[#FF0000]
      opts = [weights: {2, 3, 4}]

      assert RGB.euclidean_distance(color, other_color, opts) ==
               Euclidean.distance(color, other_color, opts)
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

  describe "from_ratios/3" do
    test "build RGB color" do
      assert RGB.from_ratios(0, 0, 0) == RGB.new(0, 0, 0)
      assert RGB.from_ratios(1, 1, 1) == RGB.new(255, 255, 255)
      assert RGB.from_ratios(0.5, 0.3, 0.2) == RGB.new(128, 77, 51)
    end

    test "raise when red part out of range" do
      assert_raise OutOfRangeError, fn ->
        RGB.from_ratios(-1, 0, 0)
      end

      assert_raise OutOfRangeError, fn ->
        RGB.from_ratios(1.1, 0, 0)
      end
    end

    test "raise when green part out of range" do
      assert_raise OutOfRangeError, fn ->
        RGB.from_ratios(0, -1, 0)
      end

      assert_raise OutOfRangeError, fn ->
        RGB.from_ratios(0, 1.1, 0)
      end
    end

    test "raise when blue part out of range" do
      assert_raise OutOfRangeError, fn ->
        RGB.from_ratios(0, 0, -1)
      end

      assert_raise OutOfRangeError, fn ->
        RGB.from_ratios(0, 0, 1.1)
      end
    end
  end

  describe "from_tuple/1" do
    test "convert tuple to RGB struct" do
      assert RGB.from_tuple({123, 45, 67}) == RGB.new(123, 45, 67)
    end

    test "raise when invalid arg given" do
      assert_raise FunctionClauseError, fn ->
        RGB.from_tuple({332.763, 0.943})
      end

      assert_raise FunctionClauseError, fn ->
        RGB.from_tuple(nil)
      end
    end
  end

  describe "grayscale?/1" do
    test "is true for grayscale colors" do
      assert RGB.grayscale?(~K[#000000]) == true
      assert RGB.grayscale?(~K[#333333]) == true
      assert RGB.grayscale?(~K[#666666]) == true
      assert RGB.grayscale?(~K[#999999]) == true
      assert RGB.grayscale?(~K[#CCCCCC]) == true
      assert RGB.grayscale?(~K[#EEEEEE]) == true
      assert RGB.grayscale?(~K[#FFFFFF]) == true
    end

    test "is false for non-grayscale colors" do
      assert RGB.grayscale?(~K[#FF0000]) == false
      assert RGB.grayscale?(~K[#FF9900]) == false
      assert RGB.grayscale?(~K[#00FFFF]) == false
      assert RGB.grayscale?(~K[#000FFF]) == false
      assert RGB.grayscale?(~K[#00FF99]) == false
      assert RGB.grayscale?(~K[#99FF00]) == false
      assert RGB.grayscale?(~K[#FFFF00]) == false
    end
  end

  describe "grayish?/2" do
    test "is true for grayscale colors" do
      assert RGB.grayish?(~K[#000000], 0) == true
      assert RGB.grayish?(~K[#666666], 0) == true
      assert RGB.grayish?(~K[#FFFFFF], 0) == true
      assert RGB.grayish?(~K[#000000], 20) == true
      assert RGB.grayish?(~K[#666666], 20) == true
      assert RGB.grayish?(~K[#FFFFFF], 20) == true
    end

    test "is true for non-grayscale colors within tolerance" do
      assert RGB.grayish?(RGB.new(12, 12, 12), 20) == true
      assert RGB.grayish?(RGB.new(12, 32, 16), 20) == true
      assert RGB.grayish?(RGB.new(12, 16, 32), 20) == true
      assert RGB.grayish?(RGB.new(32, 12, 16), 20) == true
    end

    test "is false for non-grayscale colors out of tolerance" do
      assert RGB.grayish?(~K[#FF0000], 0) == false
      assert RGB.grayish?(~K[#FF0000], 20) == false
      assert RGB.grayish?(~K[#000FFF], 20) == false
      assert RGB.grayish?(~K[#99FF00], 20) == false
      assert RGB.grayish?(~K[#FFFF00], 20) == false
      assert RGB.grayish?(RGB.new(12, 32, 16), 10) == false
      assert RGB.grayish?(RGB.new(12, 33, 16), 20) == false
      assert RGB.grayish?(RGB.new(12, 16, 33), 20) == false
      assert RGB.grayish?(RGB.new(33, 12, 16), 20) == false
    end

    test "raise when tolerance is out of range" do
      assert_raise OutOfRangeError, "Value -1 is out of range [0,255]", fn ->
        RGB.grayish?(RGB.new(33, 12, 16), -1)
      end

      assert_raise OutOfRangeError, "Value 256 is out of range [0,255]", fn ->
        RGB.grayish?(RGB.new(33, 12, 16), 256)
      end
    end
  end

  describe "nearest_color/2" do
    test "delegate to nearest_color/3 with euclidean distance algorithm" do
      color = ~K[#FF0000]
      palette = [~K[#FCFF00], ~K[#CCFF00], ~K[#CC0000]]

      assert RGB.nearest_color(color, []) ==
               RGB.nearest_color(color, [], Euclidean)

      assert RGB.nearest_color(color, palette) ==
               RGB.nearest_color(color, palette, Euclidean)
    end
  end

  describe "nearest_color/3" do
    test "is nil when palette is empty" do
      assert RGB.nearest_color(~K[#FF0000], [], Euclidean) == nil
    end

    test "get nearest color" do
      palette = [
        ~K[#FCFF00],
        ~K[#00FF00],
        ~K[#CC0000],
        ~K[#FF9900],
        ~K[#00CCFF],
        ~K[#000FFF],
        ~K[#333333]
      ]

      assert RGB.nearest_color(~K[#000000], palette, Euclidean) == ~K[#333333]
      assert RGB.nearest_color(~K[#004CA8], palette, Euclidean) == ~K[#000FFF]
      assert RGB.nearest_color(~K[#0497D6], palette, Euclidean) == ~K[#00CCFF]
      assert RGB.nearest_color(~K[#094F6E], palette, Euclidean) == ~K[#333333]
      assert RGB.nearest_color(~K[#10A110], palette, Euclidean) == ~K[#00FF00]
      assert RGB.nearest_color(~K[#666666], palette, Euclidean) == ~K[#333333]
      assert RGB.nearest_color(~K[#FF0000], palette, Euclidean) == ~K[#CC0000]
      assert RGB.nearest_color(~K[#FFCC00], palette, Euclidean) == ~K[#FF9900]
      assert RGB.nearest_color(~K[#FFEC70], palette, Euclidean) == ~K[#FCFF00]
      assert RGB.nearest_color(~K[#FFFFFF], palette, Euclidean) == ~K[#FCFF00]
    end
  end

  describe "nearest_colors/3" do
    test "delegate to nearest_colors/4 with euclidean distance algorithm" do
      color = ~K[#FF0000]
      palette = [~K[#FCFF00], ~K[#CCFF00], ~K[#CC0000]]

      assert RGB.nearest_colors(color, [], 2) ==
               RGB.nearest_colors(color, [], 2, Euclidean)

      assert RGB.nearest_colors(color, palette, 2) ==
               RGB.nearest_colors(color, palette, 2, Euclidean)
    end
  end

  describe "nearest_colors/4" do
    test "is empty list when palette is empty" do
      assert RGB.nearest_colors(~K[#FF0000], [], 2, Euclidean) == []
    end

    test "get nearest color" do
      palette = [
        ~K[#FCFF00],
        ~K[#CC0000],
        ~K[#FF9900],
        ~K[#000FFF],
        ~K[#333333]
      ]

      assert RGB.nearest_colors(~K[#000000], palette, 2, Euclidean) ==
               [~K[#333333], ~K[#CC0000]]

      assert RGB.nearest_colors(~K[#004CA8], palette, 2, Euclidean) ==
               [~K[#000FFF], ~K[#333333]]

      assert RGB.nearest_colors(~K[#FF0000], palette, 3, Euclidean) ==
               [~K[#CC0000], ~K[#FF9900], ~K[#333333]]

      assert RGB.nearest_colors(~K[#FFCC00], palette, 2, Euclidean) ==
               [~K[#FF9900], ~K[#FCFF00]]
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

  describe "to_tuple/1" do
    test "get tuple" do
      assert RGB.to_tuple(RGB.new(123, 45, 67)) == {123, 45, 67}
    end
  end

  describe "Kernel.inspect/1" do
    test "inspect" do
      assert inspect(RGB.new(255, 127, 30)) ==
               ~s[#Tint.RGB<255,127,30 (#FF7F1E)>]
    end
  end

  describe "Lab.Convertible.to_lab/1" do
    test "convert to Lab" do
      conversions = [
        {RGB.new(0, 0, 0), Lab.new(0, 0, 0)},
        {RGB.new(255, 255, 255), Lab.new(100, "0.0019", "-0.0098")},
        {RGB.new(255, 0, 0), Lab.new("53.2329", "80.1068", "67.2202")}
      ]

      Enum.each(conversions, fn {rgb, lab} ->
        assert Lab.Convertible.to_lab(rgb) == lab
      end)
    end
  end

  describe "CMYK.Convertible.to_cmyk/1" do
    test "convert to CMYK" do
      conversions = [
        {RGB.new(0, 0, 0), CMYK.new(0, 0, 0, 1)},
        {RGB.new(255, 255, 255), CMYK.new(0, 0, 0, 0)},
        {RGB.new(255, 0, 0), CMYK.new(0, 1, 1, 0)},
        {RGB.new(0, 255, 0), CMYK.new(1, 0, 1, 0)},
        {RGB.new(0, 0, 255), CMYK.new(1, 1, 0, 0)},
        {RGB.new(255, 255, 0), CMYK.new(0, 0, 1, 0)},
        {RGB.new(0, 255, 255), CMYK.new(1, 0, 0, 0)},
        {RGB.new(255, 0, 255), CMYK.new(0, 1, 0, 0)},
        {RGB.new(191, 191, 191), CMYK.new(0, 0, 0, "0.25")},
        {RGB.new(128, 128, 128), CMYK.new(0, 0, 0, "0.498")},
        {RGB.new(128, 0, 0), CMYK.new(0, 1, 1, "0.498")},
        {RGB.new(128, 128, 0), CMYK.new(0, 0, 1, "0.498")},
        {RGB.new(0, 128, 0), CMYK.new(1, 0, 1, "0.498")},
        {RGB.new(128, 0, 128), CMYK.new(0, 1, 0, "0.498")},
        {RGB.new(0, 128, 128), CMYK.new(1, 0, 0, "0.498")},
        {RGB.new(0, 0, 128), CMYK.new(1, 1, 0, "0.498")}
      ]

      Enum.each(conversions, fn {rgb, cmyk} ->
        assert CMYK.Convertible.to_cmyk(rgb) == cmyk
      end)
    end
  end

  describe "DIN99.Convertible.to_din99/1" do
    test "convert to DIN99" do
      conversions = [
        {RGB.new(0, 0, 0), DIN99.new(0, 0, 0)},
        {RGB.new(255, 255, 255), DIN99.new("100.0013", "0.001", "0.007")},
        {RGB.new(255, 0, 0), DIN99.new("64.3983", "-36.3321", "-10.9365")}
      ]

      Enum.each(conversions, fn {rgb, din99} ->
        assert DIN99.Convertible.to_din99(rgb) == din99
      end)
    end
  end

  describe "HSV.Convertible.to_hsv/1" do
    test "convert to HSV" do
      conversions = [
        {RGB.new(0, 0, 0), HSV.new(0, 0, 0)},
        {RGB.new(255, 255, 255), HSV.new(0, 0, 1)},
        {RGB.new(255, 0, 0), HSV.new(0, 1, 1)},
        {RGB.new(0, 255, 0), HSV.new(120, 1, 1)},
        {RGB.new(0, 0, 255), HSV.new(240, 1, 1)},
        {RGB.new(255, 255, 0), HSV.new(60, 1, 1)},
        {RGB.new(0, 255, 255), HSV.new(180, 1, 1)},
        {RGB.new(255, 0, 255), HSV.new(300, 1, 1)},
        {RGB.new(191, 191, 191), HSV.new(0, 0, 0.749)},
        {RGB.new(128, 128, 128), HSV.new(0, 0, 0.501)},
        {RGB.new(128, 0, 0), HSV.new(0, 1, 0.501)},
        {RGB.new(128, 128, 0), HSV.new(60, 1, 0.501)},
        {RGB.new(0, 128, 0), HSV.new(120, 1, 0.501)},
        {RGB.new(128, 0, 128), HSV.new(300, 1, 0.501)},
        {RGB.new(0, 128, 128), HSV.new(180, 1, 0.501)},
        {RGB.new(0, 0, 128), HSV.new(240, 1, 0.501)}
      ]

      Enum.each(conversions, fn {rgb, hsv} ->
        assert HSV.Convertible.to_hsv(rgb) == hsv
      end)
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

  describe "XYZ.Convertible.to_xyz/1" do
    test "convert to XYZ" do
      conversions = [
        {RGB.new(0, 0, 0), XYZ.new(0, 0, 0)},
        {RGB.new(0, 255, 162), XYZ.new(42.2816, 74.1286, 46.2622)},
        {RGB.new(255, 255, 255), XYZ.new(95.05, 100, 108.9)}
      ]

      Enum.each(conversions, fn {rgb, xyz} ->
        assert XYZ.Convertible.to_xyz(rgb) == xyz
      end)
    end
  end
end
