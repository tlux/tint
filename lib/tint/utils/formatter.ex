defmodule Tint.Utils.Formatter do
  @moduledoc false

  @spec format_degrees(Decimal.t()) :: String.t()
  def format_degrees(value) do
    value
    |> Decimal.reduce()
    |> Decimal.to_string(:normal)
    |> Kernel.<>("°")
  end

  @spec format_percentage(Decimal.t()) :: String.t()
  def format_percentage(value) do
    value
    |> Decimal.mult(100)
    |> Decimal.reduce()
    |> Decimal.to_string(:normal)
    |> Kernel.<>("%")
  end
end
