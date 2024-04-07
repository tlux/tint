defmodule Tint.Utils.CastTest do
  use ExUnit.Case, async: true

  alias Tint.Interval
  alias Tint.OutOfRangeError
  alias Tint.Utils.Cast

  describe "cast_value!/1" do
    test "to float" do
      assert Cast.cast_value!(0, :float) == 0
      assert Cast.cast_value!(0.3, :float) == 0.3
      assert Cast.cast_value!(0.66, :float) == 0.66
      assert Cast.cast_value!(0.9996, :float) == 0.9996
      assert Cast.cast_value!(1, :float) == 1.0
      assert Cast.cast_value!("0.9996", :float) == 0.9996
      assert Cast.cast_value!("1", :float) == 1.0
    end

    test "to integer" do
      assert Cast.cast_value!(0, :integer) == 0
      assert Cast.cast_value!(1.0, :integer) == 1
      assert Cast.cast_value!(1.2, :integer) == 1
      assert Cast.cast_value!("1", :integer) == 1
      assert Cast.cast_value!("1.2", :integer) == 1
    end

    test "raise on unknown type" do
      assert_raise FunctionClauseError, fn ->
        Cast.cast_value!(2, :invalid)
      end
    end

    test "raise on invalid value" do
      assert_raise FunctionClauseError, fn ->
        Cast.cast_value!(:invalid, :integer)
      end

      assert_raise FunctionClauseError, fn ->
        Cast.cast_value!(:invalid, :float)
      end
    end

    test "raise when unable to cast string to float" do
      assert_raise ArgumentError, ~s(Unable to cast "invalid" to float), fn ->
        Cast.cast_value!("invalid", :float)
      end
    end

    test "raise when unable to cast string to integer" do
      assert_raise ArgumentError, ~s(Unable to cast "invalid" to integer), fn ->
        Cast.cast_value!("invalid", :integer)
      end
    end
  end

  describe "cast_value_with_interval!/3" do
    @interval Interval.new(4, 9.1)

    test "success" do
      assert Cast.cast_value_with_interval!(4, :float, @interval) == 4
      assert Cast.cast_value_with_interval!(9.2, :integer, @interval) == 9
    end

    test "error when value out of bounds" do
      assert_raise OutOfRangeError, "Value 9.2 is out of range [4,9.1]", fn ->
        Cast.cast_value_with_interval!(9.2, :float, @interval)
      end

      assert_raise OutOfRangeError, "Value 3 is out of range [4,9.1]", fn ->
        Cast.cast_value_with_interval!(3, :float, @interval)
      end

      assert_raise OutOfRangeError, "Value 3 is out of range [4,9.1]", fn ->
        Cast.cast_value_with_interval!("3", :float, @interval)
      end

      assert_raise OutOfRangeError, "Value 3.9 is out of range [4,9.1]", fn ->
        Cast.cast_value_with_interval!(3.9, :float, @interval)
      end
    end

    test "raise on unknown type" do
      assert_raise FunctionClauseError, fn ->
        Cast.cast_value_with_interval!(2, :invalid, @interval)
      end
    end

    test "raise on invalid value" do
      assert_raise FunctionClauseError, fn ->
        Cast.cast_value_with_interval!(:invalid, :integer, @interval)
      end

      assert_raise FunctionClauseError, fn ->
        Cast.cast_value_with_interval!(:invalid, :float, @interval)
      end
    end
  end

  describe "cast_ratio!/1" do
    test "with float" do
      assert Cast.cast_ratio!(0) == 0
      assert Cast.cast_ratio!(0.3) == 0.3
      assert Cast.cast_ratio!(0.66) == 0.66
      assert Cast.cast_ratio!(0.9996) == 0.9996
      assert Cast.cast_ratio!(1) == 1
    end

    test "with integer" do
      assert Cast.cast_ratio!(0) == 0
      assert Cast.cast_ratio!(1) == 1
    end

    test "with string" do
      assert Cast.cast_ratio!("0") == 0
      assert Cast.cast_ratio!("0.3") == 0.3
      assert Cast.cast_ratio!("0.66") == 0.66
      assert Cast.cast_ratio!("0.9996") == 0.9996
      assert Cast.cast_ratio!("1") == 1
    end

    test "raise when out of range error" do
      assert_raise OutOfRangeError, "Value -1 is out of range [0,1]", fn ->
        Cast.cast_ratio!(-1)
      end

      assert_raise OutOfRangeError, "Value 2.34 is out of range [0,1]", fn ->
        Cast.cast_ratio!(2.34)
      end

      assert_raise OutOfRangeError, "Value 2.3456 is out of range [0,1]", fn ->
        Cast.cast_ratio!("2.3456")
      end
    end

    test "invalid value" do
      assert_raise FunctionClauseError, fn ->
        Cast.cast_ratio!(:invalid)
      end
    end
  end
end
