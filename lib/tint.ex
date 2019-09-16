defmodule Tint do
  @moduledoc """
  A library allowing calculations with colors and conversions between different
  colorspaces.
  """

  alias Tint.HSV
  alias Tint.RGB

  @typedoc """
  A type representing a color.
  """
  @type color :: HSV.t() | RGB.t()

  @doc """
  Converts the given color to RGB colorspace.
  """
  @spec to_rgb(color) :: RGB.t()
  def to_rgb(color) do
    RGB.Convertible.to_rgb(color)
  end

  @doc """
  Converts the given color to HSV colorspace.
  """
  @spec to_hsv(color) :: HSV.t()
  def to_hsv(color) do
    HSV.Convertible.to_hsv(color)
  end
end
