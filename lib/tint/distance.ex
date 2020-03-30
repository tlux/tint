defmodule Tint.Distance do
  @moduledoc """
  Main module providing color distance calculations.
  """

  alias Tint.DistanceCache

  @type distance_fun :: (Tint.color(), Tint.color() -> number)
  @type distance_calculator :: module | {module, Keyword.t()} | distance_fun

  @doc """
  Calculate the distance of two colors using the given options.
  """
  @callback distance(
              color :: Tint.color(),
              other_color :: Tint.color(),
              opts :: Keyword.t()
            ) :: number

  @doc """
  Calculate the distance of two colors using the given distance calculator.
  Caches the results if the distance cache is running.
  """
  @spec distance(Tint.color(), Tint.color(), distance_calculator) :: float
  def distance(color, other_color, distance_calculator)

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
  calculator.
  """
  @spec nearest_color(Tint.color(), [Tint.color()], distance_calculator) ::
          nil | Tint.color()
  def nearest_color(color, palette, distance_calculator) do
    case nearest_colors(color, palette, 1, distance_calculator) do
      [nearest_color] -> nearest_color
      _ -> nil
    end
  end

  @doc """
  Gets the nearest n colors from the specified palette using the given distance
  calculator.
  """
  @spec nearest_colors(
          Tint.color(),
          [Tint.color()],
          non_neg_integer,
          distance_calculator
        ) :: [Tint.color()]
  def nearest_colors(color, palette, n, distance_calculator) do
    palette
    |> Enum.sort_by(fn palette_color ->
      distance(color, palette_color, distance_calculator)
    end)
    |> Enum.take(n)
  end
end
