defmodule Tint.SigilTest do
  use ExUnit.Case, async: true

  import Tint.Sigil

  alias Tint.HSV
  alias Tint.OutOfRangeError
  alias Tint.RGB

  doctest Tint.Sigil

  describe "hex code" do
    test "success" do
      assert ~K[#FFCC00] == RGB.from_hex!("#FFCC00")
    end

    test "error" do
      assert_raise ArgumentError, "Invalid hex code: invalid", fn ->
        ~K[invalid]
      end
    end
  end

  describe "RGB color" do
    test "success" do
      assert ~K(123,45,67)r == RGB.new(123, 45, 67)
      assert ~K(123, 45, 67)r == RGB.new(123, 45, 67)
    end

    test "error when value out of range" do
      assert_raise OutOfRangeError, "Value 256 is out of range [0,255]", fn ->
        ~K(256,128,0)r
      end
    end

    test "raise when invalid number of args" do
      assert_raise ArgumentError,
                   "Invalid number of args: 5 (expected 3)",
                   fn ->
                     ~K(255, 0,, 255,)r
                   end

      assert_raise ArgumentError,
                   "Invalid number of args: 2 (expected 3)",
                   fn ->
                     ~K(255,0)r
                   end
    end
  end

  describe "HSV color" do
    test "success" do
      assert ~K(123,0.45,0.67)h == HSV.new(123, 0.45, 0.67)
      assert ~K(123, 0.45, 0.67)h == HSV.new(123, 0.45, 0.67)
    end

    test "error when value out of range" do
      assert_raise OutOfRangeError, "Value 361 is out of range [0,360)", fn ->
        ~K(361,0,1)h
      end
    end

    test "raise when invalid number of args" do
      assert_raise ArgumentError,
                   "Invalid number of args: 5 (expected 3)",
                   fn ->
                     ~K(255, 0,, 1,)h
                   end

      assert_raise ArgumentError,
                   "Invalid number of args: 2 (expected 3)",
                   fn ->
                     ~K(255,1)h
                   end
    end
  end
end
