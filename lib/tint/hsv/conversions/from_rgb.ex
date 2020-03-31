defimpl Tint.HSV.Convertible, for: Tint.RGB do
  alias Tint.HSV
  alias Tint.RGB

  def to_hsv(color) do
    rgb_ratios = RGB.to_ratios(color)
    rgb_ratio_list = Tuple.to_list(rgb_ratios)
    min_ratio = Enum.min(rgb_ratio_list)
    max_ratio = Enum.max(rgb_ratio_list)
    ratio_delta = max_ratio - min_ratio

    hue = calc_hue(ratio_delta, max_ratio, rgb_ratios)
    saturation = calc_saturation(ratio_delta, max_ratio)
    value = Float.round(max_ratio, 4)

    %HSV{hue: hue, saturation: saturation, value: value}
  end

  defp calc_hue(ratio_delta, max_ratio, rgb_ratios) do
    hue = do_calc_hue(ratio_delta, max_ratio, rgb_ratios)

    if hue < 0 do
      hue + 360
    else
      hue
    end
  end

  defp do_calc_hue(ratio_delta, max_ratio, {
         red_ratio,
         green_ratio,
         blue_ratio
       }) do
    cond do
      ratio_delta == 0 ->
        0.0

      red_ratio == max_ratio ->
        calc_channel_hue(green_ratio, blue_ratio, ratio_delta, 0)

      green_ratio == max_ratio ->
        calc_channel_hue(blue_ratio, red_ratio, ratio_delta, 2)

      blue_ratio == max_ratio ->
        calc_channel_hue(red_ratio, green_ratio, ratio_delta, 4)
    end
  end

  defp calc_channel_hue(first_ratio, second_ratio, ratio_delta, offset) do
    Float.round(60 * ((first_ratio - second_ratio) / ratio_delta + offset), 1)
  end

  defp calc_saturation(ratio_delta, max_ratio) do
    if ratio_delta == 0 do
      0.0
    else
      Float.round(ratio_delta / max_ratio, 4)
    end
  end
end
