defimpl Tint.XYZ.Convertible, for: Any do
  def to_xyz(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_xyz()
  end
end
