defmodule Tint.Sigil do
  @moduledoc """
  A module providing a sigil to build colors.
  """

  alias Tint.{CMYK, DIN99, HSV, Lab, RGB, XYZ}

  @separator ","

  @doc """
  A sigil to build a color.

  The sigil identifier is `K` (try using "kolor" as mnemonic) because `C` is
  already taken by the built-in charlist sigil.

  ## Examples

  First you need to import this particular module.

      import Tint.Sigil

  You can build a RGB color using a hex code, just like `Tint.RGB.from_hex/1`
  does:

      iex> ~K[#FFCC00]
      #Tint.RGB<255,204,0 (#FFCC00)>

  Or using the red, green and blue components using the `r` modifier.

      iex> ~K[255,204,0]r
      #Tint.RGB<255,204,0 (#FFCC00)>

  HSV colors are also supported using the `h` modifier.

      iex> ~K[48,1,1]h
      #Tint.HSV<48.0°,100.0%,100.0%>

  CMYK colors are supported using the `c` modifier.

      iex> ~K[0.06, 0.32, 0.8846, 0.23]c
      #Tint.CMYK<6.0%,32.0%,88.46%,23.0%>

  CIELAB colors are supported using the `l` modifier.

      iex> ~K[50.1234,10.7643,10.4322]l
      #Tint.Lab<50.1234,10.7643,10.4322>

  DIN99 colors are supported using the `d` modifier.

      iex> ~K[50.1234,10.7643,10.4322]d
      #Tint.DIN99<50.1234,10.7643,10.4322>

  XYZ colors are supported using the `x` modifier.

      iex> ~K[50.9505,1,1.09]x
      #Tint.XYZ<50.9505,1.0,1.09>
  """
  @spec sigil_K(String.t(), [char]) :: Tint.color()
  def sigil_K(str, []) do
    RGB.from_hex!(str)
  end

  def sigil_K(str, [?r]) do
    apply(RGB, :new, extract_args(str, 3))
  end

  def sigil_K(str, [?h]) do
    apply(HSV, :new, extract_args(str, 3))
  end

  def sigil_K(str, [?c]) do
    apply(CMYK, :new, extract_args(str, 4))
  end

  def sigil_K(str, [?l]) do
    apply(Lab, :new, extract_args(str, 3))
  end

  def sigil_K(str, [?d]) do
    apply(DIN99, :new, extract_args(str, 3))
  end

  def sigil_K(str, [?x]) do
    apply(XYZ, :new, extract_args(str, 3))
  end

  defp extract_args(str, expected_count) do
    args =
      str
      |> String.split(@separator)
      |> Enum.map(&String.trim/1)

    args_count = length(args)

    if args_count != expected_count do
      raise ArgumentError,
            "Invalid number of args: #{args_count} " <>
              "(expected #{expected_count})"
    end

    args
  end
end
