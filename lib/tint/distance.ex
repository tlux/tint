defmodule Tint.Distance do
  @doc """
  Determines the nearest color from the given color palette using the specified
  distance algorithm.
  """
  @doc since: "0.4.0"
  @spec nearest(
          Tint.color(),
          [Tint.color()],
          (Tint.color() -> Tint.color()),
          (Tint.color(), Tint.color() -> number)
        ) :: nil | Tint.color()
  def nearest(
        color,
        palette,
        palette_map_fun,
        distance_algorithm
      ) do
    Enum.min_by(
      palette,
      fn other_color ->
        distance_algorithm.(color, palette_map_fun.(other_color))
      end,
      fn -> nil end
    )
  end
end
