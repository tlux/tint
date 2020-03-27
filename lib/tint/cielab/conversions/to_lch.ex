defimpl Tint.LCh.Convertible, for: Tint.CIELAB do
  alias Tint.LCh

  def to_lch(color) do
    # TODO
    c =
      Decimal.sqrt(
        Decimal.add(
          Decimal.mult(color.a, color.a),
          Decimal.mult(color.b, color.b)
        )
      )

    h = 0

    LCh.new(color.lightness, c, h)
  end
end
