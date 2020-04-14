defprotocol Tint.HSV.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec convert(Tint.color()) :: Tint.HSV.t()
  def convert(color)
end
