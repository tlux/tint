defmodule Tint do
  @moduledoc """
  A library allowing calculations with colors and conversions between different
  colorspaces.
  """

  alias Tint.{CMYK, DIN99, HSV, Lab, RGB, XYZ}

  @typedoc """
  A type representing a color.
  """
  @type color ::
          CMYK.t()
          | DIN99.t()
          | HSV.t()
          | Lab.t()
          | RGB.t()
          | XYZ.t()

  @doc """
  Converts the given color to CMYK colorspace.

  ## Example

  iex> Tint.to_cmyk(Tint.RGB.new(40, 66, 67))
  #Tint.CMYK<40.2%,1.4%,0%,73.7%>
  """
  @doc since: "0.3.0"
  @spec to_cmyk(color) :: CMYK.t()
  defdelegate to_cmyk(color), to: CMYK.Convertible

  @doc """
  Converts the given color to DIN99 colorspace.
  """
  @doc since: "1.0.0"
  @spec to_din99(color) :: DIN99.t()
  defdelegate to_din99(color), to: DIN99.Convertible

  @doc """
  Converts the given color to HSV colorspace.

  ## Example

  iex> Tint.to_hsv(Tint.RGB.new(255, 127, 30))
  #Tint.HSV<25.9°,88.2%,100%>
  """
  @spec to_hsv(color) :: HSV.t()
  defdelegate to_hsv(color), to: HSV.Convertible

  @doc """
  Converts the given color to CIELAB colorspace.
  """
  @doc since: "1.0.0"
  @spec to_lab(color) :: Lab.t()
  defdelegate to_lab(color), to: Lab.Convertible

  @doc """
  Converts the given color to RGB colorspace.

  ## Example

  iex> Tint.to_rgb(Tint.HSV.new(25.8, 0.882, 1))
  #Tint.RGB<255,127,30 (#FF7F1E)>
  """
  @spec to_rgb(color) :: RGB.t()
  defdelegate to_rgb(color), to: RGB.Convertible

  @doc """
  Converts the given color to CIE XYZ colorspace.
  """
  @doc since: "1.0.0"
  @spec to_xyz(color) :: XYZ.t()
  defdelegate to_xyz(color), to: XYZ.Convertible
end
