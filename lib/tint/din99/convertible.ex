defprotocol Tint.DIN99.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec convert(Tint.color()) :: Tint.DIN99.t()
  def convert(color)
end
