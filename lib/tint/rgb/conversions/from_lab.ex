defimpl Tint.RGB.Convertible, for: Tint.Lab do
  def convert(color) do
    color
    |> Tint.to_xyz()
    |> Tint.to_rgb()
  end
end
