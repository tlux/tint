defmodule Tint.Utils do
  @moduledoc false

  alias Tint.OutOfRangeError
  alias Tint.Utils.Interval

  @spec check_and_cast_value(
          :decimal | :integer,
          binary | number | Decimal.t(),
          nil | Interval.t()
        ) :: {:ok, number | Decimal.t()} | {:error, OutOfRangeError.t()}
  def check_and_cast_value(type, orig_value, interval \\ nil) do
    value = cast_value(type, orig_value)

    if is_nil(interval) || Interval.member?(interval, value) do
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

  defp cast_value(:integer, %Decimal{} = value) do
    value |> Decimal.round() |> Decimal.to_integer()
  end

  defp cast_value(:integer, value) when is_integer(value), do: value

  defp cast_value(:integer, value) when is_float(value), do: trunc(value)

  defp cast_value(:integer, value) when is_binary(value) do
    case Integer.parse(value) do
      {num, _} -> num
      _ -> raise ArgumentError, "could not cast #{inspect(value)} to integer"
    end
  end

  defp cast_value(:decimal, value) do
    value |> Decimal.cast() |> Decimal.reduce()
  end
end
