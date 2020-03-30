defmodule Tint.UtilsTest do
  use ExUnit.Case, async: true

  alias Tint.OutOfRangeError
  alias Tint.Utils
  alias Tint.Utils.Interval

  describe "cast_byte_channel/1" do
    test "with decimal" do
      assert Utils.cast_byte_channel(Decimal.new(0)) == {:ok, 0}
      assert Utils.cast_byte_channel(Decimal.new(1)) == {:ok, 1}
      assert Utils.cast_byte_channel(Decimal.new(3)) == {:ok, 3}
      assert Utils.cast_byte_channel(Decimal.new("5.23")) == {:ok, 5}
      assert Utils.cast_byte_channel(Decimal.new("5.67")) == {:ok, 5}
      assert Utils.cast_byte_channel(Decimal.new(255)) == {:ok, 255}
    end

    test "with float" do
      assert Utils.cast_byte_channel(0.0) == {:ok, 0}
      assert Utils.cast_byte_channel(1.0) == {:ok, 1}
      assert Utils.cast_byte_channel(3.0) == {:ok, 3}
      assert Utils.cast_byte_channel(5.23) == {:ok, 5}
      assert Utils.cast_byte_channel(5.67) == {:ok, 5}
      assert Utils.cast_byte_channel(255.0) == {:ok, 255}
    end

    test "with integer" do
      assert Utils.cast_byte_channel(0) == {:ok, 0}
      assert Utils.cast_byte_channel(1) == {:ok, 1}
      assert Utils.cast_byte_channel(255) == {:ok, 255}
      assert Utils.cast_byte_channel(3) == {:ok, 3}
    end

    test "with string" do
      assert Utils.cast_byte_channel("0") == {:ok, 0}
      assert Utils.cast_byte_channel("1") == {:ok, 1}
      assert Utils.cast_byte_channel("3.0") == {:ok, 3}
      assert Utils.cast_byte_channel("5.23") == {:ok, 5}
      assert Utils.cast_byte_channel("5.67") == {:ok, 5}
      assert Utils.cast_byte_channel("255.0") == {:ok, 255}
    end

    test "out of range error" do
      interval = Interval.new(0, 255)

      assert Utils.cast_byte_channel(-1) ==
               {:error,
                %OutOfRangeError{orig_value: -1, value: -1, interval: interval}}

      assert Utils.cast_byte_channel(256) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 256,
                  value: 256,
                  interval: interval
                }}

      assert Utils.cast_byte_channel(256.3) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 256.3,
                  value: 256,
                  interval: interval
                }}

      assert Utils.cast_byte_channel("256.3") ==
               {:error,
                %OutOfRangeError{
                  orig_value: "256.3",
                  value: 256,
                  interval: interval
                }}
    end

    test "invalid value" do
      assert_raise ArgumentError, fn ->
        Utils.cast_byte_channel("invalid")
      end

      assert_raise FunctionClauseError, fn ->
        Utils.cast_byte_channel(:invalid)
      end
    end
  end

  describe "cast_degrees/1" do
    test "with decimal" do
      assert Utils.cast_degrees(Decimal.new(0)) == {:ok, Decimal.new("0.0")}
      assert Utils.cast_degrees(Decimal.new(1)) == {:ok, Decimal.new("1.0")}
      assert Utils.cast_degrees(Decimal.new(3)) == {:ok, Decimal.new("3.0")}

      assert Utils.cast_degrees(Decimal.new("5.23")) ==
               {:ok, Decimal.new("5.2")}

      assert Utils.cast_degrees(Decimal.new("5.67")) ==
               {:ok, Decimal.new("5.6")}

      assert Utils.cast_degrees(Decimal.new(359)) == {:ok, Decimal.new("359.0")}
    end

    test "with float" do
      assert Utils.cast_degrees(0.0) == {:ok, Decimal.new("0.0")}
      assert Utils.cast_degrees(1.0) == {:ok, Decimal.new("1.0")}
      assert Utils.cast_degrees(3.0) == {:ok, Decimal.new("3.0")}
      assert Utils.cast_degrees(5.23) == {:ok, Decimal.new("5.2")}
      assert Utils.cast_degrees(5.67) == {:ok, Decimal.new("5.6")}
      assert Utils.cast_degrees(359.0) == {:ok, Decimal.new("359.0")}
    end

    test "with integer" do
      assert Utils.cast_degrees(0) == {:ok, Decimal.new("0.0")}
      assert Utils.cast_degrees(1) == {:ok, Decimal.new("1.0")}
      assert Utils.cast_degrees(3) == {:ok, Decimal.new("3.0")}
      assert Utils.cast_degrees(359) == {:ok, Decimal.new("359.0")}
    end

    test "with string" do
      assert Utils.cast_degrees("0") == {:ok, Decimal.new("0.0")}
      assert Utils.cast_degrees("1") == {:ok, Decimal.new("1.0")}
      assert Utils.cast_degrees("3.0") == {:ok, Decimal.new("3.0")}
      assert Utils.cast_degrees("5.23") == {:ok, Decimal.new("5.2")}
      assert Utils.cast_degrees("5.67") == {:ok, Decimal.new("5.6")}
      assert Utils.cast_degrees("359.0") == {:ok, Decimal.new("359.0")}
    end

    test "out of range error" do
      interval = Interval.new(0, 360, exclude_max: true)

      assert Utils.cast_degrees(-1) ==
               {:error,
                %OutOfRangeError{
                  orig_value: -1,
                  value: Decimal.new("-1.0"),
                  interval: interval
                }}

      assert Utils.cast_degrees(360) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 360,
                  value: Decimal.new("360.0"),
                  interval: interval
                }}

      assert Utils.cast_degrees(360.34) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 360.34,
                  value: Decimal.new("360.3"),
                  interval: interval
                }}

      assert Utils.cast_degrees("360.34") ==
               {:error,
                %OutOfRangeError{
                  orig_value: "360.34",
                  value: Decimal.new("360.3"),
                  interval: interval
                }}
    end

    test "invalid value" do
      assert_raise Decimal.Error, fn ->
        Utils.cast_degrees("invalid")
      end

      assert_raise FunctionClauseError, fn ->
        Utils.cast_degrees(:invalid)
      end
    end
  end

  describe "cast_ratio/1" do
    test "with decimal" do
      assert Utils.cast_ratio(Decimal.new(0)) == {:ok, Decimal.new("0.000")}
      assert Utils.cast_ratio(Decimal.new("0.3")) == {:ok, Decimal.new("0.300")}

      assert Utils.cast_ratio(Decimal.new("0.66")) ==
               {:ok, Decimal.new("0.660")}

      assert Utils.cast_ratio(Decimal.new("0.9996")) ==
               {:ok, Decimal.new("0.999")}

      assert Utils.cast_ratio(Decimal.new(1)) == {:ok, Decimal.new("1.000")}
    end

    test "with float" do
      assert Utils.cast_ratio(0) == {:ok, Decimal.new("0.000")}
      assert Utils.cast_ratio(0.3) == {:ok, Decimal.new("0.300")}
      assert Utils.cast_ratio(0.66) == {:ok, Decimal.new("0.660")}
      assert Utils.cast_ratio(0.9996) == {:ok, Decimal.new("0.999")}
      assert Utils.cast_ratio(1.0) == {:ok, Decimal.new("1.000")}
    end

    test "with integer" do
      assert Utils.cast_ratio(0) == {:ok, Decimal.new("0.000")}
      assert Utils.cast_ratio(1) == {:ok, Decimal.new("1.000")}
    end

    test "with string" do
      assert Utils.cast_ratio("0") == {:ok, Decimal.new("0.000")}
      assert Utils.cast_ratio("0.3") == {:ok, Decimal.new("0.300")}
      assert Utils.cast_ratio("0.66") == {:ok, Decimal.new("0.660")}
      assert Utils.cast_ratio("0.9996") == {:ok, Decimal.new("0.999")}
      assert Utils.cast_ratio("1") == {:ok, Decimal.new("1.000")}
    end

    test "out of range error" do
      interval = Interval.new(0, 1)

      assert Utils.cast_ratio(-1) ==
               {:error,
                %OutOfRangeError{
                  orig_value: -1,
                  value: Decimal.new("-1.000"),
                  interval: interval
                }}

      assert Utils.cast_ratio(2.34) ==
               {:error,
                %OutOfRangeError{
                  orig_value: 2.34,
                  value: Decimal.new("2.340"),
                  interval: interval
                }}

      assert Utils.cast_ratio("2.3456") ==
               {:error,
                %OutOfRangeError{
                  orig_value: "2.3456",
                  value: Decimal.new("2.345"),
                  interval: interval
                }}
    end

    test "invalid value" do
      assert_raise Decimal.Error, fn ->
        Utils.cast_ratio("invalid")
      end

      assert_raise FunctionClauseError, fn ->
        Utils.cast_ratio(:invalid)
      end
    end
  end
end
