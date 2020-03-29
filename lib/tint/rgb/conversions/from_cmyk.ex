defimpl Tint.RGB.Convertible, for: Tint.CMYK do
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
