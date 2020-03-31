defmodule Tint.Utils.IntervalTest do
  use ExUnit.Case, async: true

  alias Tint.Utils.Interval

  describe "new/2" do
    test "build interval" do
      assert Interval.new(1, 2) == Interval.new(1, 2, [])
    end
  end

  describe "new/3" do
    test "build interval" do
      assert Interval.new(1, 2, []) == %Interval{
               min: 1,
               max: 2,
               exclude_min: false,
               exclude_max: false
             }

      assert Interval.new(2, 3, exclude_min: true, exclude_max: true) ==
               %Interval{
                 min: 2,
                 max: 3,
                 exclude_min: true,
                 exclude_max: true
               }
    end
  end

  describe "member?/2" do
    test "include min, include max" do
      interval = Interval.new(1, 3)

      assert Interval.member?(interval, 0) == false
      assert Interval.member?(interval, 1) == true
      assert Interval.member?(interval, 2) == true
      assert Interval.member?(interval, 3) == true
      assert Interval.member?(interval, 4) == false
    end

    test "include min, exclude max" do
      interval = Interval.new(1, 3, exclude_max: true)

      assert Interval.member?(interval, 0) == false
      assert Interval.member?(interval, 1) == true
      assert Interval.member?(interval, 2) == true
      assert Interval.member?(interval, 3) == false
      assert Interval.member?(interval, 4) == false
    end

    test "exclude min, include max" do
      interval = Interval.new(1, 3, exclude_min: true)

      assert Interval.member?(interval, 0) == false
      assert Interval.member?(interval, 1) == false
      assert Interval.member?(interval, 2) == true
      assert Interval.member?(interval, 3) == true
      assert Interval.member?(interval, 4) == false
    end

    test "exclude min, exclude max" do
      interval = Interval.new(1, 3, exclude_min: true, exclude_max: true)

      assert Interval.member?(interval, 0) == false
      assert Interval.member?(interval, 1) == false
      assert Interval.member?(interval, 2) == true
      assert Interval.member?(interval, 3) == false
      assert Interval.member?(interval, 4) == false
    end
  end

  describe "String.Chars.to_string/2" do
    test "include min, include max" do
      assert to_string(Interval.new(1, 3)) == "[1,3]"
      assert to_string(Interval.new(:infinity, :infinity)) == "[Inf,Inf]"
    end

    test "include min, exclude max" do
      assert to_string(Interval.new(1, 3, exclude_max: true)) == "[1,3)"
    end

    test "exclude min, include max" do
      assert to_string(Interval.new(1, 3, exclude_min: true)) == "(1,3]"
    end

    test "exclude min, exclude max" do
      assert to_string(Interval.new(1, 3, exclude_min: true, exclude_max: true)) ==
               "(1,3)"
    end
  end
end
