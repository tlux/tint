defimpl Tint.CIELAB.Convertible, for: Tint.LCh do
  alias Tint.CIELAB

  def to_lab(color) do
    CIELAB.new(color.lightness, color.a, color.b)
  end
end
