defmodule Tint.Distance do
  @moduledoc false

  @type distance_fun :: (Tint.color(), Tint.color() -> Tint.color())

  @spec nearest_color(Tint.color(), [Tint.color()], distance_fun) ::
          nil | Tint.color()
  def nearest_color(color, palette, distance_fun) do
    case nearest_colors(color, palette, 1, distance_fun) do
      [nearest_color] -> nearest_color
      _ -> nil
    end
  end

  @spec nearest_colors(
          Tint.color(),
          [Tint.color()],
          non_neg_integer,
          distance_fun
        ) :: [Tint.color()]
  def nearest_colors(color, palette, n, distance_fun) do
    palette
    |> Enum.sort_by(fn palette_color ->
      distance_fun.(color, palette_color)
    end)
    |> Enum.take(n)
  end
end
