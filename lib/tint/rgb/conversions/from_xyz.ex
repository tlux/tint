defimpl Tint.RGB.Convertible, for: Tint.XYZ do
  alias Tint.RGB
  alias Tint.XYZ

  def convert(color) do
    %XYZ{x: x, y: y, z: z} = color
    x = x / 100
    y = y / 100
    z = z / 100

    r = x * 3.240812398895283 - y * 1.5373084456298136 - z * 0.4985865229069666

    g =
      x * -0.9692430170086407 + y * 1.8759663029085742 + z * 0.04155503085668564

    b =
      x * 0.055638398436112804 - y * 0.20400746093241362 +
        z * 1.0571295702861434

    %RGB{
      red: gamma_compression(r),
      green: gamma_compression(g),
      blue: gamma_compression(b)
    }
  end

  defp gamma_compression(linear) do
    v =
      if linear <= 0.00313066844250060782371 do
        3294.6 * linear
      else
        269.025 * :math.pow(linear, 5.0 / 12.0) - 14.025
      end

    v |> round() |> min(255) |> max(0)
  end
end
