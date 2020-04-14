defprotocol Tint.Lab.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec convert(Tint.color()) :: Tint.Lab.t()
  def convert(color)
end
