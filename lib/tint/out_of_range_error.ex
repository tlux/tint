defmodule Tint.OutOfRangeError do
  @moduledoc """
  An exception that is returned or raised when a color is built with values that
  are out of the permitted range of values.
  """

  defexception [:value, :interval]

  @type t :: %__MODULE__{
          value: any,
          interval: Tint.Utils.Interval.t()
        }

  @impl true
  def message(exception) do
    "Value #{exception.value} is out of range #{exception.interval}"
  end
end
