defmodule Tint.Utils.Formatter do
  @moduledoc false

  @spec format_value(number) :: String.t()
  def format_value(value) do
    to_string(value)
  end

  @spec format_percentage(number) :: String.t()
  def format_percentage(value) do
    format_value(Float.round(value * 100, 2)) <> "%"
  end
end
