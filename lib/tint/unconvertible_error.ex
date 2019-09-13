defmodule Tint.UnconvertibleError do
  defexception [:from, :to]

  def message(exception) do
    "Unable to convert #{inspect(exception.from)} to #{inspect(exception.to)}"
  end
end
