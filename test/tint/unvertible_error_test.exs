defmodule Tint.UnconvertibleErrorTest do
  use ExUnit.Case, async: true

  alias Tint.RGB
  alias Tint.TestConvertible
  alias Tint.UnconvertibleError

  describe "message/1" do
    test "get message" do
      color = RGB.new(1, 2, 3)

      assert Exception.message(%UnconvertibleError{
               from: color,
               to: TestConvertible
             }) == "Unable to convert #{inspect(color)} to Tint.TestConvertible"
    end
  end
end
