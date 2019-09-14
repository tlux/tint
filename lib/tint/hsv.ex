defmodule Tint.HSV do
  @moduledoc """
  A color in the HSV (hue, saturation, value) colorspace.
  """

  defstruct [:hue, :saturation, :value]

  @type t :: %__MODULE__{
          hue: number,
          saturation: float,
          value: float
        }

  defguardp is_hue(value) when is_number(value) and value >= 0 and value < 360

  defguardp is_percentage(value)
            when is_float(value) and value >= 0 and value <= 1

  @doc """
  Builds a new HSV color from a tuple.
  """
  @spec new({number, number, number}) :: t
  def new({hue, saturation, value}) do
    new(hue, saturation, value)
  end

  @doc """
  Builds a new HSV color from hue, saturation and value color parts.
  """
  @spec new(number, number, number) :: t
  def new(hue, saturation, value)
      when is_hue(hue) and
             is_percentage(saturation) and
             is_percentage(value) do
    %__MODULE__{hue: hue, saturation: saturation / 1, value: value / 1}
  end

  defimpl Tint.HSV.Convertible do
    def to_hsv(hsv), do: hsv
  end

  defimpl Tint.RGB.Convertible do
    alias Tint.RGB

    def to_rgb(hsv) do
      c = hsv.saturation * hsv.value
      x = c * calc_x_part(hsv.hue)
      m = hsv.value - c

      {red_ratio, green_ratio, blue_ratio} = calc_ratios(hsv.hue, c, x)

      red = round((red_ratio + m) * 255)
      green = round((green_ratio + m) * 255)
      blue = round((blue_ratio + m) * 255)

      RGB.new(red, green, blue)
    end

    defp calc_ratios(hue, c, x) when hue >= 0 and hue < 60, do: {c, x, 0}
    defp calc_ratios(hue, c, x) when hue >= 60 and hue < 120, do: {x, c, 0}
    defp calc_ratios(hue, c, x) when hue >= 120 and hue < 180, do: {0, c, x}
    defp calc_ratios(hue, c, x) when hue >= 180 and hue < 240, do: {0, x, c}
    defp calc_ratios(hue, c, x) when hue >= 240 and hue < 300, do: {x, 0, c}
    defp calc_ratios(hue, c, x) when hue >= 300 and hue < 360, do: {c, 0, x}

    defp calc_x_part(hue) do
      1 - abs(float_mod(hue / 60, 2) - 1)
    end

    defp float_mod(dividend, divisor) do
      times =
        dividend
        |> trunc()
        |> div(divisor)

      dividend - times * divisor
    end
  end
end
