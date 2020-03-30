defprotocol Tint.CMYK.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec to_cmyk(Tint.color()) :: Tint.CMYK.t()
  def to_cmyk(color)
end
