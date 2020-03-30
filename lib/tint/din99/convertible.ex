defprotocol Tint.DIN99.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec to_din99(Tint.color()) :: Tint.DIN99.t()
  def to_din99(color)
end
