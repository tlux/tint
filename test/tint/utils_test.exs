defmodule Tint.UtilsTest do
  use ExUnit.Case, async: true

  alias Tint.OutOfRangeError
  alias Tint.Utils
  alias Tint.Utils.Interval

  describe "check_and_cast_value/2" do
    test "with decimal, convert to decimal" do
      assert Utils.check_and_cast_value(
               :decimal,
               Decimal.new(1),
               Interval.new(1, 3)
             ) == {:ok, Decimal.new(1)}

      assert Utils.check_and_cast_value(
               :decimal,
               Decimal.new(3),
               Interval.new(1, 3)
             ) == {:ok, Decimal.new(3)}

      assert Utils.check_and_cast_value(
               :decimal,
               Decimal.new("1.23"),
               Interval.new(1, 3)
             ) == {:ok, Decimal.new("1.23")}

      assert Utils.check_and_cast_value(:decimal, "1.23", Interval.new(1, 3)) ==
               {:ok, Decimal.new("1.23")}

      assert Utils.check_and_cast_value(
               :decimal,
               Decimal.new(2),
               Interval.new(3, 4)
             ) ==
               {:error,
                %OutOfRangeError{
                  orig_value: Decimal.new(2),
                  value: Decimal.new(2),
                  interval: Interval.new(3, 4)
                }}

      assert Utils.check_and_cast_value(
               :decimal,
               Decimal.new("1.23"),
               Interval.new(2, 3, exclude_min: true)
             ) ==
               {:error,
                %OutOfRangeError{
                  orig_value: Decimal.new("1.23"),
                  value: Decimal.new("1.23"),
                  interval: Interval.new(2, 3, exclude_min: true)
                }}

      assert Utils.check_and_cast_value(
               :decimal,
               "2.3",
               Interval.new(3, 4, exclude_max: true)
             ) ==
               {:error,
                %OutOfRangeError{
                  orig_value: "2.3",
                  value: Decimal.new("2.3"),
                  interval: Interval.new(3, 4, exclude_max: true)
                }}
    end

    test "with decimal, convert to integer" do
      assert Utils.check_and_cast_value(
               :integer,
               Decimal.new(1),
               Interval.new(1, 3, exclude_max: true)
             ) == {:ok, 1}

      assert Utils.check_and_cast_value(
               :integer,
               Decimal.new(3),
               Interval.new(1, 3, exclude_min: true)
             ) == {:ok, 3}

      assert Utils.check_and_cast_value(
               :integer,
               Decimal.new("1.23"),
               Interval.new(1, 3)
             ) == {:ok, 1}

      assert Utils.check_and_cast_value(:integer, "1.23", Interval.new(1, 3)) ==
               {:ok, 1}

      assert Utils.check_and_cast_value(
               :integer,
               Decimal.new(2),
               Interval.new(3, 4)
             ) ==
               {:error,
                %OutOfRangeError{
                  orig_value: Decimal.new(2),
                  value: 2,
                  interval: Interval.new(3, 4)
                }}

      assert Utils.check_and_cast_value(
               :integer,
               Decimal.new("1.23"),
               Interval.new(2, 3, exclude_min: true)
             ) ==
               {:error,
                %OutOfRangeError{
                  orig_value: Decimal.new("1.23"),
                  value: 1,
                  interval: Interval.new(2, 3, exclude_min: true)
                }}

      assert Utils.check_and_cast_value(
               :integer,
               "2.3",
               Interval.new(3, 4, exclude_min: true, exclude_max: true)
             ) ==
               {:error,
                %OutOfRangeError{
                  orig_value: "2.3",
                  value: 2,
                  interval:
                    Interval.new(3, 4, exclude_min: true, exclude_max: true)
                }}
    end

    test "with float, convert to decimal" do
      assert Utils.check_and_cast_value(:decimal, 1.0, Interval.new(1, 3)) ==
               {:ok, Decimal.new(1)}

      assert Utils.check_and_cast_value(:decimal, 3.0, Interval.new(1, 3)) ==
               {:ok, Decimal.new(3)}

      assert Utils.check_and_cast_value(:decimal, 1.23, Interval.new(1, 3)) ==
               {:ok, Decimal.new("1.23")}

      assert Utils.check_and_cast_value(
               :decimal,
               1.23,
               Interval.new(2, 3, exclude_max: true)
             ) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 1.23,
                  value: Decimal.new("1.23"),
                  interval: Interval.new(2, 3, exclude_max: true)
                }}

      assert Utils.check_and_cast_value(
               :decimal,
               5.45,
               Interval.new(2, 3, exclude_min: true)
             ) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 5.45,
                  value: Decimal.new("5.45"),
                  interval: Interval.new(2, 3, exclude_min: true)
                }}
    end

    test "with float, convert to integer" do
      assert Utils.check_and_cast_value(:integer, 1.0, Interval.new(1, 3)) ==
               {:ok, 1}

      assert Utils.check_and_cast_value(:integer, 3.0, Interval.new(1, 3)) ==
               {:ok, 3}

      assert Utils.check_and_cast_value(:integer, 1.23, Interval.new(1, 3)) ==
               {:ok, 1}

      assert Utils.check_and_cast_value(:integer, 1.23, Interval.new(2, 3)) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 1.23,
                  value: 1,
                  interval: Interval.new(2, 3)
                }}

      assert Utils.check_and_cast_value(:integer, 5.45, Interval.new(2, 3)) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 5.45,
                  value: 5,
                  interval: Interval.new(2, 3)
                }}
    end

    test "with integer, convert to decimal" do
      assert Utils.check_and_cast_value(
               :decimal,
               1,
               Interval.new(0, 4, exclude_max: true)
             ) == {:ok, Decimal.new(1)}

      assert Utils.check_and_cast_value(
               :decimal,
               3,
               Interval.new(3, 4, exclude_max: true)
             ) == {:ok, Decimal.new(3)}

      assert Utils.check_and_cast_value(:decimal, 2, Interval.new(3, 4)) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 2,
                  value: Decimal.new(2),
                  interval: Interval.new(3, 4)
                }}
    end

    test "with integer, convert to integer" do
      assert Utils.check_and_cast_value(:integer, 1, Interval.new(1, 3)) ==
               {:ok, 1}

      assert Utils.check_and_cast_value(:integer, 3, Interval.new(1, 3)) ==
               {:ok, 3}

      assert Utils.check_and_cast_value(:integer, 2, Interval.new(3, 4)) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 2,
                  value: 2,
                  interval: Interval.new(3, 4)
                }}
    end

    test "invalid value" do
      assert_raise ArgumentError, fn ->
        Utils.check_and_cast_value(:integer, "invalid", Interval.new(1, 3))
      end

      assert_raise FunctionClauseError, fn ->
        Utils.check_and_cast_value(:integer, :invalid, Interval.new(1, 3))
      end

      assert_raise Decimal.Error, fn ->
        Utils.check_and_cast_value(:decimal, "invalid", Interval.new(1, 3))
      end

      assert_raise FunctionClauseError, fn ->
        Utils.check_and_cast_value(:decimal, :invalid, Interval.new(1, 3))
      end
    end
  end
end
