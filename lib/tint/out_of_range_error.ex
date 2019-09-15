defmodule Tint.OutOfRangeError do
  defexception [:value, :min, :max]

  @type t :: %__MODULE__{
          value: Decimal.t() | number,
          min: Decimal.t() | number,
          max: Decimal.t() | number
        }

  @impl true
  def message(exception) do
    "value #{inspect(exception.value)} is out of range " <>
      "(#{inspect(exception.min)}..#{inspect(exception.max)})"
  end
end
