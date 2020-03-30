defmodule Tint.MathTest do
  use ExUnit.Case

  alias Tint.Math

  describe "pi/0" do
    test "get Pi constant" do
      assert Math.pi() == Decimal.from_float(:math.pi())
    end
  end
end
