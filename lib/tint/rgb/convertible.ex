defprotocol Tint.RGB.Convertible do
  @moduledoc false

  @spec convert(Tint.color()) :: Tint.RGB.t()
  def convert(color)
end
