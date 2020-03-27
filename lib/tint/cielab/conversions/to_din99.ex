defimpl Tint.DIN99.Convertible, for: Tint.CIELAB do
  alias Tint.DIN99

  @cos_16 Decimal.from_float(:math.cos(16))
  @sin_16 Decimal.from_float(:math.sin(16))

  def to_din99(color) do
    l99 =
      Decimal.mult(
        "105.51",
        decimal_ln(Decimal.add(1, Decimal.mult("0.0158", color.lightness)))
      )

    {a99, b99} =
      if Decimal.eq?(color.a, 0) && Decimal.eq?(color.b, 0) do
        {0, 0}
      else
        calc_ab99(color)
      end

    DIN99.new(l99, a99, b99)
  end

  defp calc_ab99(color) do
    e =
      color.a
      |> Decimal.mult(@cos_16)
      |> Decimal.add(Decimal.mult(color.b, @sin_16))

    f =
      Decimal.mult(
        "0.7",
        Decimal.add(
          Decimal.mult(Decimal.mult(-1, color.a), @sin_16),
          Decimal.mult(color.b, @cos_16)
        )
      )

    g =
      Decimal.sqrt(
        Decimal.add(
          Decimal.mult(e, e),
          Decimal.mult(f, f)
        )
      )

    k =
      Decimal.div(
        decimal_ln(Decimal.add(1, Decimal.mult("0.045", g))),
        "0.045"
      )

    a99 = Decimal.mult(k, Decimal.div(e, g))
    b99 = Decimal.mult(k, Decimal.div(f, g))
    {a99, b99}
  end

  defp decimal_ln(value) do
    value
    |> Decimal.new()
    |> Decimal.to_float()
    |> :math.log()
    |> Decimal.from_float()
  end
end
