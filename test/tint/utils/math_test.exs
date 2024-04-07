defmodule Tint.Utils.MathTest do
  use ExUnit.Case, async: true

  alias Tint.Utils.Math

  @delta 0.01

  test "root/2" do
    assert_in_delta Math.root(8, 3), 2, @delta
    assert_in_delta Math.root(9, 3), 2.08, @delta
    assert_in_delta Math.root(27, 3), 3, @delta
    assert_in_delta Math.root(16, 2), 4, @delta
    assert_in_delta Math.root(18, 4), 2.05, @delta
  end
end
