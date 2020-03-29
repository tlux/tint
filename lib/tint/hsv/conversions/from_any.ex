defimpl Tint.HSV.Convertible, for: Any do
  def to_hsv(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_hsv()
  end
end
