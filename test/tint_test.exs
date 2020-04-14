defmodule TintTest do
  use ExUnit.Case

  alias Tint.{CMYK, DIN99, HSV, Lab, RGB, XYZ}

  doctest Tint

  @rgb_color RGB.new(0, 50, 100)
  @hsv_color HSV.new(210, 1, 0.392)

  describe "converter_for/1" do
    test "CMYK" do
      assert Tint.converter_for(:cmyk) == {:ok, CMYK.Convertible}
      assert Tint.converter_for(CMYK) == {:ok, CMYK.Convertible}
    end

    test "DIN99" do
      assert Tint.converter_for(:din99) == {:ok, DIN99.Convertible}
      assert Tint.converter_for(DIN99) == {:ok, DIN99.Convertible}
    end

    test "HSV" do
      assert Tint.converter_for(:hsv) == {:ok, HSV.Convertible}
      assert Tint.converter_for(HSV) == {:ok, HSV.Convertible}
    end

    test "Lab" do
      assert Tint.converter_for(:lab) == {:ok, Lab.Convertible}
      assert Tint.converter_for(Lab) == {:ok, Lab.Convertible}
    end

    test "RGB" do
      assert Tint.converter_for(:rgb) == {:ok, RGB.Convertible}
      assert Tint.converter_for(RGB) == {:ok, RGB.Convertible}
    end

    test "XYZ" do
      assert Tint.converter_for(:xyz) == {:ok, XYZ.Convertible}
      assert Tint.converter_for(XYZ) == {:ok, XYZ.Convertible}
    end

    test "error on invalid colorspace" do
      assert Tint.converter_for(:invalid) == :error
      assert Tint.converter_for(Invalid) == :error
    end
  end

  describe "convert/1" do
    test "RGB to CMYK" do
      cmyk_color = CMYK.Convertible.convert(@rgb_color)

      assert Tint.convert(@rgb_color, :cmyk) == {:ok, cmyk_color}
      assert Tint.convert(@rgb_color, CMYK) == {:ok, cmyk_color}
    end

    test "RGB to DIN99" do
      din99_color = DIN99.Convertible.convert(@rgb_color)

      assert Tint.convert(@rgb_color, :din99) == {:ok, din99_color}
      assert Tint.convert(@rgb_color, DIN99) == {:ok, din99_color}
    end

    test "RGB to HSV" do
      hsv_color = HSV.Convertible.convert(@rgb_color)

      assert Tint.convert(@rgb_color, :hsv) == {:ok, hsv_color}
      assert Tint.convert(@rgb_color, HSV) == {:ok, hsv_color}
    end

    test "RGB to Lab" do
      lab_color = Lab.Convertible.convert(@rgb_color)

      assert Tint.convert(@rgb_color, :lab) == {:ok, lab_color}
      assert Tint.convert(@rgb_color, Lab) == {:ok, lab_color}
    end

    test "RGB to RGB" do
      assert Tint.convert(@rgb_color, :rgb) == {:ok, @rgb_color}
      assert Tint.convert(@rgb_color, RGB) == {:ok, @rgb_color}
    end

    test "RGB to XYZ" do
      xyz_color = XYZ.Convertible.convert(@rgb_color)

      assert Tint.convert(@rgb_color, :xyz) == {:ok, xyz_color}
      assert Tint.convert(@rgb_color, XYZ) == {:ok, xyz_color}
    end

    test "HSV to RGB" do
      rgb_color = RGB.Convertible.convert(@hsv_color)

      assert Tint.convert(@hsv_color, :rgb) == {:ok, rgb_color}
      assert Tint.convert(@hsv_color, RGB) == {:ok, rgb_color}
    end

    test "error on unknown colorspace" do
      assert Tint.convert(@rgb_color, :invalid) == :error
      assert Tint.convert(@rgb_color, Invalid) == :error
    end
  end

  describe "convert!/1" do
    test "RGB to CMYK" do
      cmyk_color = CMYK.Convertible.convert(@rgb_color)

      assert Tint.convert!(@rgb_color, :cmyk) == cmyk_color
      assert Tint.convert!(@rgb_color, CMYK) == cmyk_color
    end

    test "RGB to DIN99" do
      din99_color = DIN99.Convertible.convert(@rgb_color)

      assert Tint.convert!(@rgb_color, :din99) == din99_color
      assert Tint.convert!(@rgb_color, DIN99) == din99_color
    end

    test "RGB to HSV" do
      hsv_color = HSV.Convertible.convert(@rgb_color)

      assert Tint.convert!(@rgb_color, :hsv) == hsv_color
      assert Tint.convert!(@rgb_color, HSV) == hsv_color
    end

    test "RGB to Lab" do
      lab_color = Lab.Convertible.convert(@rgb_color)

      assert Tint.convert!(@rgb_color, :lab) == lab_color
      assert Tint.convert!(@rgb_color, Lab) == lab_color
    end

    test "RGB to RGB" do
      assert Tint.convert!(@rgb_color, :rgb) == @rgb_color
      assert Tint.convert!(@rgb_color, RGB) == @rgb_color
    end

    test "RGB to XYZ" do
      xyz_color = XYZ.Convertible.convert(@rgb_color)

      assert Tint.convert!(@rgb_color, :xyz) == xyz_color
      assert Tint.convert!(@rgb_color, XYZ) == xyz_color
    end

    test "HSV to RGB" do
      rgb_color = RGB.Convertible.convert(@hsv_color)

      assert Tint.convert!(@hsv_color, :rgb) == rgb_color
      assert Tint.convert!(@hsv_color, RGB) == rgb_color
    end

    test "raise on unknown colorspace" do
      assert_raise ArgumentError, "Unknown colorspace: :invalid", fn ->
        Tint.convert!(@rgb_color, :invalid)
      end

      assert_raise ArgumentError, "Unknown colorspace: Invalid", fn ->
        Tint.convert!(@rgb_color, Invalid)
      end
    end
  end

  describe "to_cmyk/1" do
    test "convert color to CMYK" do
      assert Tint.to_cmyk(@rgb_color) == CMYK.Convertible.convert(@rgb_color)
    end
  end

  describe "to_din99/1" do
    test "convert color to DIN99" do
      assert Tint.to_din99(@rgb_color) == DIN99.Convertible.convert(@rgb_color)
    end
  end

  describe "to_hsv/1" do
    test "convert color to HSV" do
      assert Tint.to_hsv(@rgb_color) == HSV.Convertible.convert(@rgb_color)
    end
  end

  describe "to_lab/1" do
    test "convert color to Lab" do
      assert Tint.to_lab(@rgb_color) == Lab.Convertible.convert(@rgb_color)
    end
  end

  describe "to_rgb/1" do
    test "convert color to RGB" do
      assert Tint.to_rgb(@hsv_color) == RGB.Convertible.convert(@hsv_color)
    end
  end

  describe "to_xyz/1" do
    test "convert color to XYZ" do
      assert Tint.to_xyz(@rgb_color) == XYZ.Convertible.convert(@rgb_color)
    end
  end
end
