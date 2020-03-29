defimpl Tint.CMYK.Convertible, for: Tint.RGB do
  alias Tint.CMYK
  alias Tint.RGB

  def to_cmyk(%{red: 0, green: 0, blue: 0}) do
    CMYK.new(0, 0, 0, 1)
  end

  def to_cmyk(color) do
    {red_ratio, green_ratio, blue_ratio} = RGB.to_ratios(color)

    max_ratio =
      Enum.reduce([red_ratio, green_ratio, blue_ratio], &Decimal.max/2)

    key = Decimal.sub(1, max_ratio)
    cyan = calc_value(key, red_ratio)
    magenta = calc_value(key, green_ratio)
    yellow = calc_value(key, blue_ratio)

    CMYK.new(cyan, magenta, yellow, key)
  end

  defp calc_value(key, ratio) do
    dividend = 1 |> Decimal.sub(ratio) |> Decimal.sub(key)
    divisor = Decimal.sub(1, key)
    Decimal.div(dividend, divisor)
  end
end
