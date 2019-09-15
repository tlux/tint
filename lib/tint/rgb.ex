defmodule Tint.RGB do
  @moduledoc """
  A color in the RGB (red, green, blue) colorspace.
  """

  import Tint.Utils

  alias Tint.RGB.HexCode

  defstruct [:red, :green, :blue]

  @value_range 0..255

  @type t :: %__MODULE__{
          red: non_neg_integer,
          green: non_neg_integer,
          blue: non_neg_integer
        }

  @doc """
  Builds a new RGB color from red, green and green color values.
  """
  @spec new(Decimal.t() | number, Decimal.t() | number, Decimal.t() | number) ::
          t
  def new(red, green, blue) do
    red = cast_integer(red)
    green = cast_integer(green)
    blue = cast_integer(blue)

    with :ok <- check_value_in_range(red, @value_range),
         :ok <- check_value_in_range(green, @value_range),
         :ok <- check_value_in_range(blue, @value_range) do
      %__MODULE__{red: red, green: green, blue: blue}
    else
      {:error, error} -> raise error
    end
  end

  defp cast_integer(%Decimal{} = value) do
    value |> Decimal.round() |> Decimal.to_integer()
  end

  defp cast_integer(value) when is_integer(value), do: value
  defp cast_integer(value) when is_float(value), do: trunc(value)

  @doc """
  Builds a new RGB color from the given hex code.
  """
  @spec from_hex(String.t()) :: {:ok, t} | :error
  def from_hex(code) do
    HexCode.parse(code)
  end

  @doc """
  Builds a new RGB color from the given hex code. Raises when the given hex code
  is invalid.
  """
  @spec from_hex!(String.t()) :: t | no_return
  def from_hex!(code) do
    case from_hex(code) do
      {:ok, color} -> color
      :error -> raise ArgumentError, "Invalid hex code: #{code}"
    end
  end

  @doc """
  Converts a RGB color to a hex code.
  """
  @spec to_hex(t) :: String.t()
  def to_hex(%__MODULE__{} = color) do
    HexCode.serialize(color)
  end

  defimpl Tint.RGB.Convertible do
    def to_rgb(rgb), do: rgb
  end

  defimpl Tint.HSV.Convertible do
    alias Tint.HSV

    def to_hsv(rgb) do
      red_ratio = rgb.red / 255
      green_ratio = rgb.green / 255
      blue_ratio = rgb.blue / 255
      rgb_ratios = [red_ratio, green_ratio, blue_ratio]
      max_ratio = Enum.max(rgb_ratios)
      min_ratio = Enum.min(rgb_ratios)
      ratio_delta = max_ratio - min_ratio

      hue = calc_hue(ratio_delta, max_ratio, rgb_ratios)
      saturation = calc_saturation(ratio_delta, max_ratio)
      value = calc_value(max_ratio)

      HSV.new(hue, saturation, value)
    end

    defp calc_hue(ratio_delta, max_ratio, rgb_ratios) do
      hue = do_calc_hue(ratio_delta, max_ratio, rgb_ratios)

      if hue < 0 do
        hue + 360
      else
        hue
      end
    end

    defp do_calc_hue(ratio_delta, _, _) when ratio_delta == 0, do: 0.0

    defp do_calc_hue(ratio_delta, max_ratio, [
           red_ratio,
           green_ratio,
           blue_ratio
         ])
         when red_ratio == max_ratio do
      60 * ((green_ratio - blue_ratio) / ratio_delta)
    end

    defp do_calc_hue(ratio_delta, max_ratio, [
           red_ratio,
           green_ratio,
           blue_ratio
         ])
         when green_ratio == max_ratio do
      60 * ((blue_ratio - red_ratio) / ratio_delta + 2)
    end

    defp do_calc_hue(ratio_delta, max_ratio, [
           red_ratio,
           green_ratio,
           blue_ratio
         ])
         when blue_ratio == max_ratio do
      60 * ((red_ratio - green_ratio) / ratio_delta + 4)
    end

    defp calc_saturation(ratio_delta, _max_ratio) when ratio_delta == 0, do: 0.0
    defp calc_saturation(ratio_delta, max_ratio), do: ratio_delta / max_ratio

    defp calc_value(max_ratio), do: max_ratio / 1
  end
end
