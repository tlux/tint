defmodule Tint.CIELABTest do
  use ExUnit.Case, async: true

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

  describe "nearest_color/2" do
    # TODO
  end

  describe "nearest_color/3" do
    # TODO
  end

  describe "nearest_colors/3" do
    # TODO
  end

  describe "nearest_colors/4" do
    # TODO
  end

  describe "CIELAB.Convertible.to_lab/1" do
    test "convert to CIELAB" do
      color = CIELAB.new(50, 10, 10)

      assert CIELAB.Convertible.to_lab(color) == color
    end
  end
end
