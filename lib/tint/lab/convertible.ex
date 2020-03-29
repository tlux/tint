defprotocol Tint.Lab.Convertible do
  @moduledoc false

  @spec to_lab(Tint.color()) :: Tint.Lab.t()
  def to_lab(color)
end
