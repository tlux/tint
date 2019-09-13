defmodule Tint.UnconvertibleError do
  @moduledoc """
  An error that is returned or raised when a color could not be converted to
  a certain colorspace.
  """

  defexception [:from, :to]

  @typedoc """
  The error type.
  """
  @type t :: %__MODULE__{from: Tint.color(), to: Tint.colorspace()}

  @impl true
  def message(exception) do
    "Unable to convert #{inspect(exception.from)} to #{inspect(exception.to)}"
  end
end
