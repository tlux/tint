defprotocol Tint.XYZ.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec to_xyz(Tint.color()) :: Tint.XYZ.t()
  def to_xyz(color)
end
