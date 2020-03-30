defmodule Tint.DIN99Test do
  use ExUnit.Case, async: true

  alias Tint.DIN99

  describe "new/3" do
    test "build DIN99 color" do
      assert DIN99.new(50.1234, 10.7643, 10.4322) == %DIN99{
               lightness: Decimal.new("50.1234"),
               a: Decimal.new("10.7643"),
               b: Decimal.new("10.4322")
             }
    end
  end

  describe "from_tuple/1" do
    test "convert tuple to DIN99 struct" do
      assert DIN99.from_tuple(
               {Decimal.new("50.1234"), Decimal.new("10.7643"),
                Decimal.new("10.4322")}
             ) == DIN99.new(50.1234, 10.7643, 10.4322)
    end

    test "raise when invalid arg given" do
      assert_raise FunctionClauseError, fn ->
        DIN99.from_tuple({50.1234, 10.7643})
      end

      assert_raise FunctionClauseError, fn ->
        DIN99.from_tuple(nil)
      end
    end
  end

  describe "to_tuple/1" do
    test "get tuple" do
      assert DIN99.to_tuple(DIN99.new(50.1234, 10.7643, 10.4322)) ==
               {Decimal.new("50.1234"), Decimal.new("10.7643"),
                Decimal.new("10.4322")}
    end
  end

  describe "Kernel.inspect/1" do
    test "inspect" do
      assert inspect(DIN99.new(50.1234, 10.7643, 10.4322)) ==
               "#Tint.DIN99<50.1234,10.7643,10.4322>"
    end
  end

  describe "DIN99.Convertible.to_din99/1" do
    test "convert to DIN99" do
      color = DIN99.new(50.1234, 10.7643, 10.4322)

      assert DIN99.Convertible.to_din99(color) == color
    end
  end
end
