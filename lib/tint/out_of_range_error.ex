defmodule Tint.OutOfRangeError do
  @moduledoc """
  An exception that is returned or raised when a color is built with values that
  are out of the permitted range of values.
  """

  defexception [:orig_value, :value, :interval]

  @type t :: %__MODULE__{
          orig_value: any,
          value: Decimal.t() | number,
          interval: Tint.Utils.Interval.t()
        }

  @impl true
  def message(exception) do
    "value #{exception.orig_value} is out of range #{exception.interval}"
  end
end
