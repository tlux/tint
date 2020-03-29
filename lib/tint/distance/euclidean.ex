defmodule Tint.Distance.Euclidean do
  @moduledoc false

  @behaviour Tint.Distance

  @impl true
  def distance(color, other_color, opts) do
    color = Tint.to_rgb(color)
    other_color = Tint.to_rgb(other_color)
    {red_weight, green_weight, blue_weight} = opts[:weights] || {1, 1, 1}

    :math.sqrt(
      red_weight * :math.pow(other_color.red - color.red, 2) +
        green_weight * :math.pow(other_color.green - color.green, 2) +
        blue_weight * :math.pow(other_color.blue - color.blue, 2)
    )
  end
end
