defprotocol Tint.CMYK.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec convert(Tint.color()) :: Tint.CMYK.t()
  def convert(color)
end
