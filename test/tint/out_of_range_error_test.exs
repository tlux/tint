defmodule Tint.OutOfRangeErrorTest do
  use ExUnit.Case, async: true

  alias Tint.OutOfRangeError
  alias Tint.Utils.Interval

  describe "message/1" do
    test "get message" do
      assert Exception.message(%OutOfRangeError{
               value: Decimal.new("2.3"),
               orig_value: "2.3",
               interval: Interval.new(3, 4)
             }) == "Value 2.3 is out of range [3,4]"

      assert Exception.message(%OutOfRangeError{
               value: Decimal.new("1.5"),
               orig_value: Decimal.new("1.5"),
               interval: Interval.new(6, 10, exclude_max: true)
             }) == "Value 1.5 is out of range [6,10)"

      assert Exception.message(%OutOfRangeError{
               value: Decimal.new("2"),
               orig_value: 2,
               interval: Interval.new(0, 1, exclude_min: true)
             }) == "Value 2 is out of range (0,1]"
    end
  end
end
