defimpl Tint.DIN99.Convertible, for: Any do
  def convert(color) do
    color
    |> Tint.to_lab()
    |> Tint.to_din99()
  end
end
