defmodule Tint.Utils do
  @moduledoc false

  alias Tint.OutOfRangeError
  alias Tint.Utils.Interval

  @component_interval Interval.new(0, 255)
  @degree_interval Interval.new(0, 360, exclude_max: true)
  @ratio_interval Interval.new(0, 1)

  @spec cast_component(Decimal.t() | number) ::
          {:ok, non_neg_integer} | {:error, OutOfRangeError.t()}
  def cast_component(value) do
    value
    |> cast_value(:integer)
    |> check_interval(@component_interval, value)
  end

  @spec cast_degrees(Decimal.t() | number) ::
          {:ok, Decimal.t()} | {:error, OutOfRangeError.t()}
  def cast_degrees(value) do
    value
    |> cast_value(:decimal)
    |> Decimal.round(1, :floor)
    |> check_interval(@degree_interval, value)
  end

  @spec cast_ratio(Decimal.t() | number) ::
          {:ok, Decimal.t()} | {:error, OutOfRangeError.t()}
  def cast_ratio(value) do
    value
    |> cast_value(:decimal)
    |> Decimal.round(3, :floor)
    |> check_interval(@ratio_interval, value)
  end

  defp check_interval(value, interval, orig_value) do
    if Interval.member?(interval, value) do
      {:ok, value}
    else
      {:error,
       %OutOfRangeError{
         orig_value: orig_value,
         value: value,
         interval: interval
       }}
    end
  end

  defp cast_value(%Decimal{} = value, :integer) do
    value
    |> Decimal.round(0, :floor)
    |> Decimal.to_integer()
  end

  defp cast_value(value, :integer) when is_integer(value), do: value

  defp cast_value(value, :integer) when is_float(value), do: trunc(value)

  defp cast_value(value, :integer) when is_binary(value) do
    case Integer.parse(value) do
      {num, _} -> num
      _ -> raise ArgumentError, "could not cast #{inspect(value)} to integer"
    end
  end

  defp cast_value(value, :decimal) do
    Decimal.cast(value)
  end

  @spec nth_root(number, integer, number) :: float
  def nth_root(x, n, precision \\ 1.0e-5) do
    f = fn prev -> ((n - 1) * prev + x / :math.pow(prev, n - 1)) / n end
    fixed_point(f, x, precision, f.(x))
  end

  defp fixed_point(_, guess, tolerance, next)
       when abs(guess - next) < tolerance,
       do: next

  defp fixed_point(f, _, tolerance, next) do
    fixed_point(f, next, tolerance, f.(next))
  end

  @spec delta_e(
          Tint.CIELAB.t() | Tint.DIN99.t(),
          Tint.CIELAB.t() | Tint.DIN99.t()
        ) :: float
  def delta_e(color, other_color) do
    other_color.lightness
    |> Decimal.sub(color.lightness)
    |> decimal_pow()
    |> Decimal.add(decimal_pow(Decimal.sub(other_color.a, color.a)))
    |> Decimal.add(decimal_pow(Decimal.sub(other_color.b, color.b)))
    |> Decimal.sqrt()
    |> Decimal.to_float()
  end

  defp decimal_pow(value) do
    Decimal.mult(value, value)
  end

  @spec nearest(
          Tint.color(),
          [Tint.color()],
          (Tint.color(), Tint.color() -> number),
          (Tint.color() -> Tint.color())
        ) :: nil | Tint.color()
  def nearest(
        color,
        palette,
        distance_algorithm,
        palette_map_fun
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
