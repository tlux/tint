defmodule Tint.CIELABTest do
  use ExUnit.Case, async: true

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
    test ""
  end

  describe "nearest/2" do
  end

  describe "CIELAB.Convertible.to_lab/1" do
    test "convert to CIELAB" do
      color = CIELAB.new(50, 10, 10)

      assert CIELAB.Convertible.to_lab(color) == color
    end
  end
end
