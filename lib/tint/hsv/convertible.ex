defprotocol Tint.HSV.Convertible do
  @moduledoc false

  @fallback_to_any true

  @spec to_hsv(Tint.color()) :: Tint.HSV.t()
  def to_hsv(color)
end

defimpl Tint.HSV.Convertible, for: Any do
  def to_hsv(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_hsv()
  end
end
