defmodule Tint.Distance.HumanEuclidean do
  @moduledoc false

  @behaviour Tint.Distance

  alias Tint.Distance.Euclidean

  @impl true
  def distance(color, other_color, _opts) do
    weights = if color.red < 128, do: {2, 4, 3}, else: {3, 4, 2}
    Euclidean.distance(color, other_color, weights: weights)
  end
end
