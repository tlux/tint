defmodule Tint.CIELABTest do
  use ExUnit.Case, async: true

  import Tint.Sigil

  alias Tint.CIELAB

  describe "new/3" do
    test "build CIELAB color" do
      assert CIELAB.new(50.1234, 10.7643, 10.4322) == %CIELAB{
               l: Decimal.new("50.123"),
               a: Decimal.new("10.764"),
               b: Decimal.new("10.432")
             }
    end
  end

  describe "delta_e/2" do
    test "get Delta E for two colors"
  end

  describe "nearest/2" do
    test "delegate to nearest/3 with delta E algorithm"
  end

  describe "nearest/3" do
    test "is nil when palette is empty" do
      assert ~K[#FF0000]
             |> Tint.to_lab()
             |> CIELAB.nearest([], &CIELAB.delta_e/2) == nil
    end

    test "get nearest color" do
      distance_algorithm = &CIELAB.delta_e/2

      palette = [
        ~K[#E7CDB0],
        ~K[#00A1DE],
        ~K[#B76A40],
        ~K[#FECB00],
        ~K[#6C6C6C],
        ~K[#89D63D],
        ~K[#B357B3],
        ~K[#D6FFD6],
        ~K[#FF9A1E],
        ~K[#FF0066],
        ~K[#FFC0CB],
        ~K[#D71F1F],
        ~K[#000000],
        ~K[#D0D0D0],
        ~K[#5DF6FF],
        ~K[#FFFFFF]
      ]

      Enum.each(
        [
          {"#FF0000", "#D71F1F"},
          {"#0DFF00", "#89D63D"},
          {"#0000F0", "#B357B3"},
          {"#1FE7FF", "#5DF6FF"},
          {"#243C5C", "#6C6C6C"},
          {"#2A7268", "#6C6C6C"},
          {"#799DC9", "#00A1DE"},
          {"#73A0B9", "#00A1DE"},
          {"#64A7AC", "#6C6C6C"}
        ],
        fn {color, mapped_color} ->
          assert color
                 |> Tint.RGB.from_hex!()
                 |> Tint.to_lab()
                 |> CIELAB.nearest(palette, distance_algorithm)
                 |> Tint.RGB.to_hex() == mapped_color
        end
      )
    end
  end

  describe "CIELAB.Convertible.to_lab/1" do
    test "convert to CIELAB" do
      color = CIELAB.new(50, 10, 10)

      assert CIELAB.Convertible.to_lab(color) == color
    end
  end
end
