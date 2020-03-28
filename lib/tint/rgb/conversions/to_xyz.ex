defimpl Tint.XYZ.Convertible, for: Tint.RGB do
  alias Tint.Math
  alias Tint.RGB
  alias Tint.XYZ

  def to_xyz(color) do
    {red_ratio, green_ratio, blue_ratio} = RGB.to_ratios(color)
    red_ratio = fix_ratio(red_ratio)
    green_ratio = fix_ratio(green_ratio)
    blue_ratio = fix_ratio(blue_ratio)
    x = calc_x(red_ratio, green_ratio, blue_ratio)
    y = calc_y(red_ratio, green_ratio, blue_ratio)
    z = calc_z(red_ratio, green_ratio, blue_ratio)
    XYZ.new(x, y, z)
  end

  defp fix_ratio(ratio) do
    normalized =
      if Decimal.gt?(ratio, "0.04045") do
        ratio
        |> Decimal.add("0.055")
        |> Decimal.div("1.055")
        |> Math.pow(2.4)
      else
        Decimal.div(ratio, "12.92")
      end

    Decimal.mult(normalized, 100)
  end

  defp calc_x(red_ratio, green_ratio, blue_ratio) do
    calc_channel(
      red_ratio,
      green_ratio,
      blue_ratio,
      "0.4124",
      "0.3576",
      "0.1805"
    )
  end

  defp calc_y(red_ratio, green_ratio, blue_ratio) do
    calc_channel(
      red_ratio,
      green_ratio,
      blue_ratio,
      "0.2126",
      "0.7152",
      "0.0722"
    )
  end

  defp calc_z(red_ratio, green_ratio, blue_ratio) do
    calc_channel(
      red_ratio,
      green_ratio,
      blue_ratio,
      "0.0193",
      "0.1192",
      "0.9505"
    )
  end

  defp calc_channel(
         red_ratio,
         green_ratio,
         blue_ratio,
         red_coeff,
         green_coeff,
         blue_coeff
       ) do
    red_ratio
    |> Decimal.mult(red_coeff)
    |> Decimal.add(Decimal.mult(green_ratio, green_coeff))
    |> Decimal.add(Decimal.mult(blue_ratio, blue_coeff))
  end
end
