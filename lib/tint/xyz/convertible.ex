defprotocol Tint.XYZ.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec convert(Tint.color()) :: Tint.XYZ.t()
  def convert(color)
end
