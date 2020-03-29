defmodule Tint.CIELABTest do
  use ExUnit.Case, async: true

  import Tint.Sigil

  alias Tint.CIELAB

  describe "new/3" do
    test "build CIELAB color" do
      assert CIELAB.new(50.1234, 10.7643, 10.4322) == %CIELAB{
               lightness: Decimal.new("50.1234"),
               a: Decimal.new("10.7643"),
               b: Decimal.new("10.4322")
             }
    end
  end

  describe "nearest/2" do
    test "delegate to nearest/3 with CIEDE2000 algorithm" do
      color = Tint.to_lab(~K[#FF0000])
      palette = [~K[#E7CDB0], ~K[#00A1DE], ~K[#B76A40], ~K[#FECB00]]

      assert CIELAB.nearest(color, palette) ==
               CIELAB.nearest(color, palette, &CIELAB.ciede2000_distance/2)
    end
  end

  describe "CIELAB.Convertible.to_lab/1" do
    test "convert to CIELAB" do
      color = CIELAB.new(50, 10, 10)

      assert CIELAB.Convertible.to_lab(color) == color
    end
  end
end
