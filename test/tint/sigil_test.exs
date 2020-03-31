defmodule Tint.SigilTest do
  use ExUnit.Case, async: true

  import Tint.Sigil

  alias Tint.CMYK
  alias Tint.DIN99
  alias Tint.HSV
  alias Tint.Lab
  alias Tint.OutOfRangeError
  alias Tint.RGB
  alias Tint.XYZ

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

  describe "CMYK color" do
    test "success" do
      assert ~K(0.06,0.32,0.8846,0.23)c == CMYK.new(0.06, 0.32, 0.8846, 0.23)
      assert ~K(0.06, 0.32, 0.8846, 0.23)c == CMYK.new(0.06, 0.32, 0.8846, 0.23)
    end

    test "error when value out of range" do
      assert_raise OutOfRangeError, "Value 2 is out of range [0,1]", fn ->
        ~K(0.06,0.32,2,0.23)c
      end
    end

    test "raise when invalid number of args" do
      assert_raise ArgumentError,
                   "Invalid number of args: 5 (expected 4)",
                   fn ->
                     ~K(0.06,0.32,0.8846,0.23,1)c
                   end

      assert_raise ArgumentError,
                   "Invalid number of args: 3 (expected 4)",
                   fn ->
                     ~K(0.06,0.32,0.8846)c
                   end
    end
  end

  describe "Lab color" do
    test "success" do
      assert ~K(50.1234, 10.7643, 10.4322)l == %Lab{
               lightness: 50.1234,
               a: 10.7643,
               b: 10.4322
             }

      assert ~K(50.1234,10.7643,10.4322)l == %Lab{
               lightness: 50.1234,
               a: 10.7643,
               b: 10.4322
             }
    end

    test "raise when invalid number of args" do
      assert_raise ArgumentError,
                   "Invalid number of args: 4 (expected 3)",
                   fn ->
                     ~K(50.1234,10.7643,10.4322,12)l
                   end

      assert_raise ArgumentError,
                   "Invalid number of args: 2 (expected 3)",
                   fn ->
                     ~K(50.1234,10.76436)l
                   end
    end
  end

  describe "DIN99 color" do
    test "success" do
      assert ~K(50.1234, 10.7643, 10.4322)d == %DIN99{
               lightness: 50.1234,
               a: 10.7643,
               b: 10.4322
             }

      assert ~K(50.1234,10.7643,10.4322)d == %DIN99{
               lightness: 50.1234,
               a: 10.7643,
               b: 10.4322
             }
    end

    test "raise when invalid number of args" do
      assert_raise ArgumentError,
                   "Invalid number of args: 4 (expected 3)",
                   fn ->
                     ~K(50.1234,10.7643,10.4322,12)d
                   end

      assert_raise ArgumentError,
                   "Invalid number of args: 2 (expected 3)",
                   fn ->
                     ~K(50.1234,10.76436)d
                   end
    end
  end

  describe "XYZ color" do
    test "success" do
      assert ~K(0.9505, 1, 1.09)x == %XYZ{
               x: 0.9505,
               y: 1.0000,
               z: 1.0900
             }

      assert ~K(0.9505,1,1.09)x == %XYZ{
               x: 0.9505,
               y: 1.0000,
               z: 1.0900
             }
    end

    test "raise when invalid number of args" do
      assert_raise ArgumentError,
                   "Invalid number of args: 4 (expected 3)",
                   fn ->
                     ~K(0.9505,1,1.09,12)x
                   end

      assert_raise ArgumentError,
                   "Invalid number of args: 2 (expected 3)",
                   fn ->
                     ~K(0.9505,1)x
                   end
    end
  end
end
