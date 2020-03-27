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

  @doc """
  Calculates the distance of two colors using the
  [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance)
  algorithm.
  """
  @doc since: "0.4.0"
  @spec euclidean_distance(tuple, tuple) :: float
  def euclidean_distance(color, other_color) do
    weights = Tuple.duplicate(1, tuple_size(color))
    euclidean_distance(color, other_color, weights)
  end

  @doc """
  Calculates the distance of two colors using the
  [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance)
  algorithm. Additionally, allows specifying weights for the individual color
  channels.
  """
  @doc since: "0.4.0"
  @spec euclidean_distance(tuple, tuple, tuple) :: float
  def euclidean_distance(color, other_color, weights)
      when tuple_size(color) == tuple_size(other_color) and
             tuple_size(color) == tuple_size(weights) do
    color
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.map(fn {channel, index} ->
      other_channel = elem(other_color, index)
      weight = elem(weights, index)
      diff = Decimal.sub(other_channel, channel)
      Decimal.mult(weight, Decimal.mult(diff, diff))
    end)
    |> Enum.reduce(&Decimal.add/2)
    |> Decimal.sqrt()
    |> Decimal.to_float()
  end
end
