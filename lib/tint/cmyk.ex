defmodule Tint.CMYK do
  @moduledoc """
  A color in the CMYK (cyan, magenta, yellow, key) colorspace.
  """
  @moduledoc since: "0.3.0"

  import Tint.Utils

  defstruct [:cyan, :magenta, :yellow, :key]

  @type t :: %__MODULE__{
          cyan: Decimal.t(),
          magenta: Decimal.t(),
          yellow: Decimal.t(),
          key: Decimal.t()
        }

  @doc """
  Builds a new CMYK color from cyan, magenta, yellow and key color parts. Please
  always use this function to build a new CMYK color.

  ## Examples

      iex> Tint.CMYK.new(0.06, 0.32, 0.8846, 0.23)
      #Tint.CMYK<6%,32%,88.4%,23%>

      iex> Tint.CMYK.new(0.06, 3.2, 0.8846, 0.23)
      ** (Tint.OutOfRangeError) Value 3.2 is out of range [0,1]
  """
  @spec new(
          Decimal.t() | number,
          Decimal.t() | number,
          Decimal.t() | number,
          Decimal.t() | number
        ) :: t
  def new(cyan, magenta, yellow, key) do
    with {:ok, cyan} <- cast_ratio(cyan),
         {:ok, magenta} <- cast_ratio(magenta),
         {:ok, yellow} <- cast_ratio(yellow),
         {:ok, key} <- cast_ratio(key) do
      %__MODULE__{cyan: cyan, magenta: magenta, yellow: yellow, key: key}
    else
      {:error, error} -> raise error
    end
  end

  @doc """
  Converts a tuple containing cyan, magenta, yellow and key color parts into a 
  `Tint.CMYK` struct.
  """
  @spec from_tuple({
          Decimal.t() | number,
          Decimal.t() | number,
          Decimal.t() | number,
          Decimal.t() | number
        }) :: t
  def from_tuple({cyan, magenta, yellow, key}) do
    new(cyan, magenta, yellow, key)
  end

  @doc """
  Converts CMYK color into a tuple containing the cyan, magenta, yellow and key
  parts.
  """
  @spec to_tuple(t) :: {float, float, float, float}
  def to_tuple(%__MODULE__{} = cmyk) do
    {Decimal.to_float(cmyk.cyan), Decimal.to_float(cmyk.magenta),
     Decimal.to_float(cmyk.yellow), Decimal.to_float(cmyk.key)}
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Tint.Utils.Formatter

    def inspect(cmyk, _opts) do
      concat([
        "#Tint.CMYK<",
        format_percentage(cmyk.cyan),
        ",",
        format_percentage(cmyk.magenta),
        ",",
        format_percentage(cmyk.yellow),
        ",",
        format_percentage(cmyk.key),
        ">"
      ])
    end
  end

  defimpl Tint.CMYK.Convertible do
    def to_cmyk(color), do: color
  end

  defimpl Tint.HSV.Convertible do
    def to_hsv(color) do
      color
      |> Tint.to_rgb()
      |> Tint.to_hsv()
    end
  end

  defimpl Tint.RGB.Convertible do
    alias Tint.RGB

    def to_rgb(color) do
      red = calc_value(color.key, color.cyan)
      green = calc_value(color.key, color.magenta)
      blue = calc_value(color.key, color.yellow)
      RGB.new(red, green, blue)
    end

    defp calc_value(key, component) do
      255
      |> Decimal.mult(Decimal.sub(1, component))
      |> Decimal.mult(Decimal.sub(1, key))
    end
  end
end
