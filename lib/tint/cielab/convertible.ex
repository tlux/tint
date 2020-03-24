defprotocol Tint.CIELAB.Convertible do
  @moduledoc false

  @spec to_lab(Tint.color()) :: Tint.CIELAB.t()
  def to_lab(color)
end

defimpl Tint.CIELAB.Convertible, for: Any do
  def to_lab(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_lab()
  end
end
