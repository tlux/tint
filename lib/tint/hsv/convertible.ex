defprotocol Tint.HSV.Convertible do
  @spec to_hsv(Tint.color()) :: Tint.HSV.t()
  def to_hsv(color)
end
