defprotocol Tint.LCh.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec to_lch(Tint.color()) :: Tint.LCh.t()
  def to_lch(color)
end

defimpl Tint.LCh.Convertible, for: Any do
  def to_lch(color) do
    color
    |> Tint.to_lab()
    |> Tint.to_lch()
  end
end
