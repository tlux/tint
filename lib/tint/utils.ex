defmodule Tint.Utils do
  @moduledoc false

  alias Tint.OutOfRangeError
  alias Tint.Utils.Interval

  @byte_channel_interval Interval.new(0, 255)
  @degree_interval Interval.new(0, 360, exclude_max: true)
  @inclusive_degree_interval Interval.new(0, 360)
  @ratio_interval Interval.new(0, 1)

  @spec cast_byte_channel(Decimal.t() | number) ::
          {:ok, non_neg_integer} | {:error, OutOfRangeError.t()}
  def cast_byte_channel(value) do
    value
    |> cast_value(:integer)
    |> check_interval(@byte_channel_interval, value)
  end

  @spec cast_degrees(Decimal.t() | number) ::
          {:ok, Decimal.t()} | {:error, OutOfRangeError.t()}
  def cast_degrees(value) do
    value
    |> do_cast_degrees()
    |> check_interval(@degree_interval, value)
  end

  @spec cast_inclusive_degrees(Decimal.t() | number) ::
          {:ok, Decimal.t()} | {:error, OutOfRangeError.t()}
  def cast_inclusive_degrees(value) do
    value
    |> do_cast_degrees()
    |> check_interval(@inclusive_degree_interval, value)
  end

  defp do_cast_degrees(value) do
    value
    |> cast_value(:decimal)
    |> Decimal.round(1)
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
end
