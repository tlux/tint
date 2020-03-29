defimpl Tint.Lab.Convertible, for: Tint.RGB do
  def to_lab(color) do
    color
    |> Tint.to_xyz()
    |> Tint.to_lab()
  end
end
