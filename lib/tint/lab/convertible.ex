defprotocol Tint.Lab.Convertible do
  @moduledoc false

  @spec to_lab(Tint.color()) :: Tint.Lab.t()
  def to_lab(color)
end

defimpl Tint.Lab.Convertible, for: Any do
  def to_lab(color) do
    color
    |> Tint.to_rgb()
    |> Tint.to_lab()
  end
end
