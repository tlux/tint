defmodule Tint.Utils do
  @moduledoc false

  alias Tint.OutOfRangeError

  @type value :: Decimal.t() | number

  @spec value_in_range?(value, Range.t()) :: boolean
  def value_in_range?(value, range) do
    value_in_range?(value, range.first, range.last)
  end

  @spec value_in_range?(value, value, value) :: boolean
  def value_in_range?(%Decimal{} = value, min, max) do
    min = Decimal.cast(min)
    max = Decimal.cast(max)

    (Decimal.gt?(value, min) || Decimal.eq?(value, min)) &&
      (Decimal.eq?(value, max) || Decimal.lt?(value, max))
  end

  def value_in_range?(value, min, max) when is_number(value) do
    value >= min && value <= max
  end

  @spec check_value_in_range(value, Range.t()) ::
          :ok | {:error, OutOfRangeError.t()}
  def check_value_in_range(value, range) do
    check_value_in_range(value, range.first, range.last)
  end

  @spec check_value_in_range(value, value, value) ::
          :ok | {:error, OutOfRangeError.t()}
  def check_value_in_range(value, min, max) do
    if value_in_range?(value, min, max) do
      :ok
    else
      {:error, %OutOfRangeError{value: value, min: min, max: max}}
    end
  end
end
