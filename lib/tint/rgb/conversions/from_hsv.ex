defimpl Tint.RGB.Convertible, for: Tint.HSV do
  alias Tint.RGB
  alias Tint.Utils.Interval

  def to_rgb(color) do
    c = Decimal.mult(color.saturation, color.value)
    x = Decimal.mult(c, calc_x_part(color.hue))
    m = Decimal.sub(color.value, c)

    {red_ratio, green_ratio, blue_ratio} = calc_ratios(color.hue, c, x)
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
      in_interval?(hue, 0, 60) -> {c, x, 0}
      in_interval?(hue, 60, 120) -> {x, c, 0}
      in_interval?(hue, 120, 180) -> {0, c, x}
      in_interval?(hue, 180, 240) -> {0, x, c}
      in_interval?(hue, 240, 300) -> {x, 0, c}
      in_interval?(hue, 300, 360) -> {c, 0, x}
    end
  end

  defp in_interval?(value, min, max) do
    min
    |> Interval.new(max, exclude_max: true)
    |> Interval.member?(value)
  end

  defp calc_x_part(hue) do
    Decimal.sub(
      1,
      Decimal.abs(Decimal.sub(Decimal.rem(Decimal.div(hue, 60), 2), 1))
    )
  end
end
