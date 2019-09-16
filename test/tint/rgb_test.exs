defmodule Tint.RGBTest do
  use ExUnit.Case

  import Tint.Sigil

  alias Tint.HSV
  alias Tint.OutOfRangeError
  alias Tint.RGB

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

  describe "to_tuple" do
    test "get tuple" do
      assert RGB.to_tuple(RGB.new(123, 45, 67)) == {123, 45, 67}
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

  describe "euclidean_distance/2" do
    test "get Euclidean distance for two colors" do
      assert RGB.euclidean_distance(~K[#FFFFFF], ~K[#000000]) ==
               441.6729559300637

      assert RGB.euclidean_distance(~K[#000000], ~K[#FFFFFF]) ==
               441.6729559300637

      assert RGB.euclidean_distance(~K[#FF0000], ~K[#FC0000]) == 3.0

      assert RGB.euclidean_distance(~K[#FFCC00], ~K[#FCFFCC]) ==
               210.2997860198626
    end
  end

  describe "euclidean_distance/3" do
    # TODO
  end

  describe "nearest/2" do
    test "is nil when palette is empty" do
      color = ~K[#FF0000]

      palette = [
        ~K[#FCFF00],
        ~K[#CCFF00],
        ~K[#CC0000],
        ~K[#FC0000],
        ~K[#00CCFF],
        ~K[#000FFF]
      ]

      assert RGB.nearest(color, []) ==
               RGB.nearest(color, [], &RGB.human_euclidean_distance/2)

      assert RGB.nearest(color, palette) ==
               RGB.nearest(color, palette, &RGB.human_euclidean_distance/2)
    end
  end

  describe "nearest/3" do
    test "is nil when palette is empty" do
      color = ~K[#FF0000]

      assert RGB.nearest(color, [], &RGB.human_euclidean_distance/2) == nil
    end

    test "get nearest color" do
      algorithm = &RGB.human_euclidean_distance/2

      palette = [
        ~K[#FCFF00],
        ~K[#00FF00],
        ~K[#CC0000],
        ~K[#FF9900],
        ~K[#00CCFF],
        ~K[#000FFF],
        ~K[#333333]
      ]

      assert RGB.nearest(~K[#FF0000], palette, algorithm) ==
               ~K[#CC0000]

      assert RGB.nearest(~K[#FFCC00], palette, algorithm) ==
               ~K[#FF9900]

      assert RGB.nearest(~K[#000000], palette, algorithm) ==
               ~K[#333333]

      assert RGB.nearest(~K[#10A110], palette, algorithm) ==
               ~K[#00FF00]

      assert RGB.nearest(~K[#0497D6], palette, algorithm) ==
               ~K[#00CCFF]
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
end
