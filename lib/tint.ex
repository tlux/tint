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

  @typedoc """
  A type representing a colorspace.
  """
  @type colorspace :: atom | module

  @aliases Application.fetch_env!(:tint, :colorspace_aliases)

  @doc """
  Gets the converted module for the given colorspace atom or module.
  """
  @doc since: "1.0.0"
  @spec converter_for(colorspace) :: {:ok, module} | :error
  def converter_for(colorspace) do
    colorspace_mod = Map.get(@aliases, colorspace, colorspace)
    convertible_mod = Module.concat(colorspace_mod, Convertible)

    if function_exported?(convertible_mod, :convert, 1) do
      {:ok, convertible_mod}
    else
      :error
    end
  end

  @doc """
  Converts the given color to another colorspace.

  ## Examples

  iex> Tint.convert(Tint.RGB.new(40, 66, 67), :cmyk)
  {:ok, %Tint.CMYK{cyan: 0.403, magenta: 0.0149, yellow: 0.0, key: 0.7373}}

  iex> Tint.convert(Tint.RGB.new(255, 127, 30), Tint.HSV)
  {:ok, %Tint.HSV{hue: 25.9, saturation: 0.8824, value: 1.0}}

  iex> Tint.convert(Tint.RGB.new(255, 127, 30), :invalid)
  :error
  """
  @doc since: "1.0.0"
  @spec convert(color, colorspace) :: {:ok, color} | :error
  def convert(color, colorspace) do
    with {:ok, convertible_mod} <- converter_for(colorspace) do
      {:ok, convertible_mod.convert(color)}
    end
  end

  @doc """
  Converts the given color to another colorspace. Raises when the colorspace
  is invalid.

  ## Examples

  iex> Tint.convert!(Tint.RGB.new(40, 66, 67), :cmyk)
  %Tint.CMYK{cyan: 0.403, magenta: 0.0149, yellow: 0.0, key: 0.7373}

  iex> Tint.convert!(Tint.RGB.new(255, 127, 30), Tint.HSV)
  %Tint.HSV{hue: 25.9, saturation: 0.8824, value: 1.0}

  iex> Tint.convert!(Tint.RGB.new(255, 127, 30), :foo)
  ** (ArgumentError) Unknown colorspace: :foo
  """
  @doc since: "1.0.0"
  @spec convert!(color, colorspace) :: color
  def convert!(color, colorspace) do
    case convert(color, colorspace) do
      {:ok, color} ->
        color

      :error ->
        raise ArgumentError, "Unknown colorspace: #{inspect(colorspace)}"
    end
  end

  @doc """
  Converts the given color to the CMYK colorspace.

  ## Example

  iex> Tint.to_cmyk(Tint.RGB.new(40, 66, 67))
  #Tint.CMYK<40.3%,1.49%,0.0%,73.73%>
  """
  @doc since: "0.3.0"
  @spec to_cmyk(color) :: CMYK.t()
  defdelegate to_cmyk(color), to: CMYK.Convertible, as: :convert

  @doc """
  Converts the given color to the DIN99 colorspace.
  """
  @doc since: "1.0.0"
  @spec to_din99(color) :: DIN99.t()
  defdelegate to_din99(color), to: DIN99.Convertible, as: :convert

  @doc """
  Converts the given color to the HSV colorspace.

  ## Example

  iex> Tint.to_hsv(Tint.RGB.new(255, 127, 30))
  #Tint.HSV<25.9°,88.24%,100.0%>
  """
  @spec to_hsv(color) :: HSV.t()
  defdelegate to_hsv(color), to: HSV.Convertible, as: :convert

  @doc """
  Converts the given color to the CIELAB colorspace.
  """
  @doc since: "1.0.0"
  @spec to_lab(color) :: Lab.t()
  defdelegate to_lab(color), to: Lab.Convertible, as: :convert

  @doc """
  Converts the given color to the RGB colorspace.

  ## Example

  iex> Tint.to_rgb(Tint.HSV.new(25.8, 0.882, 1))
  #Tint.RGB<255,127,30 (#FF7F1E)>
  """
  @spec to_rgb(color) :: RGB.t()
  defdelegate to_rgb(color), to: RGB.Convertible, as: :convert

  @doc """
  Converts the given color to the XYZ (CIE 1931) colorspace.
  """
  @doc since: "1.0.0"
  @spec to_xyz(color) :: XYZ.t()
  defdelegate to_xyz(color), to: XYZ.Convertible, as: :convert
end
