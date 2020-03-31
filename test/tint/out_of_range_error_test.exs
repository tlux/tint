defmodule Tint.OutOfRangeErrorTest do
  use ExUnit.Case, async: true

  alias Tint.OutOfRangeError
  alias Tint.Utils.Interval

  describe "message/1" do
    test "get message" do
      assert Exception.message(%OutOfRangeError{
               value: "2.3",
               interval: Interval.new(3, 4)
             }) == "Value 2.3 is out of range [3,4]"

      assert Exception.message(%OutOfRangeError{
               value: 2,
               interval: Interval.new(0, 1, exclude_min: true)
             }) == "Value 2 is out of range (0,1]"

      assert Exception.message(%OutOfRangeError{
               value: 2.3,
               interval: Interval.new(0, 1, exclude_min: true)
             }) == "Value 2.3 is out of range (0,1]"
    end
  end
end
