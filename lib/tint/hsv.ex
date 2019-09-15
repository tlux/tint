defmodule Tint.HSV do
  @moduledoc """
  A color in the HSV (hue, saturation, value) colorspace.
  """

  import Tint.Utils

  defstruct [:hue, :saturation, :value]

  @hue_value_range 0..360
  @percentage_range 0..1

  @type t :: %__MODULE__{
          hue: Decimal.t(),
          saturation: Decimal.t(),
          value: Decimal.t()
        }

  @doc """
  Builds a new HSV color from hue, saturation and value color parts.
  """
  @spec new(Decimal.t() | number, Decimal.t() | number, Decimal.t() | number) ::
          t
  def new(hue, saturation, value) do
    hue = cast_decimal(hue)
    saturation = cast_decimal(saturation)
    value = cast_decimal(value)

    with :ok <- check_value_in_range(hue, @hue_value_range),
         :ok <- check_value_in_range(saturation, @percentage_range),
         :ok <- check_value_in_range(value, @percentage_range) do
      %__MODULE__{hue: hue, saturation: saturation, value: value}
    else
      {:error, error} -> raise error
    end
  end

  defp cast_decimal(value) do
    value |> Decimal.cast() |> Decimal.reduce()
  end

  defimpl Tint.HSV.Convertible do
    def to_hsv(hsv), do: hsv
  end

  defimpl Tint.RGB.Convertible do
    alias Tint.RGB

    def to_rgb(hsv) do
      c = Decimal.mult(hsv.saturation, hsv.value)
      x = Decimal.mult(c, calc_x_part(hsv.hue))
      m = Decimal.sub(hsv.value, c)

      {red_ratio, green_ratio, blue_ratio} = calc_ratios(hsv.hue, c, x)

      red = calc_value(red_ratio, m)
      green = calc_value(green_ratio, m)
      blue = calc_value(blue_ratio, m)

      RGB.new(red, green, blue)
    end

    defp calc_value(ratio, m) do
      Decimal.round(Decimal.mult(Decimal.add(ratio, m), 255))
    end

    defp calc_ratios(hue, c, x) do
      cond do
        in_range?(hue, 0, 60) ->
          {c, x, 0}

        in_range?(hue, 60, 120) ->
          {x, c, 0}

        in_range?(hue, 120, 180) ->
          {0, c, x}

        in_range?(hue, 180, 240) ->
          {0, x, c}

        in_range?(hue, 240, 300) ->
          {x, 0, c}

        in_range?(hue, 300, 360) ->
          {c, 0, x}
      end
    end

    defp in_range?(value, min, max) do
      (Decimal.gt?(value, min) || Decimal.eq?(value, min)) &&
        Decimal.lt?(value, max)
    end

    defp calc_x_part(hue) do
      Decimal.sub(
        1,
        Decimal.abs(Decimal.sub(Decimal.rem(Decimal.div(hue, 60), 2), 1))
      )

      # 1 - abs(float_mod(hue / 60, 2) - 1)
    end
  end
end
