defimpl Tint.XYZ.Convertible, for: Tint.Lab do
  alias Tint.Lab
  alias Tint.XYZ

  @cbrt_epsilon 6.0 / 29.0
  @kappa 24_389.0 / 27.0

  def convert(color) do
    {l, a, b} = Lab.to_tuple(color)

    fy = (l + 16.0) / 116.0
    fx = a / 500 + fy
    fz = fy - b / 200.0

    x = inverse(fx) * 0.9504492182750991

    y =
      if l > 8 do
        :math.pow(fy, 3)
      else
        l / @kappa
      end

    z = inverse(fz) * 1.0889166484304715

    %XYZ{x: x * 100, y: y * 100, z: z * 100}
  end

  defp inverse(coord) do
    if coord > @cbrt_epsilon do
      :math.pow(coord, 3)
    else
      (coord * 116.0 - 16.0) / @kappa
    end
  end
end
