defimpl Tint.HSV.Convertible, for: Tint.RGB do
  alias Tint.HSV
  alias Tint.RGB

  def to_hsv(color) do
    rgb_ratios = RGB.to_ratios(color)
    rgb_ratio_list = Tuple.to_list(rgb_ratios)
    min_ratio = Enum.reduce(rgb_ratio_list, &Decimal.min(&1, &2))
    max_ratio = Enum.reduce(rgb_ratio_list, &Decimal.max(&1, &2))
    ratio_delta = Decimal.sub(max_ratio, min_ratio)

    hue = calc_hue(ratio_delta, max_ratio, rgb_ratios)
    saturation = calc_saturation(ratio_delta, max_ratio)

    HSV.new(hue, saturation, max_ratio)
  end

  defp calc_hue(ratio_delta, max_ratio, rgb_ratios) do
    hue = do_calc_hue(ratio_delta, max_ratio, rgb_ratios)

    if Decimal.lt?(hue, 0) do
      Decimal.add(hue, 360)
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
      Decimal.eq?(ratio_delta, 0) ->
        Decimal.new(0)

      Decimal.eq?(red_ratio, max_ratio) ->
        calc_hue_component(green_ratio, blue_ratio, ratio_delta, 0)

      Decimal.eq?(green_ratio, max_ratio) ->
        calc_hue_component(blue_ratio, red_ratio, ratio_delta, 2)

      Decimal.eq?(blue_ratio, max_ratio) ->
        calc_hue_component(red_ratio, green_ratio, ratio_delta, 4)
    end
  end

  defp calc_hue_component(first_ratio, second_ratio, ratio_delta, offset) do
    Decimal.mult(
      60,
      Decimal.add(
        Decimal.div(Decimal.sub(first_ratio, second_ratio), ratio_delta),
        offset
      )
    )
  end

  defp calc_saturation(ratio_delta, max_ratio) do
    if Decimal.eq?(ratio_delta, 0) do
      Decimal.new(0)
    else
      Decimal.div(ratio_delta, max_ratio)
    end
  end
end
