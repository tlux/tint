defimpl Tint.XYZ.Convertible, for: Tint.RGB do
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
    %XYZ{x: x, y: y, z: z}
  end

  defp fix_ratio(ratio) do
    normalized =
      if ratio > 0.04045 do
        :math.pow((ratio + 0.055) / 1.055, 2.4)
      else
        ratio / 12.92
      end

    normalized * 100
  end

  defp calc_x(red_ratio, green_ratio, blue_ratio) do
    calc_channel(red_ratio, green_ratio, blue_ratio, 0.4124, 0.3576, 0.1805)
  end

  defp calc_y(red_ratio, green_ratio, blue_ratio) do
    calc_channel(red_ratio, green_ratio, blue_ratio, 0.2126, 0.7152, 0.0722)
  end

  defp calc_z(red_ratio, green_ratio, blue_ratio) do
    calc_channel(red_ratio, green_ratio, blue_ratio, 0.0193, 0.1192, 0.9505)
  end

  defp calc_channel(
         red_ratio,
         green_ratio,
         blue_ratio,
         red_coeff,
         green_coeff,
         blue_coeff
       ) do
    Float.round(
      red_ratio * red_coeff + green_ratio * green_coeff +
        blue_ratio * blue_coeff,
      4
    )
  end
end
