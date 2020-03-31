defimpl Tint.DIN99.Convertible, for: Tint.Lab do
  alias Tint.DIN99

  @cos_16 :math.cos(16)
  @sin_16 :math.sin(16)

  def to_din99(color) do
    l99 = calc_l99(color)
    {a99, b99} = calc_ab99(color)
    %DIN99{lightness: l99, a: a99, b: b99}
  end

  defp calc_l99(color) do
    round_channel(105.51 * :math.log(1 + 0.0158 * color.lightness))
  end

  defp calc_ab99(color) do
    if color.a == 0 && color.b == 0 do
      {0.0, 0.0}
    else
      e = color.a * @cos_16 + color.b * @sin_16
      f = 0.7 * (-color.a * @sin_16 + color.b * @cos_16)
      g = :math.sqrt(:math.pow(e, 2) + :math.pow(f, 2))
      k = :math.log(1 + 0.045 * g) / 0.045
      a99 = k * (e / g)
      b99 = k * (f / g)
      {round_channel(a99), round_channel(b99)}
    end
  end

  defp round_channel(channel) do
    Float.round(channel, 4)
  end
end
