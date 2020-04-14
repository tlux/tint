defimpl Tint.CMYK.Convertible, for: Any do
  def convert(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_cmyk()
  end
end
