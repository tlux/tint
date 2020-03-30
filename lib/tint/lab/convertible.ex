defprotocol Tint.Lab.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec to_lab(Tint.color()) :: Tint.Lab.t()
  def to_lab(color)
end
