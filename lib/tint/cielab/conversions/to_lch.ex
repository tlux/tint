defimpl Tint.LCh.Convertible, for: Tint.CIELAB do
  alias Tint.LCh
  alias Tint.Math

  def to_lch(color) do
    chroma = calc_chroma(color)
    hue = calc_hue(color)
    LCh.new(color.lightness, color.a, color.b, chroma, hue)
  end

  defp calc_chroma(color) do
    Decimal.sqrt(
      Decimal.add(
        Decimal.mult(color.a, color.a),
        Decimal.mult(color.b, color.b)
      )
    )
  end

  defp calc_hue(color) do
    if Decimal.eq?(color.a, 0) do
      Decimal.new(0)
    else
      color.b
      |> Decimal.div(color.a)
      |> Math.arctan()
      |> Math.rad_to_deg()
    end
  end
end
