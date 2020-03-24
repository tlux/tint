defimpl Tint.RGB.Convertible, for: Tint.XYZ do
  def to_rgb(_color) do
    raise "Conversion from XYZ to RGB is not yet supported"
  end
end
