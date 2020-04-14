defimpl Tint.HSV.Convertible, for: Any do
  def convert(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_hsv()
  end
end
