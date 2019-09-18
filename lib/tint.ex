defmodule Tint do
  @moduledoc """
  A library allowing calculations with colors and conversions between different
  colorspaces.
  """

  alias Tint.CMYK
  alias Tint.HSV
  alias Tint.RGB

  @typedoc """
  A type representing a color.
  """
  @type color :: CMYK.t() | HSV.t() | RGB.t()

  @doc """
  Converts the given color to CMYK colorspace.

  ## Example

      iex> Tint.to_cmyk(Tint.RGB.new(40, 66, 67))
      #Tint.CMYK<40.2%,1.4%,0%,73.7%>
  """
  @spec to_cmyk(color) :: CMYK.t()
  defdelegate to_cmyk(color), to: CMYK.Convertible

  @doc """
  Converts the given color to HSV colorspace.

  ## Example

      iex> Tint.to_hsv(Tint.RGB.new(255, 127, 30))
      #Tint.HSV<25.8°,88.2%,100%>
  """
  @spec to_hsv(color) :: HSV.t()
  defdelegate to_hsv(color), to: HSV.Convertible

  @doc """
  Converts the given color to RGB colorspace.

  ## Example

      iex> Tint.to_rgb(Tint.HSV.new(25.8, 0.882, 1))
      #Tint.RGB<255,127,30>
  """
  @spec to_rgb(color) :: RGB.t()
  defdelegate to_rgb(color), to: RGB.Convertible
end
