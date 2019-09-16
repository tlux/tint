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

  ## Example

      iex> Tint.to_rgb(Tint.HSV.new(25.8, 0.882, 1))
      #Tint.RGB<255,127,30>
  """
  @spec to_rgb(color) :: RGB.t()
  def to_rgb(color) do
    RGB.Convertible.to_rgb(color)
  end

  @doc """
  Converts the given color to HSV colorspace.

  ## Example

      iex> Tint.to_hsv(Tint.RGB.new(255, 127, 30))
      #Tint.HSV<25.8°,88.2%,100%>
  """
  @spec to_hsv(color) :: HSV.t()
  def to_hsv(color) do
    HSV.Convertible.to_hsv(color)
  end
end
