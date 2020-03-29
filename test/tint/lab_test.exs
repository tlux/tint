defmodule Tint.LabTest do
  use ExUnit.Case, async: true

  alias Tint.Lab

  describe "new/3" do
    test "build Lab color" do
      assert Lab.new(50.1234, 10.7643, 10.4322) == %Lab{
               lightness: Decimal.new("50.1234"),
               a: Decimal.new("10.7643"),
               b: Decimal.new("10.4322")
             }
    end
  end

  describe "nearest_color/2" do
    # TODO
  end

  describe "nearest_color/3" do
    # TODO
  end

  describe "nearest_colors/3" do
    # TODO
  end

  describe "nearest_colors/4" do
    # TODO
  end

  describe "Lab.Convertible.to_lab/1" do
    test "convert to Lab" do
      color = Lab.new(50, 10, 10)

      assert Lab.Convertible.to_lab(color) == color
    end
  end
end
