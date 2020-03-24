defimpl Tint.CMYK.Convertible, for: Any do
  def to_cmyk(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_cmyk()
  end
end
