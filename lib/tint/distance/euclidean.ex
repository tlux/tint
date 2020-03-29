defmodule Tint.Distance.Euclidean do
  @moduledoc false

  @spec euclidean_distance(Tint.color(), Tint.color(), Keyword.t()) :: float
  def euclidean_distance(color, other_color, opts \\ []) do
    color = Tint.to_rgb(color)
    other_color = Tint.to_rgb(other_color)
    {red_weight, green_weight, blue_weight} = opts[:weights] || {1, 1, 1}

    :math.sqrt(
      red_weight * :math.pow(other_color.red - color.red, 2) +
        green_weight * :math.pow(other_color.green - color.green, 2) +
        blue_weight * :math.pow(other_color.blue - color.blue, 2)
    )
  end

  @spec human_euclidean_distance(Tint.color(), Tint.color()) :: float
  def human_euclidean_distance(color, other_color) do
    weights = if color.red < 128, do: {2, 4, 3}, else: {3, 4, 2}
    euclidean_distance(color, other_color, weights: weights)
  end
end
