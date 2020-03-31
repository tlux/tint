defmodule Tint.Distance do
  @moduledoc """
  A module providing functions for color distance calculations and a behavior
  to implement custom distance algorithms.
  """

  alias Tint.DistanceCache

  @typedoc """
  A function that allows calculating the distance between two colors.
  """
  @type distance_fun :: (Tint.color(), Tint.color() -> number)

  @typedoc """
  A distance calculation module that implements this very behavior or a function
  that allows calculating the distance between two colors.
  """
  @type distance_algorithm :: module | {module, Keyword.t()} | distance_fun

  @doc """
  Calculate the distance of two colors using the given options.
  """
  @callback distance(
              color :: Tint.color(),
              other_color :: Tint.color(),
              opts :: Keyword.t()
            ) :: number

  @doc """
  Calculate the distance of two colors using the given distance algorithm.
  """
  @spec distance(Tint.color(), Tint.color(), distance_algorithm) :: float
  def distance(color, other_color, distance_algorithm)

  def distance(color, other_color, fun) when is_function(fun) do
    maybe_cache({color, other_color, fun}, fn ->
      fun.(color, other_color)
    end)
  end

  def distance(color, other_color, {mod, opts}) do
    maybe_cache({color, other_color, mod, opts}, fn ->
      mod.distance(color, other_color, opts)
    end)
  end

  def distance(color, other_color, mod) do
    distance(color, other_color, {mod, []})
  end

  defp maybe_cache(key, calc_fun) do
    if GenServer.whereis(DistanceCache) do
      DistanceCache.get_or_put(key, calc_fun)
    else
      calc_fun.()
    end
  end

  @doc """
  Gets the nearest color from the specified palette using the given distance
  algorithm.
  """
  @spec nearest_color(Tint.color(), [Tint.color()], distance_algorithm) ::
          nil | Tint.color()
  def nearest_color(color, palette, distance_algorithm) do
    case nearest_colors(color, palette, 1, distance_algorithm) do
      [nearest_color] -> nearest_color
      _ -> nil
    end
  end

  @doc """
  Gets the nearest n colors from the specified palette using the given distance
  algorithm.
  """
  @spec nearest_colors(
          Tint.color(),
          [Tint.color()],
          non_neg_integer,
          distance_algorithm
        ) :: [Tint.color()]
  def nearest_colors(color, palette, n, distance_algorithm) do
    palette
    |> Enum.sort_by(fn palette_color ->
      distance(color, palette_color, distance_algorithm)
    end)
    |> Enum.take(n)
  end
end
