defmodule TintTest do
  use ExUnit.Case

  alias Tint.RGB

  describe "convert/2" do
    test "no-op when source color already has target colorspace" do
      color = RGB.new(123, 45, 67)

      assert Tint.convert(color, RGB) == {:ok, color}
    end

    test "convert color to another colorspace"

    test "conversion error"
  end

  describe "convert!/2" do
    test "no-op when source color already has target colorspace" do
      color = RGB.new(123, 45, 67)

      assert Tint.convert!(color, RGB) == color
    end

    test "convert color to another colorspace"

    test "conversion error"
  end
end
