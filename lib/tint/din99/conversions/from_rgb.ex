defimpl Tint.DIN99.Convertible, for: Tint.RGB do
  def to_din99(color) do
    color
    |> Tint.to_lab()
    |> Tint.to_din99()
  end
end
