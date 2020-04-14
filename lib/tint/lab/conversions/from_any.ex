defimpl Tint.Lab.Convertible, for: Any do
  def convert(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_lab()
  end
end
