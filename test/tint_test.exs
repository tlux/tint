defmodule TintTest do
  use ExUnit.Case

  alias Tint.RGB
  alias Tint.TestConvertible
  alias Tint.UnconvertibleError

  describe "convert/2" do
    test "no-op when source color already has target colorspace" do
      color = RGB.new(123, 45, 67)

      assert Tint.convert(color, RGB) == {:ok, color}
    end

    test "convert color to another colorspace" do
      assert {:ok, %RGB{}} = Tint.convert(%TestConvertible{}, RGB)
    end

    test "conversion error" do
      color = RGB.new(123, 45, 67)

      assert Tint.convert(color, TestConvertible) ==
               {:error, %UnconvertibleError{from: color, to: TestConvertible}}
    end
  end

  describe "convert!/2" do
    test "no-op when source color already has target colorspace" do
      color = RGB.new(123, 45, 67)

      assert Tint.convert!(color, RGB) == color
    end

    test "convert color to another colorspace" do
      assert %RGB{} = Tint.convert!(%TestConvertible{}, RGB)
    end

    test "conversion error" do
      color = RGB.new(123, 45, 67)

      assert_raise UnconvertibleError, fn ->
        Tint.convert!(color, TestConvertible)
      end
    end
  end
end
