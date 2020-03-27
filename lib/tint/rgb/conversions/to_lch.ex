defimpl Tint.LCh.Convertible, for: Tint.RGB do
  def to_lch(color) do
    color
    |> Tint.to_lab()
    |> Tint.to_lch()
  end
end
