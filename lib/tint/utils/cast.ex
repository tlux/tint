defmodule Tint.Utils.Cast do
  @moduledoc false

  alias Tint.OutOfRangeError
  alias Tint.Interval

  @ratio_interval Interval.new(0, 1)

  @type cast_type :: :integer | :float

  @spec cast_value!(number | String.t(), cast_type) :: integer | float
  def cast_value!(value, :integer) when is_integer(value), do: value

  def cast_value!(value, :integer) when is_float(value), do: trunc(value)

  def cast_value!(value, :integer) when is_binary(value) do
    case Integer.parse(value) do
      {num, _} -> num
      _ -> raise ArgumentError, "Unable to cast #{inspect(value)} to integer"
    end
  end

  def cast_value!(value, :float) when is_float(value), do: value

  def cast_value!(value, :float) when is_integer(value), do: value / 1

  def cast_value!(value, :float) when is_binary(value) do
    case Float.parse(value) do
      {num, _} -> num
      _ -> raise ArgumentError, "Unable to cast #{inspect(value)} to float"
    end
  end

  @spec cast_value_with_interval!(number | String.t(), cast_type, Interval.t()) ::
          integer | float
  def cast_value_with_interval!(value, type, interval) do
    value
    |> cast_value!(type)
    |> check_interval!(interval, value)
  end

  defp check_interval!(value, interval, orig_value) do
    if Interval.member?(interval, value) do
      value
    else
      raise %OutOfRangeError{value: orig_value, interval: interval}
    end
  end

  @spec cast_ratio!(number | String.t()) :: float
  def cast_ratio!(value) do
    cast_value_with_interval!(value, :float, @ratio_interval)
  end
end
