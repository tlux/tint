defimpl Tint.CIELAB.Convertible, for: Tint.XYZ do
  alias Tint.CIELAB
  alias Tint.Math

  @small_value_threshold Decimal.div(216, 24_389)
  @xn Decimal.new("95.0489")
  @yn Decimal.new(100)
  @zn Decimal.new("108.8840")

  def to_lab(color) do
    l =
      116
      |> Decimal.mult(inner_fun(Decimal.div(color.y, @yn)))
      |> Decimal.sub(16)

    a =
      Decimal.mult(
        500,
        Decimal.sub(
          inner_fun(Decimal.div(color.x, @xn)),
          inner_fun(Decimal.div(color.y, @yn))
        )
      )

    b =
      Decimal.mult(
        200,
        Decimal.sub(
          inner_fun(Decimal.div(color.y, @yn)),
          inner_fun(Decimal.div(color.z, @zn))
        )
      )

    CIELAB.new(l, a, b)
  end

  defp inner_fun(value) do
    if Decimal.lt?(value, @small_value_threshold) do
      1
      |> Decimal.div(116)
      |> Decimal.mult(
        Decimal.add(Decimal.mult(Decimal.div(24_389, 27), value), 16)
      )
    else
      Math.nth_root(value, 3)
    end
  end
end
