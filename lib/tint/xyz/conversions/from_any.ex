defimpl Tint.XYZ.Convertible, for: Any do
  def convert(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_xyz()
  end
end
