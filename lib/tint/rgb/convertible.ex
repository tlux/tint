defprotocol Tint.RGB.Convertible do
  @moduledoc false

  @spec to_rgb(Tint.color()) :: Tint.RGB.t()
  def to_rgb(color)
end
