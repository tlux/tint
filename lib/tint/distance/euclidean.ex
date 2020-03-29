defmodule Tint.Distance.Euclidean do
  @spec euclidean_distance(RGB.t(), RGB.t(), Keyword.t()) :: float
  def euclidean_distance(color, other_color, opts \\ []) do
    {red_weight, green_weight, blue_weight} = opts[:weights] || {1, 1, 1}

    red_diff = other_color.red - color.red
    green_diff = other_color.green - color.green
    blue_diff = other_color.blue - color.blue

    :math.sqrt(
      red_weight * :math.pow(red_diff, 2) +
        green_weight * :math.pow(green_diff, 2) +
        blue_weight * :math.pow(blue_diff, 2)
    )
  end

  def human_euclidean_distance(color, other_color) do
    weights = if color.red < 128, do: {2, 4, 3}, else: {3, 4, 2}
    euclidean_distance(color, other_color, weights: weights)
  end
end
